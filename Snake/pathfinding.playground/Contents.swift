// To-do: reverse y axix at the end.
// To-do: https://developer.apple.com/documentation/swift/keyvaluepairs for ordered paris.

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

// Genarate a path and optional statistics from the results of BFS.
func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Int>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) {
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    var squareAndNoParentArrayPath = [(Int, Int)]()

    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([(Int, Int)],[Tuple : Tuple] ) {
        if (currentSquare == Tuple(x:-1, y:-1)) {
            return (squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
        } else {
            squareAndParentSquareTuplePath[currentSquare] = squareAndParentSquare[currentSquare]
            squareAndNoParentArrayPath.append((currentSquare.x,currentSquare.y))
            findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: squareAndParentSquare[currentSquare]!)
        }
        return (squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
    }

    // Calculate the path cost of the path returned by the "findPath" function.
    func findPathCost(solutionPathDuple: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Int>]) -> Int {
        var cost = 0
        
        for square in solutionPathDuple.keys {
            cost += (gameBoard[square]![solutionPathDuple[square]!] ?? 0)
        }
        return(cost)
    }
    let (solutionPathArray, solutionPathDuple) = findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: currentSquare)
    let solutionPathCost = findPathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
    print(solutionPathCost)
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
    formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: true, returnSquaresVisited: true)
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
    formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: true, returnSquaresVisited: true)
}

func driver() {
    let smallMaze = ([[1, 1, 1, 1, 1, 1],
                     [1, 0, 0, 0, 0, 1],
                     [1, 0, 1, 0, 0, 1],
                     [1, 1, 1, 1, 1, 1]])

    let largeMaze = ([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
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

//    breathFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze))
    depthFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze))
}

driver()
