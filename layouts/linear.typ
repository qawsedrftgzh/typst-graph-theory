#import "../utilities.typ": mergeDictionaries,castToArray

#let linearLayout(nodes, edges, spacing: 3)={
	let i = 0
	let nodeDict = (:)

	for node in nodes {
		nodeDict.insert(node,(i * spacing,0))
		i += 1
	}

	return nodeDict
}

