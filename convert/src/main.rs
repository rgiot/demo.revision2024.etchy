use graphalgs::shortest_path::seidel;
use std::{collections::HashMap, fs::File, io::BufWriter, ops::Deref, path::Path};
use walky::datastructures::AdjacencyMatrix;

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

pub struct PicGraph {
    g: Graph<(usize, usize), (), Undirected>,
    grid: [[bool; 320]; 200],
    coord2node: std::collections::HashMap<(usize, usize), NodeIndex>,
    node2coord: std::collections::HashMap<NodeIndex, (usize, usize)>,
}

pub struct PicGraphPath<'g> {
    solution: Vec<NodeIndex>,
    g: &'g PicGraph,
}

impl Deref for PicGraph {
    type Target = Graph<(usize, usize), (), Undirected>;

    fn deref(&self) -> &Self::Target {
        &self.g
    }
}

impl<'g> Deref for PicGraphPath<'g> {
    type Target = Vec<NodeIndex>;
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
    /// Compute the shortest path
    pub fn compute_path(&self) -> PicGraphPath {
        // 1st step consists in computing the distance between each node (the path would be great too, but we'll recompute it later)
        dbg!("Start to compute distance matrix");
        let distances = seidel(&self.g);

        // 2nd step compute TSP on the complete graph where all nodes are connected to all others wieghted by the appropriate distance
        dbg!("Start to compute TSP");
        let mut adj = walky::datastructures::NAMatrix::from_dim(distances.len());
        for i in 0..(adj.dim() as usize) {
            for j in i..(adj.dim() as usize) {
                adj.set(i, j, distances[i][j] as f64);
                adj.set(j, i, distances[i][j] as f64);
            }
        }

        let (tsp_cost, tsp_solution) = walky::solvers::approximate::christofides::christofides::<
            { walky::computation_mode::PAR_COMPUTATION },
        >(&adj);

        dbg!("TSP cost", tsp_cost);
        let mut tsp_solution = tsp_solution;

        /// as an additional step we try to improve a bit with random exchanges
        let nb_nodes_in_graph = distances.len();
        let nb_nodes_in_path = tsp_solution.len();
        let _previous_cost = tsp_cost;
        let mut recomputed_cost = 0;
        for i in 0..(nb_nodes_in_graph - 1) {
            recomputed_cost += distances[tsp_solution[i]][tsp_solution[i + 1]];
        }
        recomputed_cost += distances[tsp_solution[nb_nodes_in_graph - 1]][tsp_solution[0]];

        let _swapped = tsp_solution.clone();
        let mut previous_cost = recomputed_cost as i32;
        let start_time = std::time::Instant::now();
        let mut last_cooling = std::time::Instant::now();
        let mut temperature = 5000.;
        let cooling = 0.99;
        loop {
            // allow to optimize during 10s
            if std::time::Instant::now()
                .duration_since(start_time)
                .as_secs()
                > 30
            {
                break;
            }

            if std::time::Instant::now()
                .duration_since(start_time)
                .as_millis()
                > 100
            {
                temperature *= cooling;
                last_cooling = std::time::Instant::now();
            }

            let i = rand::random::<usize>() % nb_nodes_in_graph;
            let j = rand::random::<usize>() % nb_nodes_in_graph;

            // skip if distance is wrong
            if i == j || (i == j + 1) || (j == i + 1) {
                continue;
            }
            // properly order
            let (i, j) = (i.min(j), i.max(j));

            // compute the cost of the new solution
            let gain = distances[tsp_solution[i]][tsp_solution[(j + 1) % nb_nodes_in_path]] as i32
                + distances[tsp_solution[(i + nb_nodes_in_path - 1) % nb_nodes_in_path]]
                    [tsp_solution[j]] as i32
                - distances[tsp_solution[(i + nb_nodes_in_path - 1) % nb_nodes_in_path]]
                    [tsp_solution[i]] as i32
                - distances[tsp_solution[j]][tsp_solution[(j + 1) % nb_nodes_in_path]] as i32;

            // replace it if needed
            let update = if gain > 0 {
                false
                /*
                    // eprint!("-");
                    use rand::Rng;
                    let proba = (rand::thread_rng().gen_range(0..=10000) as f64)/10000.;
                    let fy = 1.0/(previous_cost + gain) as f64;
                    let fx = 1.0/previous_cost as f64;
                    let factor = ((fy-fx)/temperature).exp();

                //    eprintln!("proba={}, factor={}, gain={}", proba, factor, gain);
                     if  proba > factor  && std::time::Instant::now().duration_since(start_time).as_secs() < 15 {
                       //  eprint!("#");
                         true
                     } else {
                     //    eprint!("-");
                         false
                     }
                     */
            } else {
                // eprint!("+");
                true
            };

            if update {
                // exchange i and j et revert between them
                for d in 0..=(j - i) {
                    if i + d >= j - d {
                        break;
                    }
                    tsp_solution.swap(i + d, j - d);
                }
                previous_cost += gain;
            }
        }

        let mut recomputed_cost2 = 0;
        for i in 0..(nb_nodes_in_graph - 1) {
            recomputed_cost2 += distances[tsp_solution[i]][tsp_solution[i + 1]];
        }
        recomputed_cost2 += distances[tsp_solution[nb_nodes_in_graph - 1]][tsp_solution[0]];
        eprintln!(
            "\nOptimized from {tsp_cost}/{recomputed_cost} to {previous_cost}/{recomputed_cost2}"
        );

        // TODO check if we can earn by ordering differently

        // 3rd really build the appropriate order
        let mut real_solution = Vec::<NodeIndex>::new();
        let nodes: Vec<_> = self.node_indices().collect();
        //dbg!(&nodes); // need to check ordering
        for tsp_idx in 0..(tsp_solution.len() - 1) {
            let curr_start = nodes[tsp_solution[tsp_idx + 0]];
            let curr_stop = nodes[tsp_solution[tsp_idx + 1]];

            // get path from curr_start to curr_stop
            let curr_path = if self.g.contains_edge(curr_start, curr_stop) {
                print!(".");
                vec![curr_start, curr_stop]
            } else {
                print!("#");
                let curr_path = petgraph::algo::astar(
                    &self.g,
                    curr_start,
                    |n| n == curr_stop,
                    |_e| 1,
                    |i| distances[curr_start.index()][i.index()],
                );
                curr_path.unwrap().1
            };

            // inject the path
            if let Some(last) = real_solution.last() {
                if *last == curr_start {
                    real_solution.pop(); // we remove the last because if will be reinjected
                }
            }
            real_solution.extend(&curr_path);
        }

        // With tsp we go back to the beginning but in fact we do not care
        // so here we remove the uneeded steps of the end
        dbg!("Remove end of the path that reuse nodes already drawn as it is a tour");
        let mut count_node_use = HashMap::<NodeIndex, usize>::default();
        for idx in real_solution.iter() {
            let count = count_node_use.entry(*idx).or_insert(0);
            *count += 1;
        }
        let initial_count = real_solution.len();
        loop {
            let last_idx = real_solution.last().unwrap();
            let count = count_node_use.get_mut(last_idx).unwrap();
            if *count == 1 {
                break;
            } else {
                *count += 1;
                real_solution.pop(); // remove the last one that is used for nothing
            }
        }
        let next_count = real_solution.len();
        println!("Reduce the number of main nodes from {initial_count} to {next_count}");

        print!("{}", real_solution.len());

        PicGraphPath {
            solution: real_solution,
            g: &self,
        }
    }
}

