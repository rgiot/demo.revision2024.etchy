use graphalgs::shortest_path::seidel;
use indicatif::ParallelProgressIterator;
use itertools::Itertools;
use ordered_float::OrderedFloat;
use rayon::iter::{ParallelBridge, ParallelIterator, IntoParallelRefIterator};
use std::{
    collections::{HashMap, HashSet, VecDeque},
    env::current_exe,
    fs::File,
    io::BufWriter,
    ops::{Deref, DerefMut},
    path::{Path, Display},
    rc::Rc,
};
use walky::{datastructures::AdjacencyMatrix, solvers::approximate::{christofides::christofides, nearest_neighbour::nearest_neighbour}, computation_mode::PAR_COMPUTATION};

use clap::ArgAction;
use image::{self, GenericImageView, Rgb, RgbImage};
use petgraph::{
    self,
    data::Build,
    stable_graph::{IndexType, NodeIndex},
    Graph, Undirected,
};

const CPC_WIDTH: usize = 320;
const CPC_HEIGHT: usize = 200;
const OPTIMISATION_DURATION: u64 = 15;

type Coord = (usize, usize);

pub struct PicGraph {
    g: Graph<Coord, (), Undirected>,
    grid: [[bool; 320]; 200],
    coord2node: std::collections::HashMap<Coord, NodeIndex>,
    node2coord: std::collections::HashMap<NodeIndex, Coord>,
}

/// This is the solution on the complete graph.
/// Thus several edges are not present in the image and have
/// to be replaced by sub-paths. This is the aim of `final_path`` method
#[derive(Clone)]
pub struct PicCompleteGraphPath<'g> {
    distances: Vec<Vec<u32>>,
    solution: Vec<NodeIndex>,
    g: &'g PicGraph,
}

pub struct PicGraphPath {
    solution: Vec<Coord>,
}

impl Deref for PicGraph {
    type Target = Graph<Coord, (), Undirected>;

    fn deref(&self) -> &Self::Target {
        &self.g
    }
}

impl<'g> Deref for PicCompleteGraphPath<'g> {
    type Target = Vec<NodeIndex>;
    fn deref(&self) -> &Self::Target {
        &self.solution
    }
}

impl Deref for PicGraphPath {
    type Target = Vec<Coord>;
    fn deref(&self) -> &Self::Target {
        &self.solution
    }
}

impl From<&Path> for PicGraph {
    /// Load and build the graph structure. panic in case of error
    fn from(ifname: &Path) -> Self {
        let grid = get_grid(ifname);
        build_graph(grid)
    }
}

impl PicGraph {
    pub fn get_node_index(&self, c: &Coord) -> Option<NodeIndex> {
        self.coord2node.get(c).cloned()
    }

    /// Return all possible coords
    pub fn coords(&self) -> HashSet<Coord> {
        self.coord2node.keys().into_iter().cloned().collect()
    }

    /// Compute the shortest path
    pub fn compute_path(&self) -> PicCompleteGraphPath {
        // 1st step consists in computing the distance between each node (the path would be great too, but we'll recompute it later)
        dbg!("Start to compute distance matrix");
        let mut distances = seidel(&self.g);
        let nodes: Vec<NodeIndex> = self.g.node_indices().collect();


        // XXX modify the distances to make long distances even worst
        distances.iter_mut().par_bridge()
            .for_each(|row| row.iter_mut().for_each(|val| *val = val.pow(2)*10 ));

        // 2nd step compute TSP on the complete graph where all nodes are connected to all others wieghted by the appropriate distance
        dbg!("Start to compute TSP");
        let mut adj = walky::datastructures::NAMatrix::from_dim(distances.len());
        for i in 0..(adj.dim() as usize) {
            for j in i..(adj.dim() as usize) {
                adj.set(i, j, distances[i][j] as f64);
                adj.set(j, i, distances[i][j] as f64);
            }
        }

        // try christfies and nearest neighbourgs and keep the best
        let (tsp_cost, tsp_solution) = (0..2).par_bridge()
        .map(|i| {
            let (tsp_cost, tsp_solution) = 
            
            if i==0 {
                christofides::<{PAR_COMPUTATION }>(&adj)
            }
            else {
                nearest_neighbour::<{PAR_COMPUTATION}>(&adj)
            };

            (OrderedFloat::from(tsp_cost), tsp_solution)
        }).min().unwrap();

        dbg!("TSP cost", tsp_cost);
        let tsp_solution = tsp_solution;

        PicCompleteGraphPath {
            solution: tsp_solution
                .into_iter()
                .map(|i| nodes[i])
                .collect::<Vec<_>>(),
            distances,
            g: &self,
        }
    }
}

