//
//  DepthFirstSearch.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class DepthFirstSearch {
    var scene: GameScene!
    var conditionGreen = Bool()
    var conditionYellow = Bool()
    var conditionRed = Bool()
    var visitedNodeArray = [SKShapeNode]()
    var fronteerSquareArray = [[SKShapeNode]]()
    var pathSquareArray = [SKShapeNode]()

    init(scene: GameScene) {
        self.scene = scene
    }
    
    func colorVisitedSquares(visitedX: Int, visitedY: Int) {
        let node = scene.gameBoard.first(where: {$0.x == visitedX && $0.y == visitedY})?.node
        visitedNodeArray.append(node!)
    }
    
    func fronteerSquaress(rawSquares: [Tuple]) {
        var innerFronterSquares = [SKShapeNode]()
        for node in rawSquares {
            let node = scene.gameBoard.first(where: {$0.x == node.y && $0.y == node.x})?.node
            innerFronterSquares.append(node!)
        }
        fronteerSquareArray.append(innerFronterSquares)
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
    func depthFirstSearch(startSquare: Tuple, foodLocations: [SkNodeAndLocation], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> (([Int], [(Tuple)], Int, Int), [SKShapeNode], [[SKShapeNode]], [SKShapeNode], [Bool]) {
        let sceleton = AlgorithmHelper(scene: scene)
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        
        while (!(foodLocations.contains(where: { $0.location == currentSquare }))) {
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
                return(sceleton.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedNodeArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
        }
        // Genarate a path and optional statistics from the results of DFS.
        conditionGreen = true
        conditionYellow = false
        conditionRed = false

        return(sceleton.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedNodeArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
    }
}
