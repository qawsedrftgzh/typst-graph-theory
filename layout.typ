#import "utilities.typ": mergeDictionaries,castToArray

#let linearLayout(thing, nodes, edges, layout)={
	let layout = mergeDictionaries((style:"circ",columns:2,spacing:3),layout)
    let nodeIndex = nodes.position(item => item == thing)
    let nodeNumber = nodes.len()

	return (
		nodeIndex*layout.spacing,
		0
	)
}

#let circularLayout(thing,nodes,edges,layout)={
	let layout = mergeDictionaries((style:"circ",spacing:3,offset:45deg),layout)
    let nodeIndex = nodes.position(item => item == thing)
    let nodeNumber = nodes.len()

	return (
        calc.cos(nodeIndex/nodeNumber*6.28+layout.offset.rad())*layout.spacing,
        calc.sin(nodeIndex/nodeNumber*6.28+layout.offset.rad())*layout.spacing
    )
}

#let gridLayout(thing,nodes,edges,layout)={
	let layout = mergeDictionaries((style:"circ",columns:2,spacing:3),layout)
    let nodeIndex = nodes.position(item => item == thing)
    let nodeNumber = nodes.len()

	return (
        calc.rem(nodeIndex,layout.columns)*layout.spacing,
        calc.floor(nodeIndex/layout.columns)*layout.spacing
    )
}

#let smartLayout(thing, nodes, edges, layout)={
	let layout = mergeDictionaries((style:"circ",columns:2,spacing:3),layout)
    let nodeIndex = nodes.position(item => item == thing)
    let nodeNumber = nodes.len()

	let grade = (:)
	for node in nodes{
		grade.insert(node,0)
	}
	for edges in edges{
		let (first,conections)=edges
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
	if (maxGrade <= 2){
		return linearLayout(thing, nodes, edges, layout)
	}else if (maxGrade <= 3){
		return circularLayout(thing, nodes, edges, layout)
	}else{
		return (grade.at(thing),nodeIndex*1)
	}

}

#let nodemaker(thing, nodes, edges,layout) = {
    if (layout.style == "circ"){
        circularLayout(thing,nodes,edges,layout)
    } else if (layout.style == "grid"){
		gridLayout(thing,nodes,edges,layout)
    }else if (layout.style == "linear"){
		linearLayout(thing, nodes, edges, layout)
	}else{
        smartLayout(thing,nodes,edges,layout)
	}
}





#let arrowmaker(arrow, nodes, edges,layout) = {
	let layout = mergeDictionaries((style:"circ",spacing:3,offset:45deg,curve:1),layout)
    let (first, second) = arrow

	let (x1,y1) = nodemaker(first,nodes,edges,layout)
	let (x2,y2) = nodemaker(second, nodes, edges, layout)

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


