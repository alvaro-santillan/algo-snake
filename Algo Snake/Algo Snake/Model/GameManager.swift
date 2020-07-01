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

struct SkNodeAndLocation: Hashable {
    var square: SKShapeNode
    var location: Tuple
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
    var pathBlockCordinatesNotReversed = [(Int, Int)]()
    var onPathMode = false
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Float = 1
    var paused = false
    var playerDirection: Int = 4 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var barrierNodesWaitingToBeDisplayed: [(SkNodeAndLocation)] = []
    var barrierNodesWaitingToBeRemoved: [(SkNodeAndLocation)] = []
    var teeeemp = [(SKShapeNode, Tuple)]()
    var snakeBodyPos: [(SkNodeAndLocation)] = []
    var godModeWasTurnedOn = false
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    
    var conditionGreen = Bool()
    var conditionYellow = Bool()
    var conditionRed = Bool()
    var scoreButtonHalo = UIColor()
    
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    // Takes a two dimentional matrix, determins the legal squares.
    // The results are converted into a nested dictionary.
    func gameBoardMatrixToDictionary(gameBoardMatrix: Array<Array<Int>>) -> Dictionary<Tuple, Dictionary<Tuple, Float>> {
        // Initialize the two required dictionaries.
        var mazeDictionary = [Tuple : [Tuple : Float]]()
        var vaildMoves = [Tuple : Float]()
        
        var isYNegIndex = Bool()
        var isYIndex = Bool()
        var isXIndex = Bool()
        var isXNefIndex = Bool()
        let xMax = scene.columnCount
        let yMax = scene.rowCount

        // Loop through every cell in the maze.
        for(y, matrixRow) in gameBoardMatrix.enumerated() {
            for(x, _) in matrixRow.enumerated() {
                // If in a square that is leagal, append valid moves to a dictionary.
                if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 3 || gameBoardMatrix[y][x] == 1) {
//                    print("valid square", x, y)
//                    let yMin = 0
//                    let xMin = 0
                    
//                    print("x,y", x, y)
                    
                    if (y+1 >= yMax) {
                        isYIndex = false
                    } else {
                        isYIndex = true
//                        print("y+1", gameBoardMatrix[y+1][x])
                    }
                    
                    if (x+1 >= xMax) {
                        isXIndex = false
                    } else {
                        isXIndex = true
//                        print("x+1", x+1, "xMax", xMax)
//                        print("x+1", gameBoardMatrix[y][x+1])
                    }
                    
                    if (y-1 < 0) {
                        isYNegIndex = false
                    } else {
                        isYNegIndex = true
//                        print("y-1", gameBoardMatrix[y-1][x])
                    }
                    
                    if (x-1 < 0) {
                        isXNefIndex = false
                    } else {
                        isXNefIndex = true
//                        print("x-1", gameBoardMatrix[y][x-1])
                    }
                    
//                    print("isYIndex", isYIndex)
//                    print("isXIndex", isXIndex)
//                    print("isYNegIndex", isYNegIndex)
//                    print("isXNefIndex", isXNefIndex)
//
//                    if (y == 1 && x == 0) {
//                        print("Target Sited:", gameBoardMatrix[y][x])
//                        print(gameBoardMatrix[y-1][x])
//                        print(gameBoardMatrix[y+1][x])
//                        print(gameBoardMatrix[y][x+1])
////                        print(gameBoardMatrix[y][x-1])
//                    }
//
//                    if (y == 0 && x == 1) {
//                        print("Target Sited:", gameBoardMatrix[y][x])
//                    }
                    
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
//        print(mazeDictionary)
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
                    movePath.append(4)
                // 1 == left, 2 == up, 3 == right, 4 == down
                } else if (xValue == 0 && yValue == -1) {
                    movePath.append(2)
                // 1 == left, 2 == up, 3 == right, 4 == down
                } else if (xValue == 1 && yValue == 0) {
                    movePath.append(3)
                // 1 == left, 2 == up, 3 == right, 4 == down
                } else if (xValue == -1 && yValue == 0) {
                    movePath.append(1)
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
    var fronteerSquareArray = [[SKShapeNode]]()
    var pathSquareArray = [SKShapeNode]()
    

    
    func colorVisitedSquares(visitedX: Int, visitedY: Int) {
        let node = scene.gameBoard.first(where: {$0.x == visitedX && $0.y == visitedY})?.node
        visitedNodeArray.append(node!)
//        node!.fillColor = UserDefaults.standard.colorForKey(key: "Visited Square")!
//        print("Node at:", visitedX, visitedY)
    }

    
    func fronteerSquaress(rawSquares: [Tuple]) {
        var innerFronterSquares = [SKShapeNode]()
        for node in rawSquares {
            let node = scene.gameBoard.first(where: {$0.x == node.y && $0.y == node.x})?.node
            innerFronterSquares.append(node!)
        }
        fronteerSquareArray.append(innerFronterSquares)
//        node!.fillColor = UserDefaults.standard.colorForKey(key: "Visited Square")!
//            print("Node at:", visitedX, visitedY)
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
    func breathFirstSearch(startSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Int, Int)], Int, Int) {
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        while (!(scene.foodPosition.contains(currentSquare))) {
            // Mark current node as visited. (If statement required due to first node.)
            if !(visitedSquares.contains(currentSquare)) {
                visitedSquares += [currentSquare]
                colorVisitedSquares(visitedX: currentSquare.y, visitedY: currentSquare.x)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            var newFornterSquareHolder = [Tuple]()
            for (prospectFronterSquare, _) in gameBoard[currentSquare]! {
                if !(visitedSquares.contains(prospectFronterSquare)) {
                    if !(fronterSquares.contains(prospectFronterSquare)){
                        fronterSquares += [prospectFronterSquare]
                        newFornterSquareHolder.append(Tuple(x: prospectFronterSquare.x, y: prospectFronterSquare.y))
                        squareAndParentSquare[prospectFronterSquare] = currentSquare
                    }
                }
            }
            fronteerSquaress(rawSquares: newFornterSquareHolder)
            
            // Update current and fronter
            if fronterSquares.count != 0 {
                // New currentNode is first in queue (BFS).
                currentSquare = fronterSquares[0]
                fronterSquares.remove(at: 0)
            } else {
                conditionGreen = false
                conditionYellow = true
                conditionRed = false
                
                if conditionYellow == true && squareAndParentSquare.count < 15 {
                    conditionGreen = false
                    conditionYellow = false
                    conditionRed = true
                }
                
                return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
            }
        }
        // Genarate a path and optional statistics from the results of BFS.
        conditionGreen = true
        conditionYellow = false
        conditionRed = false
        return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
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
    func depthFirstSearch(startSquare: Tuple, gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Int, Int)], Int, Int) {
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        
        while (!(scene.foodPosition.contains(currentSquare))) {
            // Mark current node as visited. (If statement required due to first node.)
            if !(visitedSquares.contains(currentSquare)) {
                visitedSquares += [currentSquare]
                colorVisitedSquares(visitedX: currentSquare.y, visitedY: currentSquare.x)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            var newFornterSquareHolder = [Tuple]()
            for (prospectFronterSquare, _) in gameBoard[currentSquare]! {
                if !(visitedSquares.contains(prospectFronterSquare)) {
                    if !(fronterSquares.contains(prospectFronterSquare)){
                        fronterSquares += [prospectFronterSquare]
                        newFornterSquareHolder.append(Tuple(x: prospectFronterSquare.x, y: prospectFronterSquare.y))
                        squareAndParentSquare[prospectFronterSquare] = currentSquare
                    }
                }
            }
            fronteerSquaress(rawSquares: newFornterSquareHolder)
            
            if fronterSquares.count != 0 {
                currentSquare = fronterSquares.last!
                fronterSquares.popLast()
            } else {
                conditionGreen = false
                conditionYellow = true
                conditionRed = false
                
                if conditionYellow == true && squareAndParentSquare.count < 15 {
                    conditionGreen = false
                    conditionYellow = false
                    conditionRed = true
                }
                return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
            }
        }
        // Genarate a path and optional statistics from the results of DFS.
        conditionGreen = true
        conditionYellow = false
        conditionRed = false
        return(formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited))
    }
    
    // Understood - Initiate the starting position of the snake.
    func initiateSnakeStartingPosition() {
        // Must be run at the very begining.
        verticalMaxBoundry = (scene.rowCount - 2)
        verticalMinBoundry = 1
        horizontalMaxBoundry = (scene.columnCount - 2)
        horizontalMinBoundry = 1
        
        // Dont forget to change back
        var node = scene.gameBoard.first(where: {$0.x == 0 && $0.y == 0})?.node
        snakeBodyPos.append(SkNodeAndLocation(square: node!, location: Tuple(x: 0, y: 0)))
        matrix[0][0] = 1
        
        node = scene.gameBoard.first(where: {$0.x == 0 && $0.y == 1})?.node
        snakeBodyPos.append(SkNodeAndLocation(square: node!, location: Tuple(x: 0, y: 1)))
        matrix[0][1] = 2
        
        spawnFoodBlock()
        gameStarted = true
    }
    
    // Understood - Spawn a new food block into the game.
    var prevX = -1
    var prevY = -1
    var foodLocationArray: [[Int]] = []
    var foodCollisionPoint = Int()
    let mainScreenAlgoChoice = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var foodBlocksHaveAnimated = Bool()
    var snakeBlockHaveAnimated = false
    
    func spawnFoodBlock() {
        let foodPalletsNeeded = (UserDefaults.standard.integer(forKey: "Food Count Setting") - foodLocationArray.count)
        
        // need to use queue.
        if foodPalletsNeeded > 0 {
            for _ in 1...foodPalletsNeeded {
                foodBlocksHaveAnimated = false
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
                        if i.location.y == randomY && i.location.x == randomX {
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
                        if i.location.y == randomY && i.location.x == randomX {
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
                scene.foodPosition.append(Tuple(x: randomY, y: randomX))
            }
        }
        pathSelector()
    }
        
    func pathSelector() {
        var path: ([Int], [(Int, Int)], Int, Int)?
        func pathManager() {
            test = path!.0.reversed()
            pathBlockCordinatesNotReversed = path!.1
            pathBlockCordinates = path!.1.reversed()
        }
        
//        snakeHead = Tuple(x:snakeHead.y, y:snakeHead.x)
        let snakeHead = Tuple(x: snakeBodyPos[0].location.y, y: snakeBodyPos[0].location.x)
        let gameBoardDictionary = gameBoardMatrixToDictionary(gameBoardMatrix: matrix)
        if mainScreenAlgoChoice == 2 {
            path = breathFirstSearch(startSquare: snakeHead, gameBoard: gameBoardDictionary, returnPathCost: false, returnSquaresVisited: false)
            pathManager()
        } else if mainScreenAlgoChoice == 3 {
            path = depthFirstSearch(startSquare: snakeHead, gameBoard: gameBoardDictionary, returnPathCost: false, returnSquaresVisited: false)
            pathManager()
        } else {
            test = []
        }
        for i in pathBlockCordinatesNotReversed {
            let node = scene.gameBoard.first(where: {$0.x == i.1 && $0.y == i.0})?.node
            pathSquareArray.append(node!)
        }

        if UserDefaults.standard.bool(forKey: "Step Mode On Setting") {
                // problem
            if scene.firstAnimationSequanceComleted == true {
                viewControllerComunicationsManager(updatingPlayButton: true, playButtonIsEnabled: true, updatingScoreButton: false)
            }

            
            UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
            paused = true
            checkIfPaused()
        }
    }
    
    func viewControllerComunicationsManager(updatingPlayButton: Bool, playButtonIsEnabled: Bool, updatingScoreButton: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
            
            if updatingPlayButton {
                if playButtonIsEnabled == true {
                    self.viewController?.playButton.setImage(UIImage(named: "Play_Icon_Set"), for: .normal)
                    self.viewController?.barrierButton.isEnabled = true
                    self.viewController?.playButton.isEnabled = true
                } else if playButtonIsEnabled == false {
                    self.viewController?.playButton.setImage(UIImage(named: "Pause_Icon_Set"), for: .normal)
                    self.viewController?.playButton.isEnabled = false
                    self.viewController?.barrierButton.isEnabled = false
                }
            }
            
            if updatingScoreButton {
                self.viewController?.loadScoreButtonStyling()
            }

            if conditionGreen {
                self.viewController?.scoreButton.layer.borderColor = UIColor.green.cgColor
            } else if conditionYellow {
                self.viewController?.scoreButton.layer.borderColor = UIColor.yellow.cgColor
            } else if conditionRed {
                self.viewController?.scoreButton.layer.borderColor = UIColor.red.cgColor
            }
            
            let scoreButtonTag = self.viewController?.scoreButton.tag
//            print("Sender Tag", scoreButtonTag)
            
            switch scoreButtonTag {
            case 1: // Highscore
                self.viewController?.scoreButton.setTitle("HS: " + String(UserDefaults.standard.integer(forKey: "highScore")), for: .normal)
            case 2: // Snake lenght
                self.viewController?.scoreButton.setTitle(String(snakeBodyPos.count), for: .normal)
            case 3: // Food
                self.viewController?.scoreButton.setTitle(String(foodLocationArray.count), for: .normal)
            case 4: // Path
                self.viewController?.scoreButton.setTitle(String(test.count), for: .normal)
            case 5: // Visited
                self.viewController?.scoreButton.setTitle(String(scene.animatedVisitedNodeCount), for: .normal)
            case 6: // Queued
                self.viewController?.scoreButton.setTitle(String(scene.animatedQueuedNodeCount), for: .normal)
            case 7: // Barriers
                self.viewController?.scoreButton.setTitle(String(barrierNodesWaitingToBeDisplayed.count), for: .normal)
            case 8: // Weight
                self.viewController?.scoreButton.setTitle("NA", for: .normal)
            case 9: // Score
                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                    self.viewController?.scoreButton.setTitle("NA", for: .normal)
                } else {
                    self.viewController?.scoreButton.setTitle(String(currentScore), for: .normal)
                }
            default:
                print("Error")
            }
            
        }
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
                if !(scene.temporaryPath.isEmpty) {
                    scene.temporaryPath.removeLast()
                }
                playSound(selectedSoundFileName: "sfx_coin_single3")
                onPathMode = true
            } else {
                onPathMode = false
//                UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
//                paused = true
                pathSelector()
                onPathMode = true
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
        else {
            if time >= nextTime! {
                nextTime = time + Double(gameSpeed)
                barrierSquareManager()
                viewControllerComunicationsManager(updatingPlayButton: false, playButtonIsEnabled: false, updatingScoreButton: false)
                runPredeterminedPath()
                updateSnakePosition()
                checkIfPaused()
                checkForDeath()
                checkForFoodCollision()
            }
        }
    }
    
    var barrierSquaresSKNodes: [(square: SKShapeNode, x: Int, y: Int)] = []
    func barrierSquareManager() {
        barrierSquaresSKNodes.removeAll()
        
//        for (square, location) in barrierNodesWaitingToBeRemoved.enumerated() {
//            if barrierNodesWaitingToBeDisplayed
//        }
        
        barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
        barrierNodesWaitingToBeRemoved.removeAll()
        
        for i in barrierNodesWaitingToBeDisplayed {
            let node = scene.gameBoard.first(where: {$0.x == i.location.x && $0.y == i.location.y})?.node
//            barrierSquaresSKNodes.append(node!)
            barrierSquaresSKNodes.append((square: node!, x: i.location.x, y: i.location.y))
        }
    }
    
    func checkIfPaused() {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            tempColor()
            paused = true
        } else {
            scene.animatedVisitedNodeCount = 0
            scene.animatedQueuedNodeCount = 0
            gameSpeed = UserDefaults.standard.float(forKey: "Snake Move Speed")
//            scene.clearToDisplayPath = false
            paused = false
        }
    }
    
    var snakeBodyPosSK = [SKShapeNode]()
    var foodSK = [SKShapeNode]()
    var pathHasBeenAnimated = false
    var foodName = String()
    func tempColor() {
        func contains(a:[Tuple], v:Tuple) -> Bool {
            let c1 = v.x
            let c2 = v.y
            for (v1) in a { if v1.x == c1 && v1.y == c2 { return true } }
            return false
        }
        
        func convertSnakeToSKShape() {
            for i in snakeBodyPos {
                let node = scene.gameBoard.first(where: {$0.x == i.location.x && $0.y == i.location.y})?.node
                snakeBodyPosSK.append(node!)
            }
        }
        
        func convertFoodToSKShape() {
            for i in scene.foodPosition {
                let node = scene.gameBoard.first(where: {$0.x == i.y && $0.y == i.x})?.node
                foodSK.append(node!)
            }
        }
        
        // Re-renders changes when user instructs blocks to change color.
        func manageSquareColorWhilePathFindingAnimationsAreStillBeingDisplayed() {
            
            // Works need to optimise this 14 frames cuz of this.
            for i in (scene.temporaryFronteerSquareArray) {
                for j in i {
                    if j.name != foodName {
                        j.fillColor = scene.queuedSquareColor
                    }
                }
            }
        
            for i in (scene.temporaryVisitedSquareArray) {
                i.fillColor = scene.visitedSquareColor
            }
    
            colorPath()
            
            scene.settingsWereChanged = false
            pathHasBeenAnimated = true
        }
        
        func colorGameboard() {
            for i in scene.gameBoard {
                i.node.fillColor = scene.gameboardSquareColor
            }
        }
        
        func colorPath() {
            for i in (scene.temporaryPath) {
                i.fillColor = .systemOrange
            }
        }
        
        func colorBarriers() {
            for i in (barrierSquaresSKNodes) {
                i.square.fillColor = scene.barrierSquareColor
            }
        }
        
        func colorSnake() {
            for (index, i) in snakeBodyPosSK.enumerated() {
                if index == 0 {
                    i.fillColor = scene.snakeHeadSquareColor
                } else {
                    i.fillColor = scene.snakeBodySquareColor
                }
            }
        }
        
        func colorFood() {
            for i in (foodSK) {
                i.fillColor = scene.foodSquareColor
                foodName = i.name!
                
                if foodBlocksHaveAnimated == false {
                    i.run(scene.gameSquareAnimation(animation: 3))
                    foodBlocksHaveAnimated = true
                }
            }
        }
        
        convertSnakeToSKShape()
        convertFoodToSKShape()
        var squareHasBeenUpdated = false
        
        if scene.pathFindingAnimationsEnded {
            if !(UserDefaults.standard.bool(forKey: "Game Is Paused Setting")) {
                colorGameboard()
            }
        
            if scene.settingsWereChanged {
                manageSquareColorWhilePathFindingAnimationsAreStillBeingDisplayed()
            }
            
            // Displays path after path finding animation ends.
            // Bug scene.pathFindingAnimationsEnded is broken or other if needed.
            colorPath()
        }
        
        if squareHasBeenUpdated == false {
            colorBarriers()
        }
        
        if scene.gamboardAnimationEnded == true {
            if squareHasBeenUpdated == false {
                colorSnake()
            }
            
            if squareHasBeenUpdated == false {
                colorFood()
                squareHasBeenUpdated = true
            }
        }
        snakeBodyPosSK.removeAll()
        foodSK.removeAll()
    }
    
    func clearBoardManager() {
        // buggy
        func barrierClear() {
            print("Barrier count", barrierSquaresSKNodes.count)
            for i in (barrierSquaresSKNodes) {
                i.square.fillColor = scene.gameboardSquareColor
                matrix[i.x][i.y] = 0
            }
        }
        
        func pathClear() {
            for i in (scene.temporaryPath) {
                i.fillColor = scene.gameboardSquareColor
            }
        }
        
        func fronteerClear() {
            for i in (scene.temporaryFronteerSquareArray) {
                for j in i {
                    if j.name != foodName {
                        j.fillColor = scene.gameboardSquareColor
                    }
                }
            }
        }
        
        func visitedClear() {
            for i in (scene.temporaryVisitedSquareArray) {
                i.fillColor = scene.gameboardSquareColor
            }
        }
        
        if UserDefaults.standard.bool(forKey: "Clear All Setting") {
            barrierClear()
            pathClear()
            fronteerClear()
            visitedClear()
            
            barrierNodesWaitingToBeDisplayed.removeAll()
            barrierNodesWaitingToBeRemoved.removeAll()
            scene.temporaryFronteerSquareArray.removeAll()
            scene.temporaryVisitedSquareArray.removeAll()
            scene.temporaryPath.removeAll()
            UserDefaults.standard.set(false, forKey: "Clear All Setting")
        }
//        else {
            if UserDefaults.standard.bool(forKey: "Clear Barrier Setting") {
                barrierClear()
                UserDefaults.standard.set(false, forKey: "Clear Barrier Setting")
            }
            
            if UserDefaults.standard.bool(forKey: "Clear Path Setting") {
                pathClear()
                UserDefaults.standard.set(false, forKey: "Clear Path Setting")
            }
//        }
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
            

            if snakeBody.contains(snakeBodyPos[0]) {
//            if contains(a: snakeBody, v: snakeBodyPos[0]) {
                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                    godModeWasTurnedOn = true
                } else {
                    endTheGame()
                }
            }
            
            let snakeHead = snakeBodyPos[0]
            // temp removal
            if barrierNodesWaitingToBeDisplayed.contains(snakeHead) {
                endTheGame()
            }
        }
    }
    
    func checkForFoodCollision() {
        if scene.foodPosition != nil {
            let x = snakeBodyPos[0].location.x
            let y = snakeBodyPos[0].location.y
            var counter = 0
            
            for i in (scene.foodPosition) {
                if Int((i.x)) == y && Int((i.y)) == x {
                    
                    matrix[Int(i.y)][Int(i.x)] = 0
                    foodCollisionPoint = counter
                    foodLocationArray.remove(at: foodCollisionPoint)
                    scene.foodPosition.remove(at: foodCollisionPoint)
                    
                    
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
            matrix[snakeBodyPos[start].location.x][snakeBodyPos[start].location.y] = 0
            while start > 0 {
                snakeBodyPos[start] = snakeBodyPos[start - 1]
                start -= 1
            }
            // Can be reduced only 3 blocks need to be updated.
            snakeBodyPos[0].location.x = (snakeBodyPos[0].location.x + yChange)
            snakeBodyPos[0].location.y = (snakeBodyPos[0].location.y + xChange)
            matrix[snakeBodyPos[0].location.x][snakeBodyPos[0].location.y] = 1
            matrix[snakeBodyPos[1].location.x][snakeBodyPos[1].location.y] = 2
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
            let x = snakeBodyPos[0].location.y
            let y = snakeBodyPos[0].location.x
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
        tempColor()
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

