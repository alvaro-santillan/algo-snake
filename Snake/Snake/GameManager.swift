//
//  GameManager.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//  Bug Seg-fault when reach gameboard end.

//--------------------
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

import SpriteKit
import AVFoundation

class GameManager {
    var player: AVAudioPlayer?
    var viewController: GameScreenViewController!
    var play = true
    var gameStarted = false
    var matrix = [[Int]]()
    var test = [Int]()
    var pathBlockCordinates = [(Int, Int)]()
    var onPathMode = false
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Float = 1
    var paused = false
    var playerDirection: Int = 4 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var barrierNodesWaitingToBeDisplayed = [Tuple]()
    var barrierNodesWaitingToBeRemoved = [Tuple]()
    var teeeemp = [(SKShapeNode, Tuple)]()
    var snakeBodyPos: [Tuple] = []
    var godModeWasTurnedOn = false
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    
    init(scene: GameScene) {
        self.scene = scene
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
                if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 3 || gameBoardMatrix[y][x] == 1) {
//                    print("valid square", x, y)
                    var isYNegIndex = Bool()
                    var isYIndex = Bool()
                    var isXIndex = Bool()
                    var isXNefIndex = Bool()
                    
                    let xMax = scene.rowCount
                    let yMax = scene.columnCount
                    let yMin = 0
                    let xMin = 0
                    
                    if (y+1 >= yMax) {
                        isYIndex = false
                    } else {
                        isYIndex = true
                        print("y+1", gameBoardMatrix[y+1][x])
                    }
                    
                    if (x+1 >= xMax) {
                        isXIndex = false
                    } else {
                        isXIndex = true
                        print("x+1", gameBoardMatrix[y][x+1])
                    }
                    
                    if (y-1 < 0) {
                        isYNegIndex = false
                    } else {
                        isYNegIndex = true
                        print("y-1", gameBoardMatrix[y-1][x])
                    }
                    
                    if (x-1 < 0) {
                        isXNefIndex = false
                    } else {
                        isXNefIndex = true
                        print("x-1", gameBoardMatrix[y][x-1])
                    }
                    
                    print("x,y", x, y)
                    print("isYIndex", isYIndex)
                    print("isXIndex", isXIndex)
                    print("isYNegIndex", isYNegIndex)
                    print("isXNefIndex", isXNefIndex)
                    
                    if (y == 1 && x == 0) {
                        print("Target Sited:", gameBoardMatrix[y][x])
                        print(gameBoardMatrix[y-1][x])
                        print(gameBoardMatrix[y+1][x])
                        print(gameBoardMatrix[y][x+1])
//                        print(gameBoardMatrix[y][x-1])
                    }
                    
                    if (y == 0 && x == 1) {
                        print("Target Sited:", gameBoardMatrix[y][x])
                    }
                    
                        if isYNegIndex {
                            if (gameBoardMatrix[y-1][x] == 0 || gameBoardMatrix[y-1][x] == 3 || gameBoardMatrix[y-1][x] == 1) {
                                vaildMoves[Tuple(x: x, y: y-1)] = 1
                            }
                        }
                        // Right
                        if isXIndex {
                            if (gameBoardMatrix[y][x+1] == 0 || gameBoardMatrix[y][x+1] == 3 || gameBoardMatrix[y][x+1] == 1) {
                                // Floats so that we can have duplicates keys in dictinaries (Swift dictionary workaround).
                                vaildMoves[Tuple(x: x+1, y: y)] = 1.000001
                            }
                        }
                        // Left
                        if isXNefIndex {
                            if (gameBoardMatrix[y][x-1] == 0 || gameBoardMatrix[y][x-1] == 3 || gameBoardMatrix[y][x-1] == 1) {
                                vaildMoves[Tuple(x: x-1, y: y)] = 1.000002
                            }
                        }
                        // Down
                        if isYIndex {
                            if (gameBoardMatrix[y+1][x] == 0 || gameBoardMatrix[y+1][x] == 3 || gameBoardMatrix[y+1][x] == 1) {
                                vaildMoves[Tuple(x: x, y: y+1)] = 1.000003
                                }
                            }
                    // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                    mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                    // Reset the inner dictionary templet.
                    vaildMoves = [Tuple : Float]()
                }
            }
        }
        print(mazeDictionary)
        return mazeDictionary
    }

    // Genarate a path and optional statistics from the results of BFS.
    func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Int, Int)], Int, Int) {
        var squareAndParentSquareTuplePath = [Tuple : Tuple]()
        var squareAndNoParentArrayPath = [(Int, Int)]()
        // 1 == left, 2 == up, 3 == right, 4 == down
        var movePath = [Int]()
        
//        print("Format Results square and parent", squareAndParentSquare)

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
                    movePath.append(2)
                // 1 == left, 2 == up, 3 == right, 4 == down
                } else if (xValue == 0 && yValue == -1) {
                    movePath.append(4)
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
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, visitedSquareCount)
            } else {
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, 0)
            }
        }
        else if (returnPathCost == false) && (returnSquaresVisited == true) {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, visitedSquareCount)
        }
        else {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, 0)
        }
    }
    
    var visitedNodeArray = [SKShapeNode]()
    var fronteerSquareArray = [SKShapeNode]()
    
