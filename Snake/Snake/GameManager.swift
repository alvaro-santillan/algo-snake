//
//  GameManager.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameManager {
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Double = 0.1
    var playerDirection: Int = 1 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var snakeIsAlive = true
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initiateSnakeStartingPos() {
        scene.snakeBodyPos.append((10, 10))
        scene.snakeBodyPos.append((10, 11))
        scene.snakeBodyPos.append((10, 12))
        scene.snakeBodyPos.append((10, 13))
        scene.snakeBodyPos.append((10, 14))
        scene.snakeBodyPos.append((10, 15))
        scene.snakeBodyPos.append((10, 16))
        scene.snakeBodyPos.append((10, 17))
        scene.snakeBodyPos.append((10, 18))
        scene.snakeBodyPos.append((10, 19))
        scene.snakeBodyPos.append((10, 20))
        scene.snakeBodyPos.append((10, 21))
        scene.snakeBodyPos.append((10, 22))
        scene.snakeBodyPos.append((10, 23))
        spawnFoodBlock()
    }
    
    func spawnFoodBlock() {
        let randomX = CGFloat(arc4random_uniform(41))
        let randomY = CGFloat(arc4random_uniform(73))
        scene.foodPosition = CGPoint(x: randomX, y: randomY)
    }
    
    func swipe(ID: Int) {
        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                playerDirection = ID
            }
        }
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + gameSpeed
        } else {
            if time >= nextTime! {
                nextTime = time + gameSpeed
                updateSnakePosition()
                checkForScore()
                checkForDeath()
                endTheGame()
            }
        }
    }
    
    private func endTheGame() {
        if snakeIsAlive == false {
            updateScore()
            scene.foodPosition = nil
            scene.snakeBodyPos.removeAll()
            colorGameNodes()

            scene.gameBackground.run(SKAction.scale(to: 0, duration: 0.4)) {
                self.scene.gameBackground.isHidden = true
                self.scene.gameLogo.isHidden = false
                self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
                     self.scene.playButton.isHidden = false
                     self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
                     self.scene.bestScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
                   }
              }
         }
    }
    
    private func checkForDeath() {
        if scene.snakeBodyPos.count > 0 {
            // Create temp variable of snake without the head.
            var snakeBody = scene.snakeBodyPos
            snakeBody.remove(at: 0)
            // If head is in same position as the body the snake is dead.
            // The snake dies in corners becouse blocks are stacked.
            if contains(a: snakeBody, v: scene.snakeBodyPos[0]) {
                snakeIsAlive = false
            }
        }
    }
    
    private func checkForScore() {
        if scene.foodPosition != nil {
            let x = scene.snakeBodyPos[0].0
            let y = scene.snakeBodyPos[0].1
            print("billy bo billy", scene.foodPosition, scene.snakeBodyPos[0])
            if Int((scene.foodPosition?.x)!) == y && Int((scene.foodPosition?.y)!) == x {
                currentScore += 1
                scene.gameScore.text = "Score: \(currentScore)"
                spawnFoodBlock()
                //Grow snake by 3 blocks
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
             }
         }
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
        if scene.snakeBodyPos.count > 0 {
            var start = scene.snakeBodyPos.count - 1
            while start > 0 {
                scene.snakeBodyPos[start] = scene.snakeBodyPos[start - 1]
                start -= 1
            }
            scene.snakeBodyPos[0] = (scene.snakeBodyPos[0].0 + yChange, scene.snakeBodyPos[0].1 + xChange)
        }
        
        // Wrap snake around screen
        if scene.snakeBodyPos.count > 0 {
            let x = scene.snakeBodyPos[0].1
            let y = scene.snakeBodyPos[0].0
            
            if y > 73 {
                scene.snakeBodyPos[0].0 = 73
            } else if y < 0 {
                scene.snakeBodyPos[0].0 = 0
            } else if x > 41 {
               scene.snakeBodyPos[0].1 = 41
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

    private func updateScore() {
        // Update the high score if need be.
         if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
              UserDefaults.standard.set(currentScore, forKey: "bestScore")
         }
         currentScore = 0
         scene.gameScore.text = "Score: 0"
         scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
}