impl<'g> PicCompleteGraphPath<'g> {
    pub fn g(&self) -> &Graph<Coord, (), Undirected> {
        &self.g
    }

    /// Compute the cost of the current path
    pub fn cost(&self) -> u32 {
        (0..(self.distances.len() - 1))
            .into_iter()
            .map(|i| self.distances[self.solution[i].index()][self.solution[i + 1].index()])
            .sum()
    }

    /// Compute the gain when swapping two nodes in the path
    pub fn swap_gain(&self, i: usize, j: usize) -> i32 {
        let nb_nodes_in_path = self.solution.len();

        self.distances[self.solution[i].index()][self.solution[(j + 1) % nb_nodes_in_path].index()]
            as i32
            + self.distances[self.solution[(i + nb_nodes_in_path - 1) % nb_nodes_in_path].index()]
                [self.solution[j].index()] as i32
            - self.distances[self.solution[(i + nb_nodes_in_path - 1) % nb_nodes_in_path].index()]
                [self.solution[i].index()] as i32
            - self.distances[self.solution[j].index()]
                [self.solution[(j + 1) % nb_nodes_in_path].index()] as i32
    }

    /// Generate an optimized path that finish in the best nodes among a list of nodes
    pub fn optimize_finish_among(&mut self, among: &HashSet<Coord>) {
        self.optimize(); // generate a good tour
        eprintln!("Cost before fixing the end {}", self.cost());

        // get the gain of the solution among the standard path, the position of the end node and its coordinates in pixle
        let (cost, idx, coord, n, modified_solution) = among
            .iter()
            .map(|coord| {
                let n = self.g.get_node_index(coord).unwrap(); // get the node at the given end coordinate
                let idx = self.solution.iter().position(|n2| n == *n2).unwrap(); // get its position in the current solution

                let mut modified_solution = self.clone();
                let delta = modified_solution.solution.len() - idx - 1;
                modified_solution.solution.rotate_right(delta);

                let cost = modified_solution.cost();
                (cost, idx, coord, n, modified_solution)
            })
            .min_by_key(|v| v.0)
            .unwrap();

        *self = modified_solution;
        eprintln!("Cost after  selecting the end {}", self.cost());

        // optimize the path by always keeping the last node fixed
        self.optimize_between(0, self.len() - 2);
        assert_eq!(
            Some(n),
            self.solution.last().cloned(),
            "BUG the path does not finish as expected"
        );
        eprintln!("Cost after optimizing the end {}", self.cost());
    }

    pub fn optimize_start_here(&mut self, start: Coord) {
        // generate a good tour starting at the appropriate position
        let ns = self.g.get_node_index(&start).unwrap(); // get the node at the given end coordinate
        let idx = self.solution.iter().position(|n2| ns == *n2).unwrap(); // get its position in the current solution
        self.solution.rotate_left(idx);
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );

