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
    // Initialize the two required dictionaries.
    var mazeDictionary = [Tuple : [Tuple : Int]]()
    var vaildMoves = [Tuple : Int]()

    // Loop through every cell in the maze.
    for(y, matrixRow) in gameBoardMatrix.enumerated() {
        for(x, _) in matrixRow.enumerated() {
            // If in a square that is leagal, append valid moves to a dictionary.
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
                // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                // Reset the inner dictionary templet.
                vaildMoves = [Tuple : Int]()
            }
        }
    }
    return mazeDictionary
}

// Genarate a path and optional statistics from the results of BFS.
func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Int>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([(Int, Int)], Int, Int) {
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    var squareAndNoParentArrayPath = [(Int, Int)]()

    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([(Int, Int)],[Tuple : Tuple]) {
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
    
    // Prepare and present the result returns.
    if (returnPathCost == true) {
        // Use the "path" method result to calculate a pathcost using the "pathcost" method.
        let solutionPathCost = findPathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
        
        if (returnSquaresVisited == true) {
            return (solutionPathArray, solutionPathCost, visitedSquareCount)
        } else {
            return (solutionPathArray, solutionPathCost, 0)
        }
    }
    else if (returnPathCost == false) && (returnSquaresVisited == true) {
        return (solutionPathArray, 0, visitedSquareCount)
    }
    else {
        return (solutionPathArray, 0, 0)
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
func breathFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Int>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([(Int, Int)], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    // Dictionary used to find a path, every node will have only one parent.
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
//                if !(visitedSquares.contains(newFronterSquare)) {
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
//                }
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
func depthFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Int>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([(Int, Int)], Int, Int) {
    // Initalize variable and add first square manually.
    var visitedSquares = [Tuple]()
    var fronterSquares = [startSquare]
    var currentSquare = startSquare
    var visitedSquareCount = 1
    // Dictionary used to find a path, every node will have only one parent.
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
//                if !(visitedSquares.contains(newFronterSquare)) {
                fronterSquares += [newFronterSquare]
                squareAndParentSquare[newFronterSquare] = currentSquare
//                }
            }
        }
        // New currentNode is last in queue (DFS).
        currentSquare = fronterSquares.last!
        fronterSquares.popLast()
    }
    // Genarate a path and optional statistics from the results of DFS.
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
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

//    print(breathFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze), returnPathCost: true, returnSquaresVisited: true))
//    print(depthFirstSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze), returnPathCost: true, returnSquaresVisited: true))
    print(uniformCostSearch(startSquare: Tuple(x:1, y:1), goalSquare: Tuple(x:10, y:10), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: largeMaze), returnPathCost: false, returnSquaresVisited: false))
}

class PriorityQueue {
    var heap:[Int : Tuple]  = [:]
    
    init(start: Tuple, cost: Int) {
        add(state: start, cost: cost)
    }
    
    func add(state: Tuple, cost: Int) {
        heap[cost] = state
    }
    
    func pop() -> (Int?, Tuple?) {
        let minCostAndState = heap.min { a, b in a.key < b.key }
        heap.removeValue(forKey: minCostAndState!.key)
        return (minCostAndState?.key, minCostAndState?.value)
    }
}

func uniformCostSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([(Float, Float)], Float, Float) {
    var visitedSquares = [startSquare]
    let priorityQueueClass = PriorityQueue(start: startSquare, cost: 0)
    let currentSquare = Tuple(x:-1, y:-1)
    var visitedSquareCount = 0
    var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]

//    print("before while", priorityQueueClass.heap)
//    print(priorityQueueClass.heap.values.contains(startSquare))
    while (currentSquare != goalSquare) {
//        print("right before pop", priorityQueueClass.heap)
        let (currentCost, currentSquare) = priorityQueueClass.pop()
        
        if (currentSquare == goalSquare) {
            break
        }
        
//        print("right after pop", priorityQueueClass.heap)
        visitedSquares += [currentSquare!]
        visitedSquareCount += 1
        
//        print(priorityQueueClass.queue)
        for (prospectSquare, temp) in gameBoard[currentSquare!]! {
            print("----------", temp)
            let prospectPathCost = currentCost! + temp + 1.00001
            print(prospectPathCost)
            
            
            if !(visitedSquares.contains(prospectSquare)) {
//                print(prospectSquare)
//                print(priorityQueueClass.heap)
                if (priorityQueueClass.heap.values.contains(prospectSquare)) {
                    break
                }
                else {
                    print("before add", priorityQueueClass.heap)
                    priorityQueueClass.add(state: prospectSquare, cost: prospectPathCost)
                    print("right after add", priorityQueueClass.heap)
                    squareAndParentSquare[prospectSquare] = currentSquare
                }
                print("parent and child", squareAndParentSquare)
            }
        }
    }
    
    return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
}

driver()
