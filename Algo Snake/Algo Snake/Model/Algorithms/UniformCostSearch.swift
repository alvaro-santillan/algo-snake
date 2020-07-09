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
    func uniformCostSearch(startSquare: Tuple, foodLocations: [SkNodeAndLocation], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> (([Int], [(Tuple)], Int, Int), [SkNodeAndLocation], [[SkNodeAndLocation]], [SkNodeAndLocation], [Bool]) {
        let algorithmHelperObject = AlgorithmHelper(scene: scene)
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        // Initiate a priority queue class.
        let priorityQueueClass = PriorityQueue(square: startSquare, cost: 0)
        var currentSquare = startSquare
        var currentCost = Float()
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]

        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        // Note if statment bellow breaks for the while (bug to fix).
        while (!(foodLocations.contains(where: { $0.location == currentSquare }))) {
            // Set the path cost and the current square equal to the lowest path node in the priority queue.
            // Pop the square as well (mark as visited)
            (currentCost, currentSquare) = priorityQueueClass.pop() as! (Float, Tuple)
            
            // Break the loop one goalSquare is in sight (To-Do optimize this).
            if (foodLocations.contains(where: { $0.location == currentSquare })) {
                break
            }
            
            visitedSquares += [currentSquare]
            visitedSquareBuilder(visitedX: currentSquare.y, visitedY: currentSquare.x)
            visitedSquareCount += 1
            
            // Repeat through all the squares in the sub dictionary.
            // Update the info stored for the child squares.
            var newFornterSquareHolder = [Tuple]()
            // If statment handles seg fault so that game can continue.
            if gameBoard[currentSquare] != nil {
                for (prospectSquare, prospectSquareCost) in gameBoard[currentSquare]! {
                    // Calculate the path cost to the new square.
                    let prospectPathCost = currentCost + prospectSquareCost + 1
                    
                    // If the square has not been visited add to the add to the queue and mark its parent.
                    if !(visitedSquares.contains(prospectSquare)) {
                        if !(priorityQueueClass.heap.values.contains(prospectSquare)) {
                            
                            priorityQueueClass.add(square: prospectSquare, cost: prospectPathCost)
                            newFornterSquareHolder.append(Tuple(x: prospectSquare.x, y: prospectSquare.y))
                            squareAndParentSquare[prospectSquare] = currentSquare
                        }
                    }
                }
            } else {
                return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
            fronteerSquaresBuilder(squareArray: newFornterSquareHolder)
        }
        // Genarate a path and optional statistics from the results of UCS.
        return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
    }
}
