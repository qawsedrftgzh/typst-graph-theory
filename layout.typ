#let nodemaker(thing, nodes, edges) = {
    let layout = (style:"grid",columns:2,spacing:3)
    let nodeIndex = nodes.position(item => item == thing)
    let nodeNumber = nodes.len()
    
    if (layout.style == "circ"){
        return (
            calc.cos(nodeIndex/nodeNumber*6.28)*layout.spacing, 
            calc.sin(nodeIndex/nodeNumber*6.28)*layout.spacing
        )

    } else if (layout.style == "grid"){
        return (
            calc.rem(nodeIndex,layout.columns)*layout.spacing,
            calc.floor(nodeIndex/layout.columns)*layout.spacing
        )
    }else{
        return (
            nodeIndex*layout.spacing, 
            0
        )
    }
}


#let linker(first, second, shift) = {
    let (x1, y1) = first
    let (x2, y2) = second

    if shift == -1 {
        return ((x1, y1), (x2, y2), (x1+-1, y1+1.5), (x1+1, y1+1.5))
    }

    if x1 < x2 {
        return ((x1, y1), (x2, y2), ((x1+x2)/2, (y1+y2)/2+shift))
    }

    if x1 >= x2 {
        return ((x1, y1), (x2, y2), ((x1+x2)/2, (y1+y2)/2+shift))
    }
}

#let arrowmaker(arrow, nodes, edges) = {
    let (first, second) = arrow
    let shift = 0 

    if first == second {
        shift = -1
    }

    let indexOfFirst = nodes.position(item => item == first)
    let indexOfSecond = nodes.position(item => item == second)

    
    return linker(nodemaker(first, nodes, edges), nodemaker(second, nodes, edges), shift)
}


