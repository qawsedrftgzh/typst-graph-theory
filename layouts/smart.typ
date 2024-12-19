#import "../utilities.typ": mergeDictionaries,castToArray

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

