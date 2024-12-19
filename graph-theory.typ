#import "@preview/cetz:0.3.1"
#import "layout.typ": *
#import "utilities.typ": castToArray, mergeDictionaries



/// #arg[edges] is a dictionary, where each key is a name of a node
/// and each value is a name of a connected node or an array of names of connected nodes.
///
/// #args [styles] describes the way nodes and/or edges should be displayed.
#let graph(edges, styles: (:), layout: smartLayout) = {
    let nodes = edges.keys()
	let nodesPos = generateNodes(nodes, edges, layout)

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
                bezier(..arrowmaker((fromNode, toNode), nodesPos, edges, layout))
				content(arrowmaker((fromNode,toNode),nodesPos,edges,layout).at(2))[test]
            }
        }

        for node in nodes {
            let style = mergeDictionaries(defaultNodeStyle, styles.at(node, default: (:)))

            circle(
                getNode(node, nodesPos),
                radius: style.radius,
                fill: style.fill,
                stroke: style.stroke
            )

            content(
                getNode(node, nodesPos),
                text(fill: style.text)[#node]
            )
        }
    })
}

#graph(
    (
        "a": ("a", "b"),
        "b": ("c","d"),
        "c": ("d"),
		"d": ("a"),
		"e": ("a"),
    ),
    styles: (
        "a": (
            fill: yellow,
            stroke: red,
            text: orange
        ),
        "a-b": (
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
	layout: customLayout.with(positions: (..) => (
		a: (1, 2),
		c: (3,2),
		rest: (rel: (2, -2))
	))
)
