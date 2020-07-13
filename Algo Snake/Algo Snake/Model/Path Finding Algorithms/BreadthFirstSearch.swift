//
//  BreadthFirstSearch.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

// Steps in Breath First Search
// Mark parent
// Mark current node as visited.
// Append children nodes if needed to the fronter.
// Select one by one a unvisited child node to explore.
// Do this for all the child nodes
// Repeat untill the goal is visited.

import Foundation
import SpriteKit

class BreadthFirstSearch {
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

    // BFS produces a dictionary in which each valid square points too only one parent.
    // Then the dictionary is processed to create a valid path.
    // The nodes are traversed in order found in the dictionary parameter.
    func breathFirstSearch(startSquare: Tuple, foodLocations: [SkNodeAndLocation], maze: [Tuple : [Tuple]], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> (([Int], [(Tuple)], Int, Int), [SkNodeAndLocation], [[SkNodeAndLocation]], [SkNodeAndLocation], [Bool]) {
        let algorithmHelperObject = AlgorithmHelper(scene: scene)
        // Initalize variable and add first square manually.
        
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
                visitedSquareBuilder(visitedX: currentSquare.y, visitedY: currentSquare.x)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            var newFornterSquareHolder = [Tuple]()
            // If statment handles seg fault so that game can continue.
            if finalGameBoard[currentSquare] != nil {
                for (prospectFronterSquare, _) in finalGameBoard[currentSquare]! {
                    if !(visitedSquares.contains(prospectFronterSquare)) {
                        if !(fronterSquares.contains(prospectFronterSquare)){
                            fronterSquares += [prospectFronterSquare]
                            newFornterSquareHolder.append(Tuple(x: prospectFronterSquare.x, y: prospectFronterSquare.y))
                            squareAndParentSquare[prospectFronterSquare] = currentSquare
                        }
                    }
                }
            }
            fronteerSquaresBuilder(squareArray: newFornterSquareHolder)
            
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
                
                return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
        }
        // Genarate a path and optional statistics from the results of BFS.
        conditionGreen = true
        conditionYellow = false
        conditionRed = false
        
        return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: finalGameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
    }
}
