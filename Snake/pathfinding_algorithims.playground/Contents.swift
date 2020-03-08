// To-do: reverse y axix at the end.
// To-do: https://developer.apple.com/documentation/swift/keyvaluepairs for ordered paris.
// To-do: Optimise breaking condition in Uniform Cost Search and A*.
// To-do: Confirm outputs are correct.
// To-do: Startsquare and goalSquare are swapped.

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
func gameBoardMatrixToDictionary(gameBoardMatrix: Array<Array<Int>>) -> Dictionary<Tuple, Dictionary<Tuple, Float>> {
    // Initialize the two required dictionaries.
    var mazeDictionary = [Tuple : [Tuple : Float]]()
    var vaildMoves = [Tuple : Float]()

    // Loop through every cell in the maze.
    for(y, matrixRow) in gameBoardMatrix.enumerated() {
        for(x, _) in matrixRow.enumerated() {
            // If in a square that is leagal, append valid moves to a dictionary.
            if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 2) {
                let isYNegIndex = gameBoardMatrix.indices.contains(y-1)
                let isYIndex = gameBoardMatrix.indices.contains(y+1)
//                let isXNegIndex = gameBoardMatrix.indices.contains(x-1)
                let isXIndex = gameBoardMatrix.indices.contains(x+1)
//                let isY = gameBoardMatrix.indices.contains(y)
                
                
//                if isYIndexValid && isYNegIndexValid && isXNegIndexValid && isXIndexValid {
                    // Up
//                    if y-1 != -1 {
                    if isYNegIndex {
                        if (gameBoardMatrix[y-1][x] == 0 || gameBoardMatrix[y-1][x] == 2) {
                            vaildMoves[Tuple(x: x, y: y-1)] = 1
                        }
                    }
                    // Right
                    if isXIndex {
                        if (gameBoardMatrix[y][x+1] == 0 || gameBoardMatrix[y][x+1] == 2) {
                            // Floats so that we can have duplicates keys in dictinaries (Swift dictionary workaround).
                            vaildMoves[Tuple(x: x+1, y: y)] = 1.000001
                        }
                    }
                    // Left
//                    if isXNegIndex {
                    if x-1 != -1 {
                        if (gameBoardMatrix[y][x-1] == 0 || gameBoardMatrix[y][x-1] == 2) {
                            vaildMoves[Tuple(x: x-1, y: y)] = 1.000002
                        }
                    }
                    // Down
                    if isYIndex {
                        if (gameBoardMatrix[y+1][x] == 0 || gameBoardMatrix[y+1][x] == 2) {
                            vaildMoves[Tuple(x: x, y: y+1)] = 1.000003
                            }
                        }
                // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                // Reset the inner dictionary templet.
                vaildMoves = [Tuple : Float]()
//                }
            }
        }
    }
//    print(mazeDictionary)
    return mazeDictionary
}

// Genarate a path and optional statistics from the results of BFS.
func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    var squareAndNoParentArrayPath = [(Int, Int)]()
    // 1 == left, 2 == up, 3 == right, 4 == down
    var movePath = [Int]()

    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([Int],[(Int, Int)],[Tuple : Tuple]) {
        if (currentSquare == Tuple(x:-1, y:-1)) {
            return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
        } else {
            squareAndParentSquareTuplePath[currentSquare] = squareAndParentSquare[currentSquare]
            squareAndNoParentArrayPath.append((currentSquare.x,currentSquare.y))
            let xValue = currentSquare.x - squareAndParentSquare[currentSquare]!.x
            let yValue = currentSquare.y - squareAndParentSquare[currentSquare]!.y
            // 1 == left, 2 == up, 3 == right, 4 == down
            if (xValue == 0 && yValue == 1) {
                movePath.append(4)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 0 && yValue == -1) {
                movePath.append(2)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 1 && yValue == 0) {
                movePath.append(1)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == -1 && yValue == 0) {
                movePath.append(3)
            }
            
            findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: squareAndParentSquare[currentSquare]!)
        }
        return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
    }

    // Calculate the path cost of the path returned by the "findPath" function.
    func findPathCost(solutionPathDuple: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>]) -> Int {
        var cost = 0
        
        for square in solutionPathDuple.keys {
            cost += Int(gameBoard[square]![solutionPathDuple[square]!] ?? 0)
        }
        return(cost)
    }
    let (solutionPathMoves, solutionPathArray, solutionPathDuple) = findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: currentSquare)
    
    // Prepare and present the result returns.
    if (returnPathCost == true) {
        // Use the "path" method result to calculate a pathcost using the "pathcost" method.
        let solutionPathCost = findPathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
        
        if (returnSquaresVisited == true) {
            return (solutionPathMoves, solutionPathCost, visitedSquareCount)
        } else {
            return (solutionPathMoves, solutionPathCost, 0)
        }
    }
    else if (returnPathCost == false) && (returnSquaresVisited == true) {
        return (solutionPathMoves, 0, visitedSquareCount)
    }
    else {
        return (solutionPathMoves, 0, 0)
    }
}

// Steps in Breath First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select one by one a unvisited child node to explore.
// Do this for all the child nodes
// Repeat untill the goal is visited.

// BFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
// The nodes are traversed in order found in the dictionary parameter.
func breathFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    // Dictionary used to find a path, every square will have only one parent.
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
    
    // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
    while (currentSquare != goalSquare) {
        // Mark current node as visited. (If statement required due to first node.)
        if !(visitedSquares.contains(currentSquare)) {
            visitedSquares += [currentSquare]
            visitedSquareCount += 1
        }
        
        // Repeat through all the nodes in the sub dictionary.
        // Append to fronter and mark parent.
        for (newFronterSquare, _) in gameBoard[currentSquare]! {
            if !(visitedSquares.contains(newFronterSquare)) {
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
            }
        }
        // New currentNode is first in queue (BFS).
        currentSquare = fronterSquares[0]
        fronterSquares.remove(at: 0)
    }
    // Genarate a path and optional statistics from the results of BFS.
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}

// Steps in Depth First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select the last unvisited child node to explore.
// Repeat untill the goal is visited.

// DFS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
// The nodes are traversed in order found in the dictionary parameter.
func depthFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    // Dictionary used to find a path, every square will have only one parent.
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
    
    // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
    while (currentSquare != goalSquare) {
        // Mark current node as visited. (If statement required due to first node.)
        if !(visitedSquares.contains(currentSquare)) {
            visitedSquares += [currentSquare]
            visitedSquareCount += 1
        }
        
        // Repeat through all the nodes in the sub dictionary.
        // Append to fronter and mark parent.
        for (newFronterSquare, _) in gameBoard[currentSquare]! {
            if !(visitedSquares.contains(newFronterSquare)) {
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
            }
        }
        // New currentNode is last in queue (DFS).
        currentSquare = fronterSquares.last!
        fronterSquares.popLast()
    }
    // Genarate a path and optional statistics from the results of DFS.
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}

// Simulated priority queue using a simulated heap.
class PriorityQueue {
    var heap:[Float : Tuple]  = [:]
    
    init(square: Tuple, cost: Float) {
        // Add first square manually.
        add(square: square, cost: cost)
    }
    
    // Add a passed tuple to the frontier
    func add(square: Tuple, cost: Float) {
        heap[cost] = square
    }
    
    // Return the lowest-cost tuple, and pop it off the frontier
    func pop() -> (Float?, Tuple?) {
        let minSquareAndCost = heap.min { a, b in a.key < b.key }
        heap.removeValue(forKey: minSquareAndCost!.key)
        return (minSquareAndCost?.key, minSquareAndCost?.value)
    }
}

// UCS produces a dictionary in which each valid square points too only one parent.
// Then the dictionary is processed to create a valid path.
// The nodes are traversed in order found in the dictionary parameter.
func uniformCostSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [startSquare]
    // Initiate a priority queue class.
    let priorityQueueClass = PriorityQueue(square: startSquare, cost: 0)
    let currentSquare = Tuple(x:-1, y:-1)
    var visitedSquareCount = 0
    // Dictionary used to find a path, every square will have only one parent.
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]

    // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
    // Note if statment bellow breaks for the while (bug to fix).
    while (currentSquare != goalSquare) {
        // Set the path cost and the current square equal to the lowest path node in the priority queue.
        // Pop the square as well (mark as visited)
        let (currentCost, currentSquare) = priorityQueueClass.pop()
        
        // Break the loop one goalSquare is in sight (To-Do optimize this).
        if (currentSquare == goalSquare) {
            break
        }
        
        visitedSquares += [currentSquare!]
        visitedSquareCount += 1
        
        // Repeat through all the squares in the sub dictionary.
        // Update the info stored for the child squares.
        for (prospectSquare, prospectSquareCost) in gameBoard[currentSquare!]! {
            // Calculate the path cost to the new square.
            let prospectPathCost = currentCost! + prospectSquareCost + 1
            
            // If the square has not been visited add to the add to the queue and mark its parent.
            if !(visitedSquares.contains(prospectSquare)) {
                if !(priorityQueueClass.heap.values.contains(prospectSquare)) {
                    priorityQueueClass.add(square: prospectSquare, cost: prospectPathCost)
                    squareAndParentSquare[prospectSquare] = currentSquare
                }
            }
        }
    }
    // Genarate a path and optional statistics from the results of UCS.
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}

func driver() {

//    let smallMaze = ([[1, 1, 1, 1, 1, 1],
//                     [1, 0, 0, 0, 0, 1],
//                     [1, 0, 1, 0, 0, 1],
//                     [1, 1, 1, 1, 1, 1]])

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
    
    let smallMaze = ([[1, 1, 1, 1],
                     [1, 0, 2, 1],
                     [1, 2, 0, 1],
                     [1, 1, 1, 1]])
    
// 1 == left, 2 == up, 3 == right, 4 == down
    print(breathFirstSearch(startSquare: Tuple(x:1, y:2), goalSquare: Tuple(x:2, y:1), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: smallMaze), returnPathCost: false, returnSquaresVisited: false))
//    print(depthFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze), returnPathCost: true, returnSquaresVisited: true))
//    print(uniformCostSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: smallMaze), returnPathCost: true, returnSquaresVisited: true))
}

driver()