pub fn convert<P: AsRef<Path>>(ifname: P, ofname: &str, _exact: bool) {
    let g = PicGraph::from(ifname.as_ref());
    println!("{:?}", (g.node_count(), g.edge_count()));

    let path = g.compute_path();
    generate_code(ofname, &path);
}

// Generate the asm code
fn generate_code(ofname: &str, path: &PicGraphPath) {
    use std::io::Write;
    let f = File::create(ofname).expect("Unable to create output file");
    let mut w = BufWriter::new(f);

    let mut previous_coord = path.g.node_weight(*path.first().unwrap()).unwrap();
    let mut previous_code = "".to_owned();
    let mut previous_count = 0;
    writeln!(w, "\tSTART {}, {}", previous_coord.0, previous_coord.1);
    for i in &path[1..] {
        let current = path.g.node_weight(*i).unwrap();

        let mut code = "".to_owned();
        if previous_coord.1 == current.1 + 1 {
            code += "U";
        } else if current.1 == previous_coord.1 + 1 {
            code += "D";
        }

        if previous_coord.0 == current.0 + 1 {
            code += "L";
        } else if current.0 == previous_coord.0 + 1 {
            code += "R";
        }

        if code == previous_code {
            previous_count += 1;
        } else {
            if !previous_code.is_empty() {
                writeln!(w, "\t\t{previous_code} {previous_count}");
            }
            previous_count = 1;
            previous_code = code;
        }
        previous_coord = current;
    }
    if previous_count == 1 {
        writeln!(w, "\t\t{previous_code} {previous_count}");
    }
    writeln!(w, "\tSTOP (void)");
}

/// Generate a graph-view of the image. Crash if data is invalid and generate the image appropriatly
fn build_graph(grid: [[bool; CPC_WIDTH]; CPC_HEIGHT]) -> PicGraph {
    // (x,y) => idx
    let mut coord2node = std::collections::HashMap::<(usize, usize), NodeIndex>::default();
    // idx => (x,y)
    let mut node2coord = std::collections::HashMap::<NodeIndex, (usize, usize)>::default();

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
    }

    // Check if there are several components
    let components = petgraph::algo::kosaraju_scc(&g);
    if components.len() == 1 {
        PicGraph {
            g,
            grid,
            coord2node,
            node2coord,
        }
    } else {
        eprintln!(
            "[ERROR] There are {} components in the picture",
            components.len()
        );

        let mut layers = [[0; CPC_WIDTH]; CPC_HEIGHT];
        for (i, comp) in components.into_iter().enumerate() {
            for idx in comp.into_iter() {
                let (x, y) = node2coord.get(&idx).unwrap();
                layers[*y][*x] = i;
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
                        Rgb([0, 0, 120]),
                        Rgb([73, 13, 0]),
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
        panic!("Look at components.png");
    }
}

// Read the image and return it as a matrix of booleans
fn get_grid(fname: &Path) -> [[bool; 320]; 200] {
    // read data
    let img = image::open(fname)
        .expect("Unable to read image")
        .grayscale()
        .into_rgb8();

    // assert data validity
    assert_eq!(img.width() as usize, CPC_WIDTH, "Wrong image dimension");
    assert_eq!(img.height() as usize, CPC_HEIGHT, "Wrong image dimension");
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
        .arg(clap::Arg::new("INPUT").help("Input file to convert (bitmap format)").required(true))
        .arg(clap::Arg::new("OUTPUT").help("Output file to contains the asm code").required(true))
        .arg(clap::Arg::new("EXACT").help("Request an exact solution of the TSP. We don't care of global warming here. Anyway it will fail").action(ArgAction::SetTrue).long("exact"))
        ;
    let args = app.get_matches();

    convert(
        args.get_one::<String>("INPUT").unwrap().as_str(),
        args.get_one::<String>("OUTPUT").unwrap().as_str(),
        args.get_flag("EXACT"),
    );
}
