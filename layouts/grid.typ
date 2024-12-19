#import "../utilities.typ": mergeDictionaries,castToArray

#let gridLayout(nodes, edges, columns: 2, spacing: 3)={
    let nodeNumber = nodes.len()
	let nodeDict = (:)

	for node in nodes{
    	let nodeIndex = nodes.position(item => item == node)
		nodeDict.insert(node,(
        	calc.rem(nodeIndex,columns) * spacing,
        	calc.floor(nodeIndex/columns) * spacing
    	))
	}

	return nodeDict
}

