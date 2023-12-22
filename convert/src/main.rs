use std::{fs::File, io::BufWriter};

use image::{self, ColorType, GenericImageView, Rgb, RgbImage};
use petgraph::{self, stable_graph::{NodeIndex, IndexType}, data::Build, Graph, Undirected, algo::min_spanning_tree, graph::Node};

const CPC_WIDTH: usize = 320;
const CPC_HEIGHT: usize = 200;


pub fn convert(ifname: &str, ofname: &str) {
    let grid = get_grid(ifname);
    let g = build_graph(&grid);
    println!("{:?}", (g.node_count(),g.edge_count()));

    let path = compute_path(&g);
    generate_code(ofname, &g, &path);
}

// Generate the asm code
fn generate_code(ofname: &str, g: &Graph<(usize, usize), (), Undirected>, path: &[NodeIndex]) {
    use std::io::Write;
    let f = File::create(ofname).expect("Unable to create output file");
    let mut w = BufWriter::new(f);

    let mut previous = g.node_weight(*path.first().unwrap()).unwrap();
    writeln!(w, "\tSTART {}, {}", previous.0, previous.0);
    for i in &path[1..] {
        let current = g.node_weight(*i).unwrap();

        let mut code = "".to_owned();
        if previous.1 == current.1 + 1 {
            code += "U";
        }
        else if current.1 == previous.1 + 1 {
            code += "D";
        }

        if previous.0 == current.0 + 1 {
            code += "L";
        }
        else if current.0 == previous.0 + 1 {
            code += "R";
        }    
        writeln!(w, "\t\t{code} 1");
        previous = current;
    }
    writeln!(w, "\tSTOP (void)");


}

