#import "@preview/cetz:0.3.1" 

#let position(thing,array) = {
    let index = 0
    for object in array {
        if object == thing {return index}
        index += 1
    }
    return -1
}

#let nodemaker(thing,nodes,edges) = {
    let node_index = position(thing,nodes)
    return (node_index*1.5,0)
}

#let linker(first,second,shift) = {
    let (x1,y1) = first
    let (x2,y2) = second
    if shift== -1 {return ((x1,y1+0.5),(x2,x2+0.5),(x1+-1,y1+1.5),(x1+1,y1+1.5))}
    if x1 < x2 {return ((x1+0.5,y1),(x2+-0.5,y2),((x1+x2)/2,(y1+y2)/2+shift))}
    if x1 >= x2 {return ((x1+-0.5,y1),(x2+0.5,y2),((x1+x2)/2,(y1+y2)/2+-shift))}
}

#let arrowmaker(arrow,nodes,edges) = {
    let (first,second) = arrow
    let shift = 0 
    if first == second {
        shift = -1
    }
    if calc.abs(position(first,nodes)-position(second,nodes)) > 1 {
        shift = 1.5
    }
    return linker(nodemaker(first,nodes,edges),nodemaker(second,nodes,edges),shift)

}


#let graph(nodes,edges) = {
    cetz.canvas({
      import cetz.draw: *
      for node in nodes {
        content(nodemaker(node,nodes,edges),[#node])
        circle(nodemaker(node,nodes,edges),radius:(0.5,0.4))
      } 
      let arrow_spacer = 0
      for (arrow) in edges {
        let (first,second) = arrow 
        bezier(..arrowmaker(arrow,nodes,edges),mark:(end:">"))

             }
    })

}

#graph(("12","23","34","41","13","24"),(("12","23"),("23","34"),("34","41"),("41","12"),("13","12"),("13","23"),("13","34"),("34","41"),("24","12"),("24","23"),("24","34"),("24","41")))

