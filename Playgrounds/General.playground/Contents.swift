

func mazeMatrix() {
    var matrix = [[Int]]()
    var row = [Int]()
    
    for x in 0...6 {
        for y in 0...13 {
            row.append(0)
        }
        matrix.append(row)
        row = [Int]()
    }
    print(matrix)
}

mazeMatrix()


struct Tuple: Hashable {
    var x: Int
    var y: Int
}

var squareAndParentSquare = [Tuple(x:1, y:1) : Tuple(x:1, y:2),
                             Tuple(x:1, y:2) : Tuple(x:2, y:2),
                             Tuple(x:1, y:4) : Tuple(x:1, y:3),
                             Tuple(x:2, y:1) : Tuple(x:3, y:1),
                             Tuple(x:2, y:2) : Tuple(x:2, y:1),
                             Tuple(x:2, y:4) : Tuple(x:1, y:4),
                             Tuple(x:3, y:1) : Tuple(x:4, y:1),
                             Tuple(x:3, y:3) : Tuple(x:3, y:4),
                             Tuple(x:3, y:4) : Tuple(x:2, y:4),
                             Tuple(x:4, y:1) : Tuple(x:4, y:2),
                             Tuple(x:4, y:2) : Tuple(x:4, y:3),
                             Tuple(x:4, y:3) : Tuple(x:3, y:3)]

// Grows path in both directions.
func growMatrix(squareAndParentSquare: [Tuple : Tuple]) -> [Tuple : Tuple] {
    var newSquareAndParentSquare = [Tuple : Tuple]()
    
    for i in squareAndParentSquare {
        let newChildX = i.key.x + (i.key.x - 1)
        let newChildY = i.key.y + (i.key.y - 1)
        let newParentX = i.value.x + (i.value.x - 1)
        let newParentY = i.value.y + (i.value.y - 1)
        
        newSquareAndParentSquare[Tuple(x: newChildX, y: newChildY)] = Tuple(x: newParentX, y: newParentY)
    }
    return newSquareAndParentSquare
}

func addMissingChildrenSquares(newSquareAndParentSquare: [Tuple : Tuple]) -> [Tuple : [Tuple]] {
    var parentSquareAndChildren = [Tuple : [Tuple]]()
    
    for i in newSquareAndParentSquare {
        if i.key.x == i.value.x {
            let missingChild = Tuple(x: i.key.x, y: abs((i.key.y + i.value.y)/2))
            parentSquareAndChildren[i.value] = [missingChild, i.key]
        } else if i.key.y == i.value.y {
            let missingChild = Tuple(x: abs((i.key.x + i.value.x)/2), y: i.key.y)
            parentSquareAndChildren[i.value] = [missingChild, i.key]
        }
    }
    return parentSquareAndChildren
}

let newSquareAndParentSquare = growMatrix(squareAndParentSquare: squareAndParentSquare)
let parentSquareAndChildren = addMissingChildrenSquares(newSquareAndParentSquare: newSquareAndParentSquare)
print(parentSquareAndChildren)
