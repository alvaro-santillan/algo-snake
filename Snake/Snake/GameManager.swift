//
//  GameManager.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//  Bug Seg-fault when reach gameboard end.

import SpriteKit

class GameManager {
    var gameStarted = false
    var matrix = [[Int]]()
    var test = [4]
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Double = 0.7
    var playerDirection: Int = 1 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    // Understood - Initiate the starting position of the snake.
    func initiateSnakeStartingPosition() {
        scene.snakeBodyPos.append((3, 3))
        matrix[3][3] = 1
        scene.snakeBodyPos.append((3, 4))
        matrix[3][4] = 1
        scene.snakeBodyPos.append((3, 5))
        matrix[3][5] = 1
//        scene.snakeBodyPos.append((10, 13))
//        scene.snakeBodyPos.append((10, 14))
//        scene.snakeBodyPos.append((10, 15))
//        scene.snakeBodyPos.append((10, 16))
//        scene.snakeBodyPos.append((10, 17))
//        scene.snakeBodyPos.append((10, 18))
//        scene.snakeBodyPos.append((10, 19))
//        scene.snakeBodyPos.append((10, 20))
//        scene.snakeBodyPos.append((10, 21))
//        scene.snakeBodyPos.append((10, 22))
//        scene.snakeBodyPos.append((10, 23))
        spawnFoodBlock()
        gameStarted = true
    }
    
    // Understood - Spawn a new food block into the game.
    var prevX = 0
    var prevY = 0
    func spawnFoodBlock() {
        print("spawning food")
        let randomX = CGFloat(arc4random_uniform(15)) //73
        let randomY = CGFloat(arc4random_uniform(15)) //41
        matrix[Int(randomY)][Int(randomX)] = 1
        matrix[prevX][prevY] = 0
        prevX = Int(randomY)
        prevY = Int(randomX)
//        for i in 0...14 {
//            print(matrix[i])
//        }
        scene.foodPosition = CGPoint(x: randomX, y: randomY)
    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
    func runPredeterminedPath() {
        if gameStarted == true {
            if (test.count != 0) {
//                print("-----sdfg", test.count, test[0])
                swipe(ID: test[0])
                test.remove(at: 0)
            }
        }
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + gameSpeed
        } else {
            if time >= nextTime! {
                nextTime = time + gameSpeed
                runPredeterminedPath()
                updateSnakePosition()
                checkForFoodCollision()
                checkForDeath()
            }
        }
    }
    
    func endTheGame() {
        updateScore()
        scene.foodPosition = nil
        scene.snakeBodyPos.removeAll()

        // Ending Animation
        scene.gameBackground.run(SKAction.scale(to: 0, duration: 0.4)) {
            self.scene.gameBackground.isHidden = true
            self.scene.gameLogo.isHidden = false
            self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
                 self.scene.gameScore.isHidden = true
                 self.scene.playButton.isHidden = false
                 self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
                 self.scene.highScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
               }
          }

    }
    
    // this is run when game hasent started. fix for optimization.
    func checkForDeath() {
//        print("checked---------")
        if scene.snakeBodyPos.count > 0 {
            // Create temp variable of snake without the head.
            var snakeBody = scene.snakeBodyPos
            snakeBody.remove(at: 0)
            // If head is in same position as the body the snake is dead.
            // The snake dies in corners becouse blocks are stacked.
            if contains(a: snakeBody, v: scene.snakeBodyPos[0]) {
                endTheGame()
            }
        }
    }
    
    func checkForFoodCollision() {
        if scene.foodPosition != nil {
            let x = scene.snakeBodyPos[0].0
            let y = scene.snakeBodyPos[0].1
            if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                spawnFoodBlock()
                // Update the score
                currentScore += 1
                scene.gameScore.text = "Score: \(currentScore)"
                // Grow snake by 3 blocks.
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
//                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
//                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
             }
         }
    }
    
    func swipe(ID: Int) {
        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                playerDirection = ID
            }
        }
    }
    
    
    func updateSnakePosition() {
        var xChange = 0
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
        if scene.snakeBodyPos.count > 0 {
            
            var start = scene.snakeBodyPos.count - 1
            matrix[scene.snakeBodyPos[start].0][scene.snakeBodyPos[start].1] = 0
            while start > 0 {
                scene.snakeBodyPos[start] = scene.snakeBodyPos[start - 1]
//                print(scene.snakeBodyPos[start])
//                print(scene.snakeBodyPos)
                start -= 1
            }
//            print("---")
            scene.snakeBodyPos[0] = (scene.snakeBodyPos[0].0 + yChange, scene.snakeBodyPos[0].1 + xChange)
//            print(scene.snakeBodyPos)
            
//            print(scene.snakeBodyPos[0])
//            print(scene.snakeBodyPos[1])
//            print(scene.snakeBodyPos[2])
            matrix[scene.snakeBodyPos[0].0][scene.snakeBodyPos[0].1] = 1
            matrix[scene.snakeBodyPos[1].0][scene.snakeBodyPos[1].1] = 1
            matrix[scene.snakeBodyPos[2].0][scene.snakeBodyPos[2].1] = 1
            for i in 0...14 {
                print(matrix[i])
            }
        }
        
        if scene.snakeBodyPos.count > 0 {
            let x = scene.snakeBodyPos[0].1
            let y = scene.snakeBodyPos[0].0
            
            if y > 15 { //41
                scene.snakeBodyPos[0].0 = 15 //41
            } else if y < 0 {
                scene.snakeBodyPos[0].0 = 0
            } else if x > 15 { //73
               scene.snakeBodyPos[0].1 = 15 //73
            } else if x < 0 {
                scene.snakeBodyPos[0].1 = 0
            }
        }
        colorGameNodes()
    }
    
    func colorGameNodes() {
        for (node, x, y) in scene.gameBoard {
            if contains(a: scene.snakeBodyPos, v: (x,y)) {
                node.fillColor = SKColor.white
            } else {
                node.fillColor = SKColor.clear
                if scene.foodPosition != nil {
                    if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                        node.fillColor = SKColor.white
                    }
                }
            }
        }
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }

    func updateScore() {
        // Update the high score if need be.
         if currentScore > UserDefaults.standard.integer(forKey: "highScore") {
              UserDefaults.standard.set(currentScore, forKey: "highScore")
         }
        
        // Reset and present score variables on game menu.
         currentScore = 0
         scene.highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
    }
}
