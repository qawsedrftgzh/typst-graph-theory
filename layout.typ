#import "utilities.typ": mergeDictionaries,castToArray

#let linearLayout(nodes, edges, spacing: 3)={
	let i = 0
	let nodeDict = (:)

	for node in nodes {
		nodeDict.insert(node,(i * spacing,0))
		i += 1
	}

	return nodeDict
}


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

#let smartLayout(nodes, edges, columns: 2, spacing: 3)={
    let nodeNumber = nodes.len()

	let nodeDict = (:)

	let grade = (:)
	for node in nodes{
		grade.insert(node,0)
	}


	while (nodeDict.len() < grade.len()){
		for edge in edges{
			let (first,conections)=edge
			for second in castToArray(conections){
				if (second != first){
					grade.insert(first,grade.at(first)+1)
					grade.insert(second,grade.at(second)+1)
				}

			}
		}
		let maxGrade = 0
		for (node,nodeGrade) in grade.pairs(){
			if (nodeGrade > maxGrade){
				maxGrade = nodeGrade
			}
		}
		let oldgrade = grade
		for (node,nodeGrade) in oldgrade.pairs(){
			if (maxGrade == nodeGrade){
				nodeDict.insert(node,(1,0))
				grade.remove(node)
			}
		}
	}
	return nodeDict
}

#let generateNodes(nodes, edges, layout) = {
	layout(nodes, edges)
}

#let getNode(node,nodes) = {
	[nodes]
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

