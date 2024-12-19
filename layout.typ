#import "utilities.typ": mergeDictionaries,castToArray

#let linearLayout(nodes, edges, layout)={
	let layout = mergeDictionaries((spacing:3),layout)
	let i = 0
	let nodeDict = (:)
	for node in nodes{
		nodeDict.insert(node,(i*layout.spacing,0))
		i += 1
	}
	return nodeDict
}


#let circularLayout(nodes,edges,layout)={
	let layout = mergeDictionaries((style:"circ",spacing:3,offset:45deg),layout)
    let nodeNumber = nodes.len()
	let nodeDict = (:)

	for node in nodes {
    	let nodeIndex = nodes.position(item => item == node)
		nodeDict.insert(node,(
			calc.cos(nodeIndex/nodeNumber*6.28+layout.offset.rad())*layout.spacing,
			calc.sin(nodeIndex/nodeNumber*6.28+layout.offset.rad())*layout.spacing
		))
	}
	return nodeDict
}

#let gridLayout(nodes,edges,layout)={
	let layout = mergeDictionaries((style:"circ",columns:2,spacing:3),layout)
    let nodeNumber = nodes.len()
	let nodeDict = (:)

	for node in nodes{
    	let nodeIndex = nodes.position(item => item == node)
		 nodeDict.insert(node,(
        	calc.rem(nodeIndex,layout.columns)*layout.spacing,
        	calc.floor(nodeIndex/layout.columns)*layout.spacing
    	))

	}

	return nodeDict
}

#let smartLayout(nodes, edges, layout)={
	let layout = mergeDictionaries((style:"circ",columns:2,spacing:3),layout)
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
	if (type(layout) != dictionary){
		layout = (:)
	}
	layout = mergeDictionaries((style:"smart"),layout)
    if (layout.style == "circ"){
        circularLayout(nodes, edges, layout)
    } else if (layout.style == "grid"){
		gridLayout(nodes, edges, layout)
    }else if (layout.style == "linear"){
		linearLayout(nodes, edges, layout)
	}else{
        smartLayout(nodes, edges, layout)
	}
}

#let getNode(node,nodes) = {
	[nodes]
	return nodes.at(node)
}




#let arrowmaker(arrow, nodesPos, edges,layout) = {
	let nodes = nodesPos.keys()
	let layout = mergeDictionaries((style:"circ",spacing:3,offset:45deg,curve:1),layout)
    let (first, second) = arrow


	let (x1,y1) = getNode(first,nodesPos)
	let (x2,y2) = getNode(second,nodesPos)

	let firstPos = nodes.position(item => item == first)
	let secondPos = nodes.position(item => item == second)


	let shift = 3.14/(nodes.len()*2) //it's magic
	if (first == second){
		return ((x1, y1), (x2, y2), (x1+-1, y1+1.5), (x1+1, y1+1.5))
	}else if (layout.style == "circ") and (calc.abs(firstPos - secondPos)==1 or calc.abs(firstPos+-secondPos) == nodes.len()-1) {
		return ((x1, y1), (x2, y2), ( (x1+x2)/2+(y2+-y1)*shift*layout.curve,(y1+y2)/2+(x1+-x2)*shift*layout.curve))
	}else{
		return ((x1, y1), (x2, y2), ((x1+x2)/2,(y1+y2)/2))
	}
}


