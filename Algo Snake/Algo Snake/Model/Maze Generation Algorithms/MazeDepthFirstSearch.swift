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

class MazeDepthFirstSearch {
    weak var scene: GameScene!

    init(scene: GameScene) {
        self.scene = scene
    }

    // DFS produces a dictionary in which each valid square points too only one parent.
    // Then the dictionary is processed to create a valid path.
    // The nodes are traversed in order found in the dictionary parameter.
    func depthFirstSearchPath(startSquare: Tuple, foodLocations: [SkNodeAndLocation], gameBoard: [Tuple : Dictionary<Tuple, Float>], returnPathCost: Bool, returnSquaresVisited: Bool) -> [Tuple : [Tuple]] {
        let mazeAlgorithmHelperObject = MazeAlgorithmHelper(scene: scene)
        // Initalize variable and add first square manually.
        var visitedSquares = [Tuple]()
        var fronterSquares = [startSquare]
        var currentSquare = startSquare
        // Dictionary used to find a path, every square will have only one parent.
        var squareAndParentSquare = [Tuple : Tuple]()
        
        // Break once the goal is reached (the goals parent is noted a cycle before when it was a new node.)
        while (!(squareAndParentSquare.count == gameBoard.count)) {
            // Mark current node as visited. (If statement required due to first node.)
            if !(visitedSquares.contains(currentSquare)) {
                visitedSquares += [currentSquare]
            }
            
            // Repeat through all the nodes in the sub dictionary.
            // Append to fronter and mark parent.
            var newFornterSquareHolder = [Tuple]()
            // If statment handles seg fault so that game can continue.
            if gameBoard[currentSquare] != nil {
                for (prospectFronterSquare, _) in gameBoard[currentSquare]! {
                    if !(visitedSquares.contains(prospectFronterSquare)) {
                        squareAndParentSquare[prospectFronterSquare] = currentSquare

                        if !(fronterSquares.contains(prospectFronterSquare)) {
                            fronterSquares += [prospectFronterSquare]
                            newFornterSquareHolder.append(Tuple(x: prospectFronterSquare.x, y: prospectFronterSquare.y))
                            squareAndParentSquare[prospectFronterSquare] = currentSquare
                        }
                    }
                }
            }
            
            if fronterSquares.count != 0 {
                currentSquare = fronterSquares.last!
                fronterSquares.popLast()
            } else {
                return mazeAlgorithmHelperObject.mazeManager(squareAndParentSquare: squareAndParentSquare)
            }
        }
        return mazeAlgorithmHelperObject.mazeManager(squareAndParentSquare: squareAndParentSquare)
    }
}
