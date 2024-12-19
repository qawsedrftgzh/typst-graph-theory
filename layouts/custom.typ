#import "../utilities.typ": mergeDictionaries, castToArray

#let _isRelative(coordinate) = {
	return type(coordinate) == dictionary and "rel" in coordinate
}

#let _getRelativeCoordinates(coordinate) = {
	if "rel" in coordinate {
		let (x, y) = coordinate.rel
		return (x, y)
	}

	return none
}

#let customLayout(nodes, edges, positions: () => (:)) = {
	let defaultNode = "rest"
	let nodeDict = (:)
	nodeDict.insert(defaultNode, (rel: (2, 0)))

	if type(positions) == function {
		nodeDict = mergeDictionaries(nodeDict, positions())
	} else if type(positions) == dictionary {
		nodeDict = mergeDictionaries(nodeDict, positions)
	}

	for node in nodes {
		// If there is already a coordinate specified explicitly for the node
		if node in nodeDict {
			continue
		}

		nodeDict.insert(node, nodeDict.at(defaultNode))
	}

	return ((), ..nodeDict.pairs())
		.reduce((result, (node, value)) => {
			// Don’t add the ‘rest’ to the dictionary
			if node == defaultNode and not (defaultNode in nodes) {
				return result
			}

			if not _isRelative(value) {
				return (..result, (node, value))
			}

			let (x, y) = _getRelativeCoordinates(value)
			let lastX = 0
			let lastY = 0

			if result.len() > 0 {
				let (_, lastValue) = result.last()
				(lastX, lastY) = lastValue
			}

			value = (lastX + x, lastY + y)
			return (..result, (node, value))
		})
		.to-dict()
}
