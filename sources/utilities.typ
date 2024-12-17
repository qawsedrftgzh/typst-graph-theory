/// If the passed argument is an array, this function does nothing.
/// Otherwise you get an array with this item as the array’s only item.
#let castToArray(item) = {
    if type(item) == array {
        item
    } else {
        (item, )
    }
}

#let mergeDictionaries(..dictionaries) = {
	let result = (:)

	for dictionary in dictionaries.pos() {
		for (key, value) in dictionary.pairs() {
			result.insert(key, value)
		}
	}

	return result
}

