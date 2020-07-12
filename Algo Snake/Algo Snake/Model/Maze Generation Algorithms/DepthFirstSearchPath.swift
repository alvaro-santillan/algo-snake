//
//  DepthFirstSearchPath.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/10/20.
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

class DepthFirstSearchPath {
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
    
    func mazeManager(squareAndParentSquare: [Tuple : Tuple]) -> [Tuple : [Tuple]] {
//        let squareAndParentSquare = [childSquare : parentSquare]
        let resizedSquareAndParentSquare = growMatrix(squareAndParentSquare: squareAndParentSquare)
        let parentSquareAndChildren = addMissingChildrenSquares(newSquareAndParentSquare: resizedSquareAndParentSquare)
        return parentSquareAndChildren
//        for i in resizedWithMissingChildAddedSquareAndParentSquare {
//            mazeSquareBuilder(visitedX: i.key.x, visitedY: i.key.y)
//            let firstChild = resizedWithMissingChildAddedSquareAndParentSquare[i.key]
//            for i in firstChild! {
//                mazeSquareBuilder(visitedX: i.x, visitedY: i.y)
//            }
//        }
    }
    
    // Grows path in both directions.
    func growMatrix(squareAndParentSquare: [Tuple : Tuple]) -> [Tuple : Tuple] {
        var newSquareAndParentSquare = [Tuple : Tuple]()
        
        for i in squareAndParentSquare {
            if i.key.x != 0 && i.key.y != 0 {
                if i.value.x != 0 && i.value.y != 0 {
                    let newChildX = i.key.x + (i.key.x - 1)
                    let newChildY = i.key.y + (i.key.y - 1)
                    let newParentX = i.value.x + (i.value.x - 1)
                    let newParentY = i.value.y + (i.value.y - 1)
                    
                    print("Old", i.key.x, i.key.y, i.value.x, i.value.y)
                    print("New", newChildX, newChildY, newParentX, newParentY)
                    newSquareAndParentSquare[Tuple(x: newChildX, y: newChildY)] = Tuple(x: newParentX, y: newParentY)
                }
            }
        }
        return newSquareAndParentSquare
    }

    func addMissingChildrenSquares(newSquareAndParentSquare: [Tuple : Tuple]) -> [Tuple : [Tuple]] {
        var parentSquareAndChildren = [Tuple : [Tuple]]()
        
        for i in newSquareAndParentSquare {
            if i.key.x == i.value.x {
                let missingChild = Tuple(x: i.key.x, y: abs((i.key.y + i.value.y)/2))
                parentSquareAndChildren[i.value] = [missingChild, i.key]
            } else if i.key.y == i.value.y {
                let missingChild = Tuple(x: abs((i.key.x + i.value.x)/2), y: i.key.y)
                parentSquareAndChildren[i.value] = [missingChild, i.key]
            }
        }
        return parentSquareAndChildren
    }
    
    func mazeSquareBuilder(visitedX: Int, visitedY: Int) {
        let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: visitedX, y: visitedY)})?.square
        visitedSquareArray.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: visitedX, y: visitedY)))
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

    // DFS produces a dictionary in which each valid square points too only one parent.
    // Then the dictionary is processed to create a valid path.
    // The nodes are traversed in order found in the dictionary parameter.
    func depthFirstSearchPath(startSquare: Tuple, foodLocations: [SkNodeAndLocation], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> [Tuple : [Tuple]] {
        let algorithmHelperObject = AlgorithmHelper(scene: scene)
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        var visitedSquareCount = 1
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [startSquare : Tuple(x:-1, y:-1)]
        var squareAndParentSquareMaze = [Tuple : Tuple]()
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        
        while (!(squareAndParentSquare.count == gameBoard.count)) {
            // Mark current node as visited. (If statement required due to first node.)
            if !(visitedSquares.contains(currentSquare)) {
                visitedSquares += [currentSquare]
//                visitedSquareBuilder(visitedX: currentSquare.y, visitedY: currentSquare.x)
                visitedSquareCount += 1
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            var newFornterSquareHolder = [Tuple]()
            // If statment handles seg fault so that game can continue.
            if gameBoard[currentSquare] != nil {
                for (prospectFronterSquare, _) in gameBoard[currentSquare]! {
                    if !(visitedSquares.contains(prospectFronterSquare)) {
                        squareAndParentSquareMaze[prospectFronterSquare] = currentSquare
                        // here
                        
                        
                        if !(fronterSquares.contains(prospectFronterSquare)) {
                            fronterSquares += [prospectFronterSquare]
                            newFornterSquareHolder.append(Tuple(x: prospectFronterSquare.x, y: prospectFronterSquare.y))
                            squareAndParentSquare[prospectFronterSquare] = currentSquare
                        }
                    }
                }
            }
//            fronteerSquaresBuilder(squareArray: newFornterSquareHolder)
            
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
                
//                print(squareAndParentSquareMaze)
                return mazeManager(squareAndParentSquare: squareAndParentSquareMaze)
//                return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
            }
        }
        // Genarate a path and optional statistics from the results of DFS.
        conditionGreen = true
        conditionYellow = false
        conditionRed = false

//        print(squareAndParentSquareMaze)
        return mazeManager(squareAndParentSquare: squareAndParentSquareMaze)
//        return(algorithmHelperObject.formatSearchResults(squareAndParentSquare: squareAndParentSquare, gameBoard: gameBoard, currentSquare: currentSquare, visitedSquareCount: visitedSquareCount, returnPathCost: returnPathCost, returnSquaresVisited: returnSquaresVisited), visitedNodeArray: visitedSquareArray, fronteerSquareArray: fronteerSquareArray, pathSquareArray: pathSquareArray, conditions: [conditionGreen, conditionYellow, conditionRed])
    }
}