        self.optimize_between(1, self.solution.len() - 1);
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );
    }

    pub fn optimize_start_here_and_finish_among(&mut self, start: Coord, among: &HashSet<Coord>) {
        // generate a good tour starting at the appropriate position
        let ns = self.g.get_node_index(&start).unwrap(); // get the node at the given end coordinate
        let idx = self.solution.iter().position(|n2| ns == *n2).unwrap(); // get its position in the current solution
        self.solution.swap(idx, 0);
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );

        self.optimize_between(1, self.solution.len() - 1);
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );

        eprintln!(
            "Cost after fixing the start and before fixing the end {}",
            self.cost()
        );

        // get the gain of the solution among the standard path, the position of the end node and its coordinates in pixle
        let (cost, new_solution, ne) = among
            .iter()
            .filter(|&&c| c != start)
            .map(|coord| {
                let n = self.g.get_node_index(coord).unwrap(); // get the node at the given end coordinate
                let idx = self.solution.iter().position(|n2| n == *n2).unwrap(); // get its position in the current solution

                // 1st rotation to move the end node to the end
                let mut new_solution: PicCompleteGraphPath = self.clone();
                let delta = new_solution.solution.len() - idx - 1;
                new_solution.solution.rotate_right(delta);

                // swap to ensure start is back at start
                new_solution.swap_path(0, delta);
                let cost = new_solution.cost();

                (cost, new_solution.solution, n)
            })
            .min()
            .unwrap();

        self.solution = new_solution;
        assert_eq!(
            Some(ne),
            self.solution.last().cloned(),
            "BUG the path does not finish as expected"
        );
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );
        eprintln!("Cost after  selecting the end {}", self.cost());

        // optimize the path by always keeping the last node fixed
        // the optimisation is done 4 times to try to overcome a low quality
        // due to the various constraints
        self.optimize_between(1, self.len() - 2);
        assert_eq!(
            Some(ne),
            self.solution.last().cloned(),
            "BUG the path does not finish as expected"
        );
        assert_eq!(
            Some(ns),
            self.solution.first().cloned(),
            "BUG the path does not start as expected"
        );
        eprintln!("Cost after optimizing the end {}", self.cost());
    }

    /// Try to optimize the path
    /// start and stop included
    pub fn optimize_between(&mut self, start: usize, stop: usize) {
        // as an additional step we try to improve a bit with random exchanges
        let _nb_nodes_in_path = self.solution.len();
        let recomputed_cost = self.cost();

        let previous_cost = recomputed_cost as i32;
        let start_time = std::time::Instant::now();

        let indexes = (start..stop)
        .into_iter()
        .map(|i| (i + 1..stop).into_iter().map(move |j| (i, j)))
        .flatten()
        .collect_vec();

        loop {
            // allow to optimize during 10s
            if std::time::Instant::now()
                .duration_since(start_time)
                .as_secs()
                > OPTIMISATION_DURATION
            {
                break;
            }

            let (min_gain, i, j) = indexes.par_iter().progress()
                .map(|(i, j)| (self.swap_gain(*i, *j), *i, *j))
                .min()
                .unwrap();

            if min_gain <= 0 {
                self.swap_path(i, j);
            }else {
                break;
            }
            /*
            for i in rand_start..rand_stop {
                let j = i + rand::random::<usize>() % (rand_stop -i);

                // skip if distance is wrong
                if i == j || (i == j + 1) || (j == i + 1) {
                    continue;
                }
                // properly order
                let (i, j) = (i.min(j), i.max(j));

                // compute the cost of the new solution
                let gain = self.swap_gain(i, j);
                // replace it if needed
                let update = if gain > 0 { false } else { true };

                if update {
                    self.swap_path(i, j);
                    previous_cost += gain;
                }
            }

                */
        }

        let recomputed_cost2 = self.cost();
        eprintln!("\nOptimized from {recomputed_cost} to {previous_cost}/{recomputed_cost2}");
    }

    fn swap_path(&mut self, i: usize, j: usize) {
        for d in 0..=(j - i) {
            if i + d >= j - d {
                break;
            }
            self.solution.swap(i + d, j - d);
        }
    }

    /// Try to optimize the path
    pub fn optimize(&mut self) {

        return self.optimize_between(0, self.solution.len());


    }

    pub fn final_path(&self, shrink: Shrink) -> PicGraphPath {
        let tsp_solution = &self.solution;
        // 3rd really build the appropriate order
        let mut real_solution = VecDeque::<NodeIndex>::new();
        //dbg!(&nodes); // need to check ordering
        for tsp_idx in 0..(tsp_solution.len() - 1) {
            let curr_start = tsp_solution[tsp_idx + 0];
            let curr_stop = tsp_solution[tsp_idx + 1];

            // get path from curr_start to curr_stop
            let curr_path = if self.g.contains_edge(curr_start, curr_stop) {
                eprint!(".");
                vec![curr_start, curr_stop]
            } else {
                eprint!("#");
                let curr_path = petgraph::algo::astar(
                    &self.g.g,
                    curr_start,
                    |n| n == curr_stop,
                    |_e| 1,
                    |i| self.distances[curr_start.index()][i.index()],
                );
                curr_path.unwrap().1
            };

            // inject the path
            if let Some(last) = real_solution.back() {
                if *last == curr_start {
                    real_solution.pop_back(); // we remove the last because if will be reinjected
                }
            }
            real_solution.extend(&curr_path);
        }

        // remove nodes at beginning and end that are drawned seeveral times
        dbg!("Remove end of the path that reuse nodes already drawn as it is a tour");
        let mut count_node_use = HashMap::<NodeIndex, usize>::default();
        for idx in real_solution.iter() {
            let count = count_node_use.entry(*idx).or_insert(0);
            *count += 1;
        }
        let initial_count = real_solution.len();

        if shrink == Shrink::Both || shrink == Shrink::Start {
            loop {
                let last_idx = real_solution.front().unwrap();
                let count = count_node_use.get_mut(last_idx).unwrap();
                if *count == 1 {
                    break; // if we remove it, it is not drawned !
                } else {
                    *count += 1;
                    real_solution.pop_front(); // remove the last one that is used for nothing
                }
            }
        }

        if shrink == Shrink::Both || shrink == Shrink::End {
            loop {
                let last_idx = real_solution.back().unwrap();
                let count = count_node_use.get_mut(last_idx).unwrap();
                if *count == 1 {
                    break; // if we remove it, it is not drawned !
                } else {
                    *count += 1;
                    real_solution.pop_back(); // remove the last one that is used for nothing
                }
            }
        }

        let next_count = real_solution.len();
        println!("Reduce the number of main nodes from {initial_count} to {next_count}");

        print!("{}", real_solution.len());

        PicGraphPath {
            solution: real_solution
                .into_iter()
                .map(|i| *self.g().node_weight(i).unwrap())
                .collect(),
        }
    }
}

