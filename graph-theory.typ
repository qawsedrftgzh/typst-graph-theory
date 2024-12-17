#import "@preview/cetz:0.3.1" 
#import "layout.typ":*
#import "./sources/utilities.typ": castToArray, mergeDictionaries



/// #arg[edges] is a dictionary, where each key is a name of a node
/// and each value is a name of a connected node or an array of names of connected nodes.
///
/// #args [styles] describes the way nodes and/or edges should be displayed.
#let graph(edges, styles: ()) = {
    let nodes = edges.keys()

    cetz.canvas({
        import cetz.draw: *

        let defaultEdgeStyle = mergeDictionaries((
            stroke: black
        ), styles.at("edge", default: (:)))

        let defaultNodeStyle = mergeDictionaries((
            fill: white,
            stroke: black,
            text: black,
            radius: 0.5
        ), styles.at("node", default: (:)))

        for (fromNode, toNodes) in edges.pairs() {
            for toNode in castToArray(toNodes) {
                let style = mergeDictionaries(
                    defaultEdgeStyle, 
                    styles.at(fromNode + "-" + toNode, default: (:))
                )

                set-style(stroke: style.stroke)
                bezier(..arrowmaker((fromNode, toNode), nodes, edges))
            }
        }

        for node in nodes {
            let style = mergeDictionaries(defaultNodeStyle, styles.at(node, default: (:)))

            circle(
                nodemaker(node, nodes, edges), 
                radius: style.radius,
                fill: style.fill,
                stroke: style.stroke
            )

            content(
                nodemaker(node, nodes, edges), 
                text(fill: style.text)[#node]
            )
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
    ),
    styles: (
        "12": (
            fill: yellow,
            stroke: red,
            text: orange
        ),
        "12-23": (
            stroke: red
        ),
        node: (
            fill: aqua,
            text: white
        ),
        edge: (
            stroke: green
        )
    ),
)