//    func colorVisitedSquares(visitedX: Int, visitedY: Int) {
//        let node = scene.gameBoard.first(where: {$0.x == visitedX && $0.y == visitedY})?.node
//        visitedNodeArray.append(node!)
////        node!.fillColor = UserDefaults.standard.colorForKey(key: "Visited Square")!
////        print("Node at:", visitedX, visitedY)
//    }
//
//        func fronteerSquares(visitedX: Int, visitedY: Int) {
//            let node = scene.gameBoard.first(where: {$0.x == visitedY && $0.y == visitedX})?.node
//            fronteerSquareArray.append(node!)
//    //        node!.fillColor = UserDefaults.standard.colorForKey(key: "Visited Square")!
////            print("Node at:", visitedX, visitedY)
//        }

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
    func breathFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Int, Int)], Int, Int) {
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        var visitedSquareCount = 1
        var counter = 0
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        while (currentSquare != goalSquare) {
            counter += 1
            // Mark current node as visited. (If statement required due to first node.)
            if !(visitedSquares.contains(currentSquare)) {
                visitedSquares += [currentSquare]
//                colorVisitedSquares(visitedX: currentSquare.y, visitedY: currentSquare.x)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            for (newFronterSquare, _) in gameBoard[currentSquare]! {
                if !(visitedSquares.contains(newFronterSquare)) {
                    fronterSquares += [newFronterSquare]
//                    fronteerSquares(visitedX: newFronterSquare.y, visitedY: newFronterSquare.x)
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
    func depthFirstSearch(startSquare: Tuple, goalSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Int, Int)], Int, Int) {
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
//                colorVisitedSquares(visitedX: currentSquare.x, visitedY: currentSquare.y)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            print("Current Square:", currentSquare)
            print(gameBoard[currentSquare])
            print("square and parent", squareAndParentSquare)
            for (newFronterSquare, _) in gameBoard[currentSquare]! {
                print(newFronterSquare)
                if !(visitedSquares.contains(newFronterSquare)) {
                    fronterSquares += [newFronterSquare]
//                    fronteerSquares(visitedX: newFronterSquare.y, visitedY: newFronterSquare.x)
                    squareAndParentSquare[newFronterSquare] = currentSquare
                }
            }
            
            if fronterSquares.count != 0 {
                currentSquare = fronterSquares.last!
                fronterSquares.popLast()
            } else {
//                print("DFS else hit")
                return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
            }
        }
        // Genarate a path and optional statistics from the results of DFS.
        return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: goalSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
    }
    

    
    // Understood - Initiate the starting position of the snake.
    func initiateSnakeStartingPosition() {
        // Must be run at the very begining.
        verticalMaxBoundry = (scene.rowCount - 2)
        verticalMinBoundry = 1
        horizontalMaxBoundry = (scene.columnCount - 2)
        horizontalMinBoundry = 1
        
        // Dont forget to change back
        snakeBodyPos.append(Tuple(x: 0, y: 0))
        matrix[0][0] = 1
        snakeBodyPos.append(Tuple(x: 0, y: 1))
        matrix[0][1] = 2
        spawnFoodBlock()
        gameStarted = true
        
//        node.run(scene.gameSquareAnimation())
    }
    
    // Understood - Spawn a new food block into the game.
    var prevX = -1
    var prevY = -1
    var closetFoodBlockHit = false
    var foodLocationArray: [[Int]] = []
    var foodDistanceFromHead: [Int] = []
    var foodCollisionPoint = Int()
    let foodSpawnMax = (UserDefaults.standard.integer(forKey: "Food Count Setting"))
    let mainScreenAlgoChoice = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    
    func spawnFoodBlock() {
        let foodPalletsNeeded = (foodSpawnMax - foodLocationArray.count)
        let snakeHead = snakeBodyPos[0]
        
        // need to use queue.
        for _ in 1...foodPalletsNeeded {
            // Modified
            var randomX = Int.random(in: 0...verticalMaxBoundry+1)
            var randomY = Int.random(in: 0...horizontalMaxBoundry+1)
//            var randomX = Int.random(in: 1...verticalMaxBoundry)
//            var randomY = Int.random(in: 1...horizontalMaxBoundry)
            
            var validFoodLocationConfirmed = false
            var foodLocationChnaged = false
            while validFoodLocationConfirmed == false {
                validFoodLocationConfirmed = true
                for i in (barrierNodesWaitingToBeDisplayed) {
                    if i.y == randomY && i.x == randomX {
                        randomX = Int.random(in: 0...verticalMaxBoundry+1)
                        randomY = Int.random(in: 0...horizontalMaxBoundry+1)
                        validFoodLocationConfirmed = false
                        foodLocationChnaged = true
                        // Modified
    //                    randomX = Int.random(in: 1...verticalMaxBoundry)
    //                    randomY = Int.random(in: 1...horizontalMaxBoundry)
                    }
                }

                for i in (snakeBodyPos) {
                    if i.y == randomY && i.x == randomX {
                        randomX = Int.random(in: 0...verticalMaxBoundry+1)
                        randomY = Int.random(in: 0...horizontalMaxBoundry+1)
                        validFoodLocationConfirmed = false
                        foodLocationChnaged = true
                        // Modified
    //                    randomX = Int.random(in: 1...verticalMaxBoundry)
    //                    randomY = Int.random(in: 1...horizontalMaxBoundry)
                    }
                }
                foodLocationArray = Array(Set(foodLocationArray))
                if foodLocationChnaged == false {
                    validFoodLocationConfirmed = true
                }
            }
                        
            matrix[randomX][randomY] = 3
            foodLocationArray.append([randomX,randomY])
            let DistanceFromSnake = abs(snakeHead.x - randomX) + abs(snakeHead.y - randomY)
            foodDistanceFromHead.append(DistanceFromSnake)
            scene.foodPosition.append(CGPoint(x: randomY, y: randomX))
            
        }
        // Calculation for closest food block is wrong mathamaticlly sometimes.
        let temp = foodDistanceFromHead.min()!
        let minX = foodLocationArray[foodDistanceFromHead.firstIndex(of: temp)!][0]
        let minY = foodLocationArray[foodDistanceFromHead.firstIndex(of: temp)!][1]
        
        let path: ([Int], [(Int, Int)], Int, Int)
        
//        if mainScreenAlgoChoice == 3 &&
        
        if (((prevX == -1) && prevY == -1) || closetFoodBlockHit == true || currentScore == 0) {
                closetFoodBlockHit = false
                if mainScreenAlgoChoice == 0 {
                    test = []
                } else if mainScreenAlgoChoice == 2 {
                    path = breathFirstSearch(startSquare: Tuple(x: Int(minY), y: Int(minX)), goalSquare: Tuple(x:snakeHead.y, y:snakeHead.x), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: matrix), returnPathCost: false, returnSquaresVisited: false)
                    test = path.0
                    pathBlockCordinates = path.1
                } else if mainScreenAlgoChoice == 3 {
                    print("startSquare:", Tuple(x: Int(minY), y: Int(minX)))
                    print("goalSquare:", Tuple(x:snakeHead.y, y:snakeHead.x))
                    print("gameBoard:", gameBoardMatrixToDictionary(gameBoardMatrix: matrix))
                    path = depthFirstSearch(startSquare: Tuple(x: Int(minY), y: Int(minX)), goalSquare: Tuple(x:snakeHead.y, y:snakeHead.x), gameBoard: gameBoardMatrixToDictionary(gameBoardMatrix: matrix), returnPathCost: false, returnSquaresVisited: false)
                    test = path.0
                    pathBlockCordinates = path.1
                } else {
                    test = []
                }
            }
//            print(UserDefaults.standard.bool(forKey: "Step Mode On Setting"))
            if UserDefaults.standard.bool(forKey: "Step Mode On Setting") {
                
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let vc = appDelegate.window?.rootViewController {
                self.viewController = (vc.presentedViewController as? GameScreenViewController)
                self.viewController?.playButton.setImage(UIImage(named: "Play_Icon_Set"), for: .normal)
            }
            
            UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
            paused = true
            checkIfPaused()
        }
        // 1 == left, 2 == up, 3 == right, 4 == down
        prevX = Int(minY)
        prevY = Int(minX)
    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
    func runPredeterminedPath() {
        if gameStarted == true {
            if (test.count != 0) {
                swipe(ID: test[0])
                test.remove(at: 0)
                pathBlockCordinates.remove(at: 0)
                playSound(selectedSoundFileName: "sfx_coin_single3")
                onPathMode = true
            } else {
                onPathMode = false
            }
        }
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + Double(gameSpeed)
        } else if (paused == true) {
//            If the game is paused keep chicking if its paused.
            checkIfPaused()
        }
//        else if (generateVisited == true) {
//            nextTime = time + Double(gameSpeed)
//            print("update hit")
////            colorGameNodes()
////            checkIfPaused()
//        }
        else {
            if time >= nextTime! {
                nextTime = time + Double(gameSpeed)
                
                barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
                barrierNodesWaitingToBeRemoved.removeAll()
                
                runPredeterminedPath()
                updateSnakePosition()
                checkIfPaused()
                checkForDeath()
                checkForFoodCollision()
            }
        }
    }
    
    func checkIfPaused() {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            tempColor()
            paused = true
        } else {
            gameSpeed = UserDefaults.standard.float(forKey: "Snake Move Speed")
            paused = false
        }
    }
    
    func tempColor() {
//        for square in game.snakeBodyPos {
//            print(childNode(withName: "//2,2"))
//            square.fillColor = snakeBodySquareColor
//        }
        
        func contains(a:[Tuple], v:Tuple) -> Bool {
            let c1 = v.x
            let c2 = v.y
            for (v1) in a { if v1.x == c1 && v1.y == c2 { return true } }
            return false
        }
        
        for (node, xx, yy) in scene.gameBoard  {
            barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
            barrierNodesWaitingToBeRemoved.removeAll()
            
            for i in (barrierNodesWaitingToBeDisplayed) {
                if i.y == yy && i.x == xx {
                    node.fillColor = scene.barrierSquareColor
//                    node.run(scene.gameSquareAnimation(animation: 2))
                }
            }
            
            for i in (scene.foodPosition) {
                if Int((i.x)) == yy && Int((i.y)) == xx {
                    node.fillColor = scene.foodSquareColor
//                    node.run(scene.gameSquareAnimation(animation: 2))
                }
            }
            
            if contains(a: snakeBodyPos, v: Tuple(x: xx, y: yy)) {
                node.fillColor = scene.snakeBodySquareColor
                if contains(a: [snakeBodyPos.first!], v: Tuple(x: xx, y: yy)) {
                    node.fillColor = scene.snakeHeadSquareColor
                }
            }
//            else {
//                node.fillColor = scene.gameboardSquareColor
//            }
        }
    }
    
    func endTheGame() {
        updateScore()
        scene.foodPosition.removeAll()
        snakeBodyPos.removeAll()
    }
    
    // this is run when game hasent started. fix for optimization.
        func checkForDeath() {
        if snakeBodyPos.count > 0 {
            // Create temp variable of snake without the head.
            var snakeBody = snakeBodyPos
            snakeBody.remove(at: 0)
            // Implement wraping snake in god mode.
            // If head is in same position as the body the snake is dead.
            // The snake dies in corners becouse blocks are stacked.
            

            
            if contains(a: snakeBody, v: snakeBodyPos[0]) {
                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                    godModeWasTurnedOn = true
                } else {
                    endTheGame()
                }
            }
            
            let snakeHead = Tuple(x: snakeBodyPos[0].x, y: snakeBodyPos[0].y)
            if barrierNodesWaitingToBeDisplayed.contains(snakeHead) {
                endTheGame()
            }
        }
    }
    
    func checkForFoodCollision() {
        if scene.foodPosition != nil {
            let x = snakeBodyPos[0].x
            let y = snakeBodyPos[0].y
            var counter = 0
            
            for i in (scene.foodPosition) {
//                if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                if Int((i.x)) == y && Int((i.y)) == x {
                    if prevX == Int((i.x)) && prevY == Int((i.y)) {
//                        print("closet hit")
                        closetFoodBlockHit = true
                    }
                    
//                    matrix[Int(i.x)][Int(i.y)] = 0
                    matrix[Int(i.y)][Int(i.x)] = 0
                    foodCollisionPoint = counter
                    foodLocationArray.remove(at: foodCollisionPoint)
                    scene.foodPosition.remove(at: foodCollisionPoint)
                    foodDistanceFromHead.remove(at: foodCollisionPoint)
                    
                    
                    spawnFoodBlock()
                    playSound(selectedSoundFileName: "sfx_coin_double3")
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    
                    // Update the score
                    if !(UserDefaults.standard.bool(forKey: "God Button On Setting")) {
                         currentScore += 1
                     }
                    
                    // Grow snake by 3 blocks.
                    let max = UserDefaults.standard.integer(forKey: "Food Weight Setting")
                    for _ in 1...max {
                        snakeBodyPos.append(snakeBodyPos.last!)
                    }
                }
                counter += 1
            }
         }
    }
    
    func playSound(selectedSoundFileName: String) {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        let musicPath = Bundle.main.path(forResource: selectedSoundFileName, ofType:"wav")!
        let url = URL(fileURLWithPath: musicPath)
        
        if UserDefaults.standard.bool(forKey: "Volume On Setting") {
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                self.player = sound
                sound.play()
            } catch {
                print("Error playing file")
            }
        }
    }
    
    func swipe(ID: Int) {
//        if onPathMode == false {
//            if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
//                if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                playerDirection = ID
//                }
//            }
//        }
    }
    
    private func updateSnakePosition() {
        var xChange = -1
        var yChange = 0

        switch playerDirection {
            case 1:
                //left
                xChange = -1
                yChange = 0
                break
            case 2:
                //up
                xChange = 0
                yChange = -1
                break
            case 3:
                //right
                xChange = 1
                yChange = 0
                break
            case 4:
                //down
                xChange = 0
                yChange = 1
                break
            default:
                break
        }

        if snakeBodyPos.count > 0 {
            var start = snakeBodyPos.count - 1
            matrix[snakeBodyPos[start].x][snakeBodyPos[start].y] = 0
            while start > 0 {
                snakeBodyPos[start] = snakeBodyPos[start - 1]
                start -= 1
            }
            // Can be reduced only 3 blocks need to be updated.
            snakeBodyPos[0].x = (snakeBodyPos[0].x + yChange)
            snakeBodyPos[0].y = (snakeBodyPos[0].y + xChange)
            matrix[snakeBodyPos[0].x][snakeBodyPos[0].y] = 1
            matrix[snakeBodyPos[1].x][snakeBodyPos[1].y] = 2
//            matrix[snakeBodyPos[2].0][snakeBodyPos[2].1] = 2
//            matrix[snakeBodyPos[3].0][snakeBodyPos[3].1] = 2
//            matrix[snakeBodyPos[4].0][snakeBodyPos[4].1] = 2
//            matrix[snakeBodyPos[5].0][snakeBodyPos[5].1] = 2
//            for i in 0...(scene.rowCount-1) {
//                print(matrix[i])
//            }
//            print("----")
        }
        
        if snakeBodyPos.count > 0 {
            let x = snakeBodyPos[0].y
            let y = snakeBodyPos[0].x
            if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                // modified to debug
//                if y > verticalMaxBoundry { // Moving To Bottom
//                    snakeBodyPos[0].0 = verticalMinBoundry // Spawning At Top
//                } else if y < verticalMinBoundry { // Moving to top
//                    snakeBodyPos[0].0 = verticalMaxBoundry // Spawning at bottom
//                } else if x > horizontalMaxBoundry { // Moving to right
//                    snakeBodyPos[0].1 = horizontalMinBoundry // Spawning on left
//                } else if x < horizontalMinBoundry { // Moving to left
//                    snakeBodyPos[0].1 = horizontalMaxBoundry // Spawning on right
//                }
            } else {
                if y > verticalMaxBoundry { // Moving To Bottom
                    endTheGame()
                } else if y < verticalMinBoundry { // Moving to top
                    endTheGame()
                } else if x > horizontalMaxBoundry { // Moving to right
                    endTheGame()
                } else if x < horizontalMinBoundry { // Moving to left
                    endTheGame()
                }
            }
        }
        colorGameNodes()
    }
    
    func colorGameNodes() {
        for (node, x, y) in scene.gameBoard {
            
            if contains(a: snakeBodyPos, v: Tuple(x: x, y: y)) {
                if (onPathMode == false) {
                    node.fillColor = SKColor.white
//                    node.run(scene.gameSquareAnimation())
//                    node.run(scene.gameSquareAnimation(animation: 2))
                }
            }
            
            for i in (pathBlockCordinates) {
                if Int((i.0)) == y && Int((i.1)) == x {
                    node.fillColor = scene.pathSquareColor
                }
            }
            
            // add closest food to legend
            if contains(a: snakeBodyPos, v: Tuple(x: x, y: y)) {
                if (onPathMode == true) {
                    node.fillColor = scene.snakeBodySquareColor
                    if contains(a: [snakeBodyPos.first!], v: Tuple(x: x, y: y)) {
                        node.fillColor = scene.snakeHeadSquareColor
//                        node.run(scene.gameSquareAnimation(animation: 2))
//                        colorVisitedSquares(visited: [Tuple(x: x, y: y)])
                    }
                }
            }
            
            else {
                // error loading colors on first lanch for food pellet.
                // error snake speed on first load.
                // paused is broken
                node.fillColor = scene.gameboardSquareColor
                if scene.foodPosition.isEmpty != true {
                    
                    for i in (scene.foodPosition) {
                        if Int((i.x)) == y && Int((i.y)) == x {
                            node.fillColor = scene.foodSquareColor
//                            node.run(scene.gameSquareAnimation(animation: 2))
                        }
                    }
                    
                    for i in (barrierNodesWaitingToBeDisplayed) {
                        if i.y == y && i.x == x {
                            node.fillColor = scene.barrierSquareColor
//                           node.run(scene.gameSquareAnimation(animation: 2))
                        }
                    }
                    
                    
                    // if this works its more effietient.
                    //            if onPathMode == true {
                    //                if contains(a: pathBlockCordinates, v: (x,y)) {
                    //                    node.fillColor = UserDefaults.standard.colorForKey(key: "Path")!
                    //                }
                    //            }
                    
                    for i in (pathBlockCordinates) {
                        if Int((i.0)) == y && Int((i.1)) == x {
//                            print("-")
                            node.fillColor = scene.pathSquareColor
                        }
                    }
                }
            }
        }
    }
    
    func contains(a:[Tuple], v:Tuple) -> Bool {
        let c1 = v.x
        let c2 = v.y
        for (v1) in a { if v1.x == c1 && v1.y == c2 { return true } }
        return false
    }

    func updateScore() {
        // Update the high score if need be.
         if currentScore > UserDefaults.standard.integer(forKey: "highScore") {
              UserDefaults.standard.set(currentScore, forKey: "highScore")
         }
        
        // Reset and present score variables on game menu.
        UserDefaults.standard.set(currentScore, forKey: "lastScore")
         currentScore = 0
//         scene.highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
    }
}
