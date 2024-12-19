#import "utilities.typ": mergeDictionaries,castToArray

#import "layouts/circular.typ": circularLayout
#import "layouts/custom.typ": customLayout
#import "layouts/grid.typ": gridLayout
#import "layouts/linear.typ": linearLayout
#import "layouts/smart.typ": smartLayout

#let generateNodes(nodes, edges, layout) = {
	layout(nodes, edges)
}

#let getNode(node,nodes) = {
	return nodes.at(node)
}

#let arrowmaker(arrow, nodesPos, edges, layout) = {
	let curve = 1
	let nodes = nodesPos.keys()
    let (first, second) = arrow

	let (x1,y1) = getNode(first,nodesPos)
	let (x2,y2) = getNode(second,nodesPos)

	let firstPos = nodes.position(item => item == first)
	let secondPos = nodes.position(item => item == second)


	let shift = 3.14/(nodes.len()*2) //it's magic
	if (first == second){
		return ((x1, y1), (x2, y2), (x1+-1, y1+1.5), (x1+1, y1+1.5))
	}else if (layout == circularLayout) and (calc.abs(firstPos - secondPos)==1 or calc.abs(firstPos+-secondPos) == nodes.len()-1) {
		return ((x1, y1), (x2, y2), ( (x1+x2)/2+(y2+-y1)*shift*curve,(y1+y2)/2+(x1+-x2)*shift*curve))
	}else{
		return ((x1, y1), (x2, y2), ((x1+x2)/2,(y1+y2)/2))
	}
}

