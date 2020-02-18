// To-do: reverse y axix at the end.

// Create tuple data structure.
struct Tuple {
    var x: Int
    var y: Int
}

// Make the tuple hashable.
extension Tuple: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
}

// Takes a two dimentional matrix, determins the legal squares.
// The results are converted into a nested dictionary.
func gameBoardMatrixToDictionary(gameBoardMatrix: Array<Array<Int>>) -> Dictionary<Tuple, Dictionary<Tuple, Int>> {
    var mazeDictionary = [Tuple : [Tuple : Int]]()
    var vaildMoves = [Tuple : Int]()

    for(y, matrixRow) in gameBoardMatrix.enumerated() {
        for(x, _) in matrixRow.enumerated() {
            if ((gameBoardMatrix[y][x]) == 0) {
                // Up
                if ((gameBoardMatrix[y-1][x]) == 0) {
                    vaildMoves[Tuple(x: x, y: y-1)] = 1
                }
                // Right
                if (gameBoardMatrix[y][x+1] == 0) {
                    vaildMoves[Tuple(x: x+1, y: y)] = 1
                }
                // Left
                if (gameBoardMatrix[y][x-1] == 0) {
                    vaildMoves[Tuple(x: x-1, y: y)] = 1
                }
                // Down
                if (gameBoardMatrix[y+1][x] == 0) {
                    vaildMoves[Tuple(x: x, y: y+1)] = 1
                }
                mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                vaildMoves = [Tuple : Int]()
            }
        }
    }
    return mazeDictionary
}

func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Int>], end: Tuple, visitedSquareCount: Int, return_cost: Bool, return_nexp: Bool) {
    
    var result = [Tuple : Tuple]()
    var dupleArray = [(Int, Int)]()

    // https://developer.apple.com/documentation/swift/keyvaluepairs for ordered path.
    func findPath(nodeAndParentNode: [Tuple : Tuple], end: Tuple) -> ([(Int, Int)],[Tuple : Tuple] ) {
        if (end == Tuple(x:-1, y:-1)) {
            return (dupleArray, result)
        } else {
            result[end] = nodeAndParentNode[end]
            dupleArray.append((end.x,end.y))
            findPath(nodeAndParentNode: nodeAndParentNode, end: nodeAndParentNode[end]!)
        }
        return (dupleArray, result)
    }

    func findPathCost(path: [Tuple : Tuple], stateGraph: [Tuple : Dictionary<Tuple, Int>]) -> Int {
        var cost = 0
        
        for key in path.keys {
            cost += (stateGraph[key]![path[key]!] ?? 0)
        }
        return(cost)
    }
    
    let (solutionPathArray, solutionPathDuple) = findPath(nodeAndParentNode: squareAndParentSquare, end: end)
    let bfspathCost = findPathCost(path: solutionPathDuple, stateGraph: gameBoard)
}

// BFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
func breathFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Int>]) {
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var visitedSquareCount = 1
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
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
    // Genarate a path and optional statistics from the results of BFS.
    formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, end: goalSquare, visitedSquareCount: visitedSquareCount, return_cost: true, return_nexp: false)
}

// DFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
func depthFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Int>]) {
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var visitedSquareCount = 1
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
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
        currentSquare = fronterSquares.last!
        fronterSquares.popLast()
    }
    // Genarate a path and optional statistics from the results of BFS.
    formatSearchResults(nodeAndParentNode: squareAndParentSquare, stateGraph: gameBoard, end: goalSquare, visitedSquareCount: visitedSquareCount, return_cost: true, return_nexp: false)
}


//var maze = ([[1, 1, 1, 1, 1, 1],
//             [1, 0, 0, 0, 0, 1],
//             [1, 0, 1, 0, 0, 1],
//             [1, 1, 1, 1, 1, 1]])

let maze = ([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
            [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
            [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1],
            [1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1],
            [1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1],
            [1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]])

//breathFirstSearch(startSquare: Duple(x:1, y:1), goalSquare: Duple(x:10, y:10), gameBoard: matrixToDictionary(mazze: maze))
depthFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: maze))
