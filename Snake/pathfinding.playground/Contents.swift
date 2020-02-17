struct Duple {
    var x: Int
    var y: Int
}

extension Duple: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

    public static func == (lhs: Duple, rhs: Duple) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func matrixToDictionary(mazze: Array<Array<Int>>) -> Dictionary<Duple, Dictionary<Duple, Int>> {
    var mazeDistances = [Duple : [Duple : Int]]()
    var vaildValues = [Duple : Int]()

    for(y, innerArray) in maze.enumerated() {
        for(x, _) in innerArray.enumerated() {
            if ((mazze[y][x]) == 0) {
                // Up
                if ((mazze[y-1][x]) == 0) {
                    vaildValues[Duple(x: x, y: y-1)] = 1
                }
                // Right
                if (mazze[y][x+1] == 0) {
                    vaildValues[Duple(x: x+1, y: y)] = 1
                }
                // Left
                if (mazze[y][x-1] == 0) {
                    vaildValues[Duple(x: x-1, y: y)] = 1
                }
                // Down
                if (mazze[y+1][x] == 0) {
                    vaildValues[Duple(x: x, y: y+1)] = 1
                }
                mazeDistances[Duple(x: x, y: y)] = vaildValues
                vaildValues = [Duple : Int]()
            }
        }
    }
    return mazeDistances
}

var maze = ([[1, 1, 1, 1, 1, 1],
             [1, 0, 0, 0, 0, 1],
             [1, 0, 1, 0, 0, 1],
             [1, 1, 1, 1, 1, 1]])

//let maze = ([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//            [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//            [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
//            [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//            [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
//            [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
//            [1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1],
//            [1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1],
//            [1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
//            [1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1],
//            [1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1],
//            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]])

var result = [Duple : Duple]()



func findPath(nodeAndParentNode: [Duple : Duple], end: Duple) {
    var child = nodeAndParentNode[end]
    var parent = end
//    print("parent", parent, "child", child)
//    print(result)
        
    if (end == Duple(x:-1, y:-1)) {
        print("^^^^^^", result)
//        result = [Duple : Duple]()
        return
    } else {
//        print("else hit")
        result[parent] = child
        findPath(nodeAndParentNode: nodeAndParentNode, end: nodeAndParentNode[end]!)
    }
}

func breathFirstSearch(startSquare: Duple, goalSquare: Duple, gameBoard: [Duple : Dictionary<Duple, Int>]) {
    var visitedSquares = [Duple]()
    var fronterSquares = [Duple]()
    var visitedSquareCount = 0
    var squareAndParentSquare = [Duple : Duple]()
    
    squareAndParentSquare[startSquare] = Duple(x:-1, y:-1)
    visitedSquares += [startSquare]
    visitedSquareCount += 1
    var currentSquare = startSquare
    
    while (currentSquare != goalSquare) {
        if !(visitedSquares.contains(currentSquare)) {
            visitedSquares += [currentSquare]
            visitedSquareCount += 1
        }
    
        for (newFronterSquare, _) in gameBoard[currentSquare]! {
            if !(visitedSquares.contains(newFronterSquare)) {
                if !(visitedSquares.contains(newFronterSquare)) {
                    fronterSquares += [newFronterSquare]
                    squareAndParentSquare[newFronterSquare] = currentSquare
                }
            }
        }
        currentSquare = fronterSquares[0]
        fronterSquares.remove(at: 0)
    }
    var bfsPath = findPath(nodeAndParentNode: squareAndParentSquare, end: goalSquare)
//    print("$$$$", squareAndParentSquare)
}

breathFirstSearch(startSquare: Duple(x:1, y:1), goalSquare: Duple(x:4, y:2), gameBoard: matrixToDictionary(mazze: maze))
