#import "../utilities.typ": mergeDictionaries,castToArray

#let circularLayout(nodes, edges, spacing: 3, offset: 45deg)={
    let nodeNumber = nodes.len()
	let nodeDict = (:)

	for node in nodes {
    	let nodeIndex = nodes.position(item => item == node)
		nodeDict.insert(node,(
			calc.cos(nodeIndex/nodeNumber*6.28+offset.rad())*spacing,
			calc.sin(nodeIndex/nodeNumber*6.28+offset.rad())*spacing
		))
	}
	return nodeDict
}

