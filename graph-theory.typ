#import "@preview/cetz:0.3.1" 

#let nodemaker(thing, nodes, edges) = {
    let node_index = nodes.position(item => item == thing)
    return (node_index*1.5, 0)
}

#let linker(first, second, shift) = {
    let (x1, y1) = first
    let (x2, y2) = second

    if shift == -1 {
        return ((x1+-0.3, y1+0.3), (x2+0.3, x2+0.3), (x1+-1, y1+1.5), (x1+1, y1+1.5))
    }

    if x1 < x2 {
        return ((x1+0.5, y1), (x2+-0.5, y2), ((x1+x2)/2, (y1+y2)/2+shift))
    }

    if x1 >= x2 {
        return ((x1+-0.5, y1), (x2+0.5, y2), ((x1+x2)/2, (y1+y2)/2+shift))
    }
}

#let arrowmaker(arrow, nodes, edges) = {
    let (first, second) = arrow
    let shift = 0 

    if first == second {
        shift = -1
    }

    let indexOfFirst = nodes.position(item => item == first)
    let indexOfSecond = nodes.position(item => item == second)

    if calc.abs(indexOfFirst - indexOfSecond) > 1 {
        shift = calc.pow(calc.abs(indexOfFirst - indexOfSecond), 1.6)*0.4
    }

    if calc.rem(indexOfFirst, 2) == 1 {
        shift = -shift
    }

    return linker(nodemaker(first, nodes, edges), nodemaker(second, nodes, edges), shift)
}


/// If the passed argument is an array, this function does nothing.
/// Otherwise you get an array with this item as the array’s only item.
#let castToArray(item) = {
    if type(item) == array {
        item
    } else {
        (item, )
    }
}

/// #arg[edges] is a dictionary, where each key is a name of a node
/// and each value is a name of a connected node or an array of names of connected nodes.
#let graph(edges) = {
    let nodes = edges.keys()

    cetz.canvas({
        import cetz.draw: *

        for node in nodes {
            content(nodemaker(node, nodes, edges), [#node])
            circle(nodemaker(node, nodes, edges), radius:(0.5, 0.4))
        } 

        for (fromNode, toNodes) in edges.pairs() {
            for toNode in castToArray(toNodes) {
                bezier(..arrowmaker((fromNode, toNode), nodes, edges))
            }
        }
    })
}

#graph(
    (
        "12": ("12", "23"),
        "23": ("34"),
        "34": ("41"),
        "41": ("12"),
        "13": ("12", "23", "34", "41"),
        "24": ("12", "23", "34", "41"),
    )
)