/*
impl<'g> PicGraphPath<'g> {
    pub fn g(&self) -> &Graph<Coord, (), Undirected> {
        &self.g
    }
}
*/

/// Launch the conversion
///
pub fn convert<P: AsRef<Path>>(ifname: &[P], ofname: &str, _exact: bool) {
    // open all images parts
    let mut parts: Vec<_> = ifname
        .into_iter()
        .map(|f| {
            eprintln!("Load {}", f.as_ref().display());
            PicGraph::from(f.as_ref())
        })
        .collect();

    // check if they are connected
    let mut intersections = Vec::new();
    for i in 0..(parts.len() - 1) {
        let coords_a = parts[i].coords();
        let coords_b = parts[i + 1].coords();

        let inter: HashSet<_> = coords_a.intersection(&coords_b).cloned().collect();
        if inter.is_empty() {
            panic!(
                "{} and {} have no pixels in common",
                ifname[i].as_ref().display(),
                ifname[i + 1].as_ref().display()
            );
        } else {
            intersections.push(inter);
        }
    }

    if parts.len() == 1 {
        let mut c_path = parts[0].compute_path();
        c_path.optimize();
        let f_path = c_path.final_path(Shrink::Both);
        generate_code(ofname, &f_path);
    } else {
        let mut full_path = Vec::new();

        let mut already_drawned = HashSet::<Coord>::new();
        let mut next_start = None;
        for (i, current_g) in parts.iter().enumerate() {
            let mut c_path = current_g.compute_path();

            let selected_end_intersection = if i != parts.len() - 1 {
                let selected_intersections: HashSet<Coord> = intersections[i]
                    .iter()
                    .filter(|idx| {
                        let n = current_g.get_node_index(*idx).unwrap();
                        current_g.g.neighbors(n).count() == 1
                    })
                    .cloned()
                    .collect();
                eprintln!(
                    "{} ends are possible among {}",
                    selected_intersections.len(),
                    intersections[i].len()
                );
                Some(selected_intersections)
            } else {
                None
            };

            let mut f_path = if i == 0 {
                // select one end  and optimize
                let selected_end_intersections = selected_end_intersection.as_ref().unwrap();
                c_path.optimize_finish_among(selected_end_intersections);
                c_path.final_path(Shrink::Start)
            } else if i != parts.len() - 1 {
                // continue from last end, select one end, and optimize
                let selected_end_intersections = selected_end_intersection.as_ref().unwrap();
                c_path.optimize_start_here_and_finish_among(
                    next_start.unwrap(),
                    selected_end_intersections,
                );
                c_path.final_path(Shrink::None)
            } else {
                // continue from last end and optimize
                c_path.optimize_start_here(next_start.unwrap());
                c_path.final_path(Shrink::End)
            };

            next_start = c_path
                .solution
                .last()
                .map(|i| *current_g.node_weight(*i).unwrap());

            full_path.append(&mut f_path.solution);
        }

        generate_code(
            ofname,
            &PicGraphPath {
                solution: full_path.into_iter().dedup().collect_vec(),
            },
        );
    }
}

