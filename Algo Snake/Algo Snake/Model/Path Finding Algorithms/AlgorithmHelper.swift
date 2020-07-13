//
//  AlgorithmHelper.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

class AlgorithmHelper {
    weak var scene: GameScene!
    var movePath = [Int]()
    var squareAndNoParentArrayPath = [(Tuple)]()
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    
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
        // temp change
//        let xMax = scene.columnCount
//        let yMax = scene.rowCount
        let xMax = gameBoardMatrix[0].count
        let yMax = gameBoardMatrix.count
//        let xMax = gameBoardMatrix.

        // Loop through every cell in the maze.
        for(y, matrixRow) in gameBoardMatrix.enumerated() {
            for(x, _) in matrixRow.enumerated() {
                // If in a square that is leagal, append valid moves to a dictionary.
                if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 3 || gameBoardMatrix[y][x] == 1) {
                    
                    (y + 1 >= yMax) ? (isYIndex = false) : (isYIndex = true)
                    (x + 1 >= xMax) ? (isXIndex = false) : (isXIndex = true)
                    (y - 1 < 0) ? (isYNegIndex = false) : (isYNegIndex = true)
                    (x - 1 < 0) ? (isXNefIndex = false) : (isXNefIndex = true)
                    
                    // Up
                    if isYNegIndex {
                        if (gameBoardMatrix[y-1][x] == 0 || gameBoardMatrix[y-1][x] == 3 || gameBoardMatrix[y-1][x] == 1) {
                            vaildMoves[Tuple(x: x, y: y-1)] = 1
                        }
                    }
                    // Right
                    if isXIndex {
                        if (gameBoardMatrix[y][x+1] == 0 || gameBoardMatrix[y][x+1] == 3 || gameBoardMatrix[y][x+1] == 1) {
                            // Floats so that we can have duplicates keys in dictinaries (Swift dictionary workaround).
                            vaildMoves[Tuple(x: x+1, y: y)] = 1.1
                        }
                    }
                    // Left
                    if isXNefIndex {
                        if (gameBoardMatrix[y][x-1] == 0 || gameBoardMatrix[y][x-1] == 3 || gameBoardMatrix[y][x-1] == 1) {
                            vaildMoves[Tuple(x: x-1, y: y)] = 1.2
                        }
                    }
                    // Down
                    if isYIndex {
                        if (gameBoardMatrix[y+1][x] == 0 || gameBoardMatrix[y+1][x] == 3 || gameBoardMatrix[y+1][x] == 1) {
                            vaildMoves[Tuple(x: x, y: y+1)] = 1.3
                            }
                        }
                    // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                    mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                    // Reset the inner dictionary templet.
                    vaildMoves = [Tuple : Float]()
                }
            }
        }
        return mazeDictionary
    }
    
    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([Int],[(Tuple)],[Tuple : Tuple]) {
        if (currentSquare == Tuple(x:-1, y:-1)) {
            return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
        } else {
            squareAndParentSquareTuplePath[currentSquare] = squareAndParentSquare[currentSquare]
            squareAndNoParentArrayPath.append(Tuple(x: currentSquare.x, y: currentSquare.y))
            
            // Crash fix Dijstras trys to pathfind to food that can be accesed.
            if (squareAndParentSquare[currentSquare] == nil) {
                return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
            }
            
            let xValue = currentSquare.x - squareAndParentSquare[currentSquare]!.x
            let yValue = currentSquare.y - squareAndParentSquare[currentSquare]!.y
            // 1 == left, 2 == up, 3 == right, 4 == down
            if (xValue == 0 && yValue == 1) {
                movePath.append(4)
            } else if (xValue == 0 && yValue == -1) {
                movePath.append(2)
            } else if (xValue == 1 && yValue == 0) {
                movePath.append(3)
            } else if (xValue == -1 && yValue == 0) {
                movePath.append(1)
            }
            findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: squareAndParentSquare[currentSquare]!)
        }
        return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
    }
    
    // Calculate the path cost of the path returned by the "findPath" function.
    func calculatePathCost(solutionPathDuple: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>]) -> Int {
        var cost = 0
        
        for square in solutionPathDuple.keys {
            cost += Int(gameBoard[square]![solutionPathDuple[square]!] ?? 0)
        }
        return(cost)
    }
    
    // Genarate a path and optional statistics from the results of BFS.
    func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Tuple)], Int, Int) {

        let (solutionPathMoves, solutionPathArray, solutionPathDuple) = findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: currentSquare)
        
        // Prepare and present the result returns.
        if returnPathCost {
            // Use the "path" method result to calculate a pathcost using the "pathcost" method.
            let solutionPathCost = calculatePathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
            
            if returnSquaresVisited {
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, visitedSquareCount)
            } else {
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, 0)
            }
        }
        else if !(returnPathCost) && returnSquaresVisited {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, visitedSquareCount)
        }
        else {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, 0)
        }
    }
}
