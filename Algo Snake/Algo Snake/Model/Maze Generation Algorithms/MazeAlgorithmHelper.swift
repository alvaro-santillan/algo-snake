//
//  MazeAlgorithmHelper.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/12/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

class MazeAlgorithmHelper {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func mazeManager(squareAndParentSquare: [Tuple : Tuple]) -> [Tuple : [Tuple]] {
        let resizedSquareAndParentSquare = growMatrix(squareAndParentSquare: squareAndParentSquare)
        let parentSquareAndChildren = addMissingChildrenSquares(newSquareAndParentSquare: resizedSquareAndParentSquare)
        return parentSquareAndChildren
    }
    
    // Grows path in both directions.
    func growMatrix(squareAndParentSquare: [Tuple : Tuple]) -> [Tuple : Tuple] {
        var newSquareAndParentSquare = [Tuple : Tuple]()
        
        for i in squareAndParentSquare {
            if i.key.x != 0 && i.key.y != 0  {
                if i.value.x != 0 && i.value.y != 0  {
                    let newChildX = i.key.x + (i.key.x - 1)
                    let newChildY = i.key.y + (i.key.y - 1)
                    let newParentX = i.value.x + (i.value.x - 1)
                    let newParentY = i.value.y + (i.value.y - 1)
                    
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
}