#[derive(PartialEq)]
pub enum Shrink {
    Start,
    End,
    Both,
    None,
}

#[derive(PartialEq, Copy, Clone, Debug)]
pub enum Command {
    Up, Down, 
    Left, Right,
    UpLeft, UpRight,
    DownLeft, DownRight
}


impl std::fmt::Display for Command {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let code = match self {
            Command::Up => "U",
            Command::Down => "D",
            Command::Left => "L",
            Command::Right => "R",
            Command::UpLeft => "UL",
            Command::UpRight => "UR",
            Command::DownLeft => "DL",
            Command::DownRight => "DR",
        };
        write!(f, "{code}")
    }
}

impl Command {
    pub fn add_command(other: &mut Option<Self>, extra: Command) {
        let res = other.map(|previous| {
            match (previous, extra) {
                (Command::Up, Command::Left) => Command::UpLeft,
                (Command::Up, Command::Right) => Command::UpRight,
                (Command::Down, Command::Left) => Command::DownLeft,
                (Command::Down, Command::Right) => Command::DownRight,
                _ => unimplemented!()
            }
        })
            .or_else(move || Some(extra));

        *other = res;
    }


    pub fn rev(&self) -> Self {
        match self {
            Command::Up => Command::Down,
            Command::Down => Command::Up,
            Command::Left => Command::Right,
            Command::Right => Command::Left,
            Command::UpLeft => Command::DownRight,
            Command::UpRight => Command::DownLeft,
            Command::DownLeft => Command::UpRight,
            Command::DownRight => Command::UpLeft,
        }
    }
}

pub struct FromCommand {
    coord: (usize, usize),
    cmd: Command
}


// Generate the asm code
fn generate_code(ofname: &str, path: &PicGraphPath) {





    let start_coord = *path.first().unwrap();


    // build the list of commands
    let mut commands = Vec::new();
    let mut previous_coord = start_coord;

    for current_coord in &path[1..] {
        let mut current_cmd = None;
        if previous_coord.1 == current_coord.1 + 1 {
            current_cmd = Some(Command::Up);
        } else if current_coord.1 == previous_coord.1 + 1 {
            current_cmd = Some(Command::Down);
        }

        if previous_coord.0 == current_coord.0 + 1 {
            Command::add_command(&mut current_cmd, Command::Left);
        } else if current_coord.0 == previous_coord.0 + 1 {
            Command::add_command(&mut current_cmd, Command::Right);
        }

        previous_coord = *current_coord;
        commands.push(current_cmd.unwrap());
    }

    // XXX filter the  commands to remove noise
    loop {
        let pattern = [Command::Left, Command::Right, Command::Left, Command::Right];

        // L L R L
        for idx in 0..(commands.len()-pattern.len()) {
            if  commands[idx+0] == commands[idx+1] &&
                commands[idx+0] == commands[idx+3] &&
                commands[idx+0] == commands[idx+2].rev() {
                    panic!("Need to handle this case {:?}", &commands[idx..(idx+4)]);
                }
        }


        eprintln!("Nothing to optiize");
        break
    }

    // aggregate the commands
    let mut aggregated_commands = Vec::new();
    for current_command in commands.into_iter() {
        if aggregated_commands.is_empty() {
            aggregated_commands.push((current_command, 1));
        } else {
            let (previous_command, previous_count) = aggregated_commands.last_mut().unwrap();
            if *previous_command == current_command {
                *previous_count += 1;
            } else {
                aggregated_commands.push((current_command, 1));
            }
        }
    }

    // generate the code from the list of commands
    use std::io::Write;
    let f = File::create(ofname).expect("Unable to create output file");
    let mut w = BufWriter::new(f);

    writeln!(w, "\tSTART {}, {}", start_coord.0, start_coord.1);
    for (cmd, count) in aggregated_commands.into_iter() {
        writeln!(w, "\t\t{cmd} {count}");

    }

    writeln!(w, "\tSTOP (void)");
}

