//
//  UniformCostSearch.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/9/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

// Steps in Depth First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select the last unvisited child node to explore.
// Repeat untill the goal is visited.

import Foundation
import SpriteKit

class UniformCostSearch {
    weak var scene: GameScene!
    var conditionGreen = Bool()
    var conditionYellow = Bool()
    var conditionRed = Bool()
    var visitedSquareArray = [SkNodeAndLocation]()
    var fronteerSquareArray = [[SkNodeAndLocation]]()
    var pathSquareArray = [SkNodeAndLocation]()

    init(scene: GameScene) {
        self.scene = scene
    }
    
    func visitedSquareBuilder(visitedX: Int, visitedY: Int) {
        let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: visitedX, y: visitedY)})?.square
        visitedSquareArray.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: visitedX, y: visitedY)))
    }
    
    func fronteerSquaresBuilder(squareArray: [Tuple]) {
        var innerFronterSKSquareArray = [SkNodeAndLocation]()
        for square in squareArray {
            let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: square.y, y: square.x)})?.square
            innerFronterSKSquareArray.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: square.x, y: square.y)))
        }
        fronteerSquareArray.append(innerFronterSKSquareArray)
    }
    
    func mazeSquareBuilder(visitedX: Int, visitedY: Int) {
        let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: visitedX, y: visitedY)})?.square
        scene.game.barrierNodesWaitingToBeDisplayed.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: visitedX, y: visitedY)))
        squareSK!.fillColor = scene.barrierSquareColor
        scene.colorTheBarriers()
        scene.game.matrix[visitedX][visitedY] = 7
    }
    
    // Simulated priority queue using a simulated heap.
    class PriorityQueue {
        var heap: [Tuple : Float] = [:]
        
        init(cost: Float, square: Tuple) {
            // Add first square manually.
            add(square: square, cost: cost)
        }
        
        // Add a passed tuple to the frontier
        func add(square: Tuple, cost: Float) {
            heap[square] = cost
            
        }
        
        // Return the lowest-cost tuple, and pop it off the frontier
        func pop() -> (Float?, Tuple?) {
            let minSquareAndCost = heap.min { a, b in a.value < b.value }
            if heap.count != 0 {
                heap.removeValue(forKey: minSquareAndCost!.key)
                return (minSquareAndCost?.value, minSquareAndCost?.key)
            }
            return (-2.0, Tuple(x: -2, y: -2))
        }
    }
        
    // UCS produces a dictionary in which each valid square points too only one parent.
    // Then the dictionary is processed to create a valid path.
    // The nodes are traversed in order found in the dictionary parameter.
    func uniformCostSearch(startSquare: Tuple, foodLocations: [SkNodeAndLocation], maze: [Tuple : [Tuple]], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> (([Int], [(Tuple)], Int, Int), [SkNodeAndLocation], [[SkNodeAndLocation]], [SkNodeAndLocation], [Bool]) {
        let algorithmHelperObject = AlgorithmHelper(scene: scene)
        
        var finalGameBoard = gameBoard
        
        if maze.count != 0 {
            for i in maze {
                if !(scene.game.snakeBodyPos.contains(where: { $0.location == Tuple(x: i.key.y, y: i.key.x) })) {
                    if !(scene.game.foodPosition.contains(where: { $0.location == Tuple(x: i.key.x, y: i.key.y) })) {
                        mazeSquareBuilder(visitedX: i.key.y, visitedY: i.key.x)
                    }
                }
                let firstChild = maze[i.key]
                for i in firstChild! {
                    if !(scene.game.snakeBodyPos.contains(where: { $0.location == Tuple(x: i.y, y: i.x) })) {
                        if !(scene.game.foodPosition.contains(where: { $0.location == Tuple(x: i.x, y: i.y) })) {
                            mazeSquareBuilder(visitedX: i.y, visitedY: i.x)
                        }
                    }
                }
            }
            finalGameBoard = algorithmHelperObject.gameBoardMatrixToDictionary(gameBoardMatrix: scene.game.matrix)
        }
        
        // Initalize variable and add first square manually.
        var visitedSquaresAndCost = [(square: Tuple, cost: Float)]()
        // Initiate a priority queue class.
        let fronterPriorityQueueClass = PriorityQueue(cost: 0, square: startSquare)
        var currentSquare = startSquare
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        
        // Potentential Trash
        var currentCost = Float()

        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        // Note if statment bellow breaks for the while (bug to fix).
        while (!(foodLocations.contains(where: { $0.location == currentSquare }))) {
            // Set the path cost and the current square equal to the lowest path node in the priority queue.
            // Pop the square as well (mark as visited)
            
            // Add shortest in fronter to visited
            let priviousCurrentSquare = currentSquare
            (currentCost, currentSquare) = fronterPriorityQueueClass.pop() as! (Float, Tuple)
            
            if currentCost == -2 {
                conditionGreen = false
                conditionYellow = false
                conditionRed = true
                
                return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: priviousCurrentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
            
            visitedSquaresAndCost.append((currentSquare, currentCost))
            
            // Break the loop one goalSquare is in sight (To-Do optimize this).
            if (foodLocations.contains(where: { $0.location == currentSquare })) {
                if squareAndParentSquare.count < 45 {
                    conditionGreen = false
                    conditionYellow = true
                    conditionRed = false
                    
                    return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
                }
                
                // Looks like this is an optimization.
                break
            }
            
            // step over this
            visitedSquareBuilder(visitedX: currentSquare.y, visitedY: currentSquare.x)
            visitedSquareCount += 1
            
            // Repeat through all the squares in the sub dictionary.
            // Update the info stored for the child squares.
            var newFornterSquareHolder = [Tuple]()
            var prospectPathCost = Float()
            // If statment handles seg fault so that game can continue.
            if finalGameBoard[currentSquare] != nil {
                for (prospectSquare, prospectSquareCost) in finalGameBoard[currentSquare]! {
                    // Calculate the path cost to the new square.
                    if prospectSquareCost == 1.1 {
                        prospectPathCost = currentCost + 1
                    } else if prospectSquareCost == 1.2 {
                        prospectPathCost = currentCost + 1
                    } else if prospectSquareCost == 1.3 {
                        prospectPathCost = currentCost + 1
                    } else {
                        prospectPathCost = currentCost + prospectSquareCost
                    }
                    
                    // If the square has not been visited add to the add to the queue and mark its parent.
                    if !(fronterPriorityQueueClass.heap.keys.contains(prospectSquare)) {
                        if !(visitedSquaresAndCost.contains(where: { $0.square == prospectSquare})) {
                            // Add new node to fronter. mark parent
                            fronterPriorityQueueClass.add(square: prospectSquare, cost: prospectPathCost)
                            newFornterSquareHolder.append(Tuple(x: prospectSquare.x, y: prospectSquare.y))
                            squareAndParentSquare[prospectSquare] = currentSquare
                        } else {
                            let tempIndex = (visitedSquaresAndCost.firstIndex(where: { $0.square == prospectSquare}))
                            let temp = visitedSquaresAndCost[tempIndex!]
                            if temp.cost > prospectPathCost {
                                visitedSquaresAndCost[tempIndex!] = (prospectSquare, prospectPathCost)
//                                newFornterSquareHolder.append(Tuple(x: prospectSquare.x, y: prospectSquare.y))
                                squareAndParentSquare[prospectSquare] = currentSquare
                            }
                        }
                    }
                }
            } else {
                conditionGreen = false
                conditionYellow = true
                conditionRed = false
                
                if conditionYellow == true && squareAndParentSquare.count < 15 {
                    conditionGreen = false
                    conditionYellow = false
                    conditionRed = true
                }
                
                return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
            conditionGreen = true
            conditionYellow = false
            conditionRed = false
            fronteerSquaresBuilder(squareArray: newFornterSquareHolder)
        }
        // Genarate a path and optional statistics from the results of UCS.
        return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
    }
}