/// Compute the path. 
fn compute_path(g: &Graph<(usize, usize),(), Undirected>) -> Vec<NodeIndex> {
    // 1st step consists in computing the distance between each node (the path would be great too, but we'll recompute it later)
    use graphalgs::shortest_path::seidel;
    dbg!("Start to compute distance matrix");
    let distances = seidel(g);

    // 2nd step compute TSP on the complete graph where all nodes are connected to all others wieghted by the appropriate distance
    dbg!("Start to compute TSP");
    use walky::datastructures::AdjacencyMatrix;
    let mut adj = walky::datastructures::NAMatrix::from_dim(distances.len());
    for i in 0..(adj.dim() as usize) {
        for j in i..(adj.dim() as usize) {
            adj.set(i, j, distances[i][j] as f64);
            adj.set(j, i, distances[i][j] as f64);
        }
    }
    let tsp_solution = walky::solvers::approximate::christofides::christofides::<{walky::computation_mode::PAR_COMPUTATION}>(&adj);
    dbg!("TSP cost", tsp_solution.0);

    // 3rd really build the appropriate order
    let mut real_solution = Vec::<NodeIndex>::new();
    let nodes : Vec<_> = g.node_indices().collect();
    //dbg!(&nodes); // need to check ordering
    for tsp_idx in 0..(tsp_solution.1.len()-1) {
        let curr_start = nodes[tsp_solution.1[tsp_idx+0]];
        let curr_stop = nodes[tsp_solution.1[tsp_idx+1]];

        // get path from curr_start to curr_stop
        let curr_path = if g.contains_edge(curr_start, curr_stop) {
            print!(".");
            vec![curr_start, curr_stop]
        } else {
            print!("#");
            let curr_path = petgraph::algo::astar(
                g,
                curr_start,
                |n| n == curr_stop,
                |e| 1,
                |i| distances[curr_start.index()][i.index()]
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

        print!("{}", real_solution.len());
    }
    real_solution
}

/// Generate a graph-view of the image. Crash if data is invalid and generate the image appropriatly
fn build_graph(grid: &[[bool; CPC_WIDTH]; CPC_HEIGHT] ) -> Graph<(usize, usize),(), Undirected> {

    // (x,y) => idx
    let mut coord2node = std::collections::HashMap::<(usize,usize), NodeIndex>::default();
    // idx => (x,y)
    let mut node2coord = std::collections::HashMap::<NodeIndex, (usize,usize)>::default();

    let mut g = petgraph::Graph::new_undirected();

    // create nodes
    for x in 0..CPC_WIDTH {
        for y in 0..CPC_HEIGHT {

            if grid[y][x] {
                let idx = g.add_node((x, y));
                coord2node.insert((x,y), idx);
                node2coord.insert(idx, (x,y));
            }
        }
    }

    // connect nodes
    for ((x,y), idx1) in coord2node.iter() {
        if *x < (CPC_WIDTH-1) {
            if grid[*y][*x+1] {
                let idx2 = coord2node.get(&(*x+1, *y)).unwrap();
                g.add_edge(*idx1, *idx2, ());
            }
        }

        if *y > 0 {
            if grid[*y-1][*x] {
                let idx2 = coord2node.get(&(*x, *y-1)).unwrap();
                g.add_edge(*idx1, *idx2, ());                
            }
        }


        if *x < (CPC_WIDTH-1)  && *y > 0 {
            if grid[*y-1][*x+1] && !grid[*y-1][*x] && !grid[*y][*x+1] {
                let idx2 = coord2node.get(&(*x+1, *y-1)).unwrap();
                g.add_edge(*idx1, *idx2, ()); 
            }
        }

        if *x < (CPC_WIDTH-1)  && *y < (CPC_HEIGHT-1) {
            if grid[*y+1][*x+1] && !grid[*y][*x+1] && !grid[*y+1][*x] {
                let idx2 = coord2node.get(&(*x+1, *y+1)).unwrap();
                g.add_edge(*idx1, *idx2, ()); 
            }
        }
    }


    // Check if there are several components
    let components = petgraph::algo::kosaraju_scc(&g);
    if components.len() == 1 {
        return g
    } else {
        eprintln!("[ERROR] There are {} components in the picture", components.len());

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
                    Rgb([255,255,255])
                } else {
                    let palette = [
                        Rgb([0,89,0]),
                        Rgb([0,0,120]),
                        Rgb([73,13,0]),
                        Rgb([138,3,79]),
                        Rgb([0,90,138]),
                        Rgb([68,53,0]),
                        Rgb([88,88,88]),
                    ];

                    palette[layers[y][x]  % palette.len()]
                };

                imgerr.put_pixel(x as _, y as _, color);

            }
        }


        imgerr.save("components.png").unwrap();
        panic!("Look at components.png");
    }

    g
}


// Read the image and return it as a matrix of booleans
fn get_grid(fname: &str) -> [[bool; 320]; 200] {

    // read data
    let img = image::open(fname).expect("Unable to read image").grayscale().into_rgb8();

    // assert data validity
    assert_eq!(img.width() as usize, CPC_WIDTH, "Wrong image dimension");
    assert_eq!(img.height() as usize, CPC_HEIGHT, "Wrong image dimension");
    let colors = img.pixels().collect::<std::collections::HashSet<_>>();
    assert_eq!(colors.len(), 2, "Only black and white are expected");

    // create binary data
        let mut grid: [[bool; 320]; 200] = [
            [false; CPC_WIDTH as usize]; CPC_HEIGHT as usize
        ];
        for x in 0..CPC_WIDTH {
            for y in 0..CPC_HEIGHT {
                let row = grid.get_mut(y as usize).unwrap();
                row[x as usize] = *img.get_pixel(x as _, y as _) == Rgb([0,0,0]);
            }
        }
        grid

}



fn main() {
    let app = clap::Command::new("EtchASketchConvert")
        .about("Generate data files for EtchASketch for CPC")
        .author("Krusty/Benediction")
        .arg(clap::Arg::new("INPUT").help("Input file to convert (bitmap format)").required(true))
        .arg(clap::Arg::new("OUTPUT").help("Output file to contains the asm code").required(true));
    let args = app.get_matches();

    convert(
        args.get_one::<String>("INPUT").unwrap().as_str(),
        args.get_one::<String>("OUTPUT").unwrap().as_str(),
    );
}