/// Generate a graph-view of the image. Crash if data is invalid and generate the image appropriatly
fn build_graph(grid: [[bool; CPC_WIDTH]; CPC_HEIGHT]) -> PicGraph {
    // (x,y) => idx
    let mut coord2node = std::collections::HashMap::<Coord, NodeIndex>::default();
    // idx => (x,y)
    let mut node2coord = std::collections::HashMap::<NodeIndex, Coord>::default();

    let mut g = petgraph::Graph::new_undirected();

    // create nodes
    for x in 0..CPC_WIDTH {
        for y in 0..CPC_HEIGHT {
            if grid[y][x] {
                let idx = g.add_node((x, y));
                coord2node.insert((x, y), idx);
                node2coord.insert(idx, (x, y));
            }
        }
    }

    // connect nodes
    // TODO finally add ALL connections, it may help to have nicer paths
    for ((x, y), idx1) in coord2node.iter() {
        if *x < (CPC_WIDTH - 1) && grid[*y][*x + 1] {
            let idx2 = coord2node.get(&(*x + 1, *y)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }

        if *y < (CPC_HEIGHT - 1) && grid[*y + 1][*x] {
            let idx2 = coord2node.get(&(*x, *y + 1)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }
        if *y > 0 && grid[*y - 1][*x] {
            let idx2 = coord2node.get(&(*x, *y - 1)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }

        if *x > 0 && grid[*y][*x - 1] {
            let idx2 = coord2node.get(&(*x - 1, *y)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }

        if *x < (CPC_WIDTH - 1) && *y < (CPC_HEIGHT - 1) && grid[*y + 1][*x + 1] {
            let idx2 = coord2node.get(&(*x + 1, *y + 1)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }

        if *x < (CPC_WIDTH - 1) && *y > 0 && grid[*y - 1][*x + 1] {
            let idx2 = coord2node.get(&(*x + 1, *y - 1)).unwrap();
            g.add_edge(*idx1, *idx2, ());
        }

        /*
        if *x < (CPC_WIDTH - 1) {
            if grid[*y][*x + 1] {
                let idx2 = coord2node.get(&(*x + 1, *y)).unwrap();
                g.add_edge(*idx1, *idx2, ());
            }
        }

        if *y > 0 {
            if grid[*y - 1][*x] {
                let idx2 = coord2node.get(&(*x, *y - 1)).unwrap();
                g.add_edge(*idx1, *idx2, ());
            }
        }

        if *x < (CPC_WIDTH - 1) && *y > 0 {
            if grid[*y - 1][*x + 1] && !grid[*y - 1][*x] && !grid[*y][*x + 1] {
                let idx2 = coord2node.get(&(*x + 1, *y - 1)).unwrap();
                g.add_edge(*idx1, *idx2, ());
            }
        }

        if *x < (CPC_WIDTH - 1) && *y < (CPC_HEIGHT - 1) {
            if grid[*y + 1][*x + 1] && !grid[*y][*x + 1] && !grid[*y + 1][*x] {
                let idx2 = coord2node.get(&(*x + 1, *y + 1)).unwrap();
                g.add_edge(*idx1, *idx2, ());
            }
        }
        */
    }

    // Check if there are several components
    let components = petgraph::algo::kosaraju_scc(&g);
    if components.len() == 1 {
        return PicGraph {
            g,
            grid,
            coord2node,
            node2coord,
        };
    } else {
        eprintln!(
            "[ERROR] There are {} components in the picture",
            components.len()
        );

        let mut layers = [[0; CPC_WIDTH]; CPC_HEIGHT];
        for (i, comp) in components.iter().enumerate() {
            eprintln!("{} pixels", comp.len());
            for idx in comp.into_iter() {
                let (x, y) = node2coord.get(&idx).unwrap();
                layers[*y][*x] = i + 1;
            }
        }

        let mut imgerr = RgbImage::new(CPC_WIDTH as _, CPC_HEIGHT as _);
        for x in 0..CPC_WIDTH {
            for y in 0..CPC_HEIGHT {
                let color = if layers[y][x] == 0 {
                    Rgb([255, 255, 255])
                } else {
                    let palette = [
                        Rgb([0, 89, 0]),
                        Rgb([73, 13, 0]),
                        Rgb([0, 0, 120]),
                        Rgb([138, 3, 79]),
                        Rgb([0, 90, 138]),
                        Rgb([68, 53, 0]),
                        Rgb([88, 88, 88]),
                    ];

                    palette[layers[y][x] % palette.len()]
                };

                imgerr.put_pixel(x as _, y as _, color);
            }
        }

        imgerr.save("components.png").unwrap();
        panic!(
            "Look at components.png, there are {} connected components",
            components.len()
        );
    }
}

// Read the image and return it as a matrix of booleans
fn get_grid(fname: &Path) -> [[bool; 320]; 200] {
    // read data
    let mut img = image::open(fname)
        .expect("Unable to read image")
        .grayscale()
        .into_rgb8();

    // assert data validity
    assert_eq!(img.width() as usize, CPC_WIDTH, "Wrong image dimension");
    assert_eq!(img.height() as usize, CPC_HEIGHT, "Wrong image dimension");
    img.pixels_mut().for_each(|p| {
        *p = if p.0[0] > 127 || p.0[1] > 127 || p.0[2] > 127 {
            Rgb([255, 255, 255])
        } else {
            Rgb([0, 0, 0])
        };
    }); // convert in 2 colors

    let img = img;
    let colors = img.pixels().collect::<std::collections::HashSet<_>>();
    assert_eq!(colors.len(), 2, "Only black and white are expected");

    // create binary data
    let mut grid: [[bool; 320]; 200] = [[false; CPC_WIDTH as usize]; CPC_HEIGHT as usize];
    for x in 0..CPC_WIDTH {
        for y in 0..CPC_HEIGHT {
            let row = grid.get_mut(y as usize).unwrap();
            row[x as usize] = *img.get_pixel(x as _, y as _) == Rgb([0, 0, 0]);
        }
    }
    grid
}

fn main() {
    let app = clap::Command::new("EtchASketchConvert")
        .about("Generate data files for EtchASketch for CPC")
        .author("Krusty/Benediction")
        .arg(clap::Arg::new("INPUT").help("Input file to convert (bitmap format)").required(true).num_args(1..))
        .arg(clap::Arg::new("OUTPUT").help("Output file to contains the asm code").required(true))
        .arg(clap::Arg::new("EXACT").help("Request an exact solution of the TSP. We don't care of global warming here. Anyway it will fail").action(ArgAction::SetTrue).long("exact"))
        ;
    let args = app.get_matches();

    let ifname: Vec<_> = args
        .get_many::<String>("INPUT")
        .unwrap()
        .into_iter()
        .map(|s| s.as_str())
        .collect();
    convert(
        &ifname,
        args.get_one::<String>("OUTPUT").unwrap().as_str(),
        args.get_flag("EXACT"),
    );
}
