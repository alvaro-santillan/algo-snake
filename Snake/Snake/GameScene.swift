//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var highScore: SKLabelNode!
    var foodPosition = [CGPoint]()
    var gamePaused = true
    var addOrRemoveWall = false
    var snakeColor = UIColor()
    var game: GameManager!
    var snakeBodyPos: [(Int, Int)] = []
    var gameBackground: SKShapeNode!
    var gameBoard: [(node: SKShapeNode, x: Int, y: Int)] = []
    let legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]

    override func didMove(to view: SKView) {
        initializeWelcomeScreen()
        game = GameManager(scene: self)
        initializeGameView()
        
        if let gameInfo = self.userData?.value(forKey: "playOrNot") {
            gamePaused = gameInfo as! Bool
            snakeColor = gameInfo as! UIColor
        }
        
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
            
            let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
            
            let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
            swipeUp.direction = .up
            view.addGestureRecognizer(swipeUp)
            
            let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
            swipeDown.direction = .down
            view.addGestureRecognizer(swipeDown)
        }
    }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let barrierColor = legendData[6][1] as! Int // "Barrier Square"
        let gameboardSquareColor = legendData[8][1] as! Int // "Gameboard"
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if let nodee = node as? SKShapeNode {
                    if node.name == nil {
                        let grow = SKAction.scale(by: 1.05, duration: 0.10)
                        let shrink = SKAction.scale(by: 0.95, duration: 0.10)
                        let wait = SKAction.wait(forDuration: 0.16)
                        let scale = SKAction.scale(to: 1.0, duration: 0.12)
                        let shrink2 = SKAction.scale(by: 0.97, duration: 0.05)
                        let wait2 = SKAction.wait(forDuration: 0.07)
                        
                        if addOrRemoveWall == false {
                            nodee.fillColor = colors[barrierColor]
                            nodee.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                        } else {
                            nodee.fillColor = colors[gameboardSquareColor]
                            nodee.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let barrierColor = legendData[6][1] as! Int // "Barrier Square"
        let gameboardSquareColor = legendData[8][1] as! Int // "Gameboard"
        
        let grow = SKAction.scale(by: 1.05, duration: 0.10)
        let shrink = SKAction.scale(by: 0.95, duration: 0.10)
        let wait = SKAction.wait(forDuration: 0.16)
        let scale = SKAction.scale(to: 1.0, duration: 0.12)
        let shrink2 = SKAction.scale(by: 0.97, duration: 0.05)
        let wait2 = SKAction.wait(forDuration: 0.07)
        
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if let touchedNode = node as? SKShapeNode {
                if node.name == nil {
                        if addOrRemoveWall == false {
                            touchedNode.fillColor = colors[barrierColor]
                            touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                        } else {
                            touchedNode.fillColor = colors[gameboardSquareColor]
                            touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                        }
                    }
                }
            }
        }
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) -> SKShapeNode? {
        let nodes = self.nodes(at: touchLocation)
        for node in nodes {
            if node.name == nil {
                if node is SKShapeNode {
                    return (node as! SKShapeNode)
                }
            }
        }
        return nil
    }
    
    private func initializeWelcomeScreen() {
        // Define best score label
        highScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        self.addChild(highScore)
        startGame()
    }
    
    private func initializeGameView() {
        // Create ShapeNode in which the gameboard can reside.
        let rect = CGRect(x: 0-frame.size.width/2, y: 0-frame.size.height/2, width: frame.size.width, height: frame.size.height)
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.0)
        gameBackground.fillColor = UIColor.darkGray
        gameBackground.strokeColor = UIColor.darkGray
        self.addChild(gameBackground)
        createGameBoard()
    }
    
    var matrix = [[Int]]()
    var row = [Int]()
    // Create a game board, initialize array of cells.
    private func createGameBoard() {
        // Size of square
        let cellWidth: CGFloat = 25
        let numRows = 17
        let numCols = 30
        let xx = CGFloat(0 - (Int(cellWidth) * numCols)/2)
        let yy = CGFloat(0 + (Int(cellWidth) * numRows)/2)
        var x = CGFloat(xx + 12.5)
        var y = CGFloat(yy - 12.5)
        
        gameBackground.name = "gameBackground"
        // Loop through rows and columns and create cells.
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode.init(rectOf: CGSize(width: cellWidth-1.5, height: cellWidth-1.5), cornerRadius: 3.5)
                var backgroundColor = UIColor()
                let gameboardIDColor = legendData[8][1] as! Int // "Gameboard"
                
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    backgroundColor = darkBackgroundColors[gameboardIDColor]
                }
                else {
                    backgroundColor = lightBackgroundColors[gameboardIDColor]
                }
                
                cellNode.fillColor = backgroundColor
                cellNode.strokeColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:0.00)
                cellNode.position = CGPoint(x: x, y: y)
                row.append(0)
                // Add to array of cells then add it to the game board.
                gameBoard.append((node: cellNode, x: i, y: j))

                gameBackground.addChild(cellNode)
                x += cellWidth
            }
            matrix.append(row)
            row = [Int]()
            // reset x, iterate y
            x = CGFloat(x - CGFloat(Int(cellWidth) * numCols))
            y -= cellWidth
        }
        game.bringOvermatrix(tempMatrix: matrix)
    }
    
    private func startGame() {
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.game.initiateSnakeStartingPosition()
        }
    }
    
    // Called before each frame is rendered
    // perhapse this can be used to pass in settings? maybe
    override func update(_ currentTime: TimeInterval) {
        if game!.fronteerSquareArray.count > 0{
            let wait = SKAction.wait(forDuration: 0.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.fronteerSquareArray[0]
                node.run(sequance)
            
                let queuedSquareColor = legendData[5][1] as! Int // "Queued Square"
                node.fillColor = colors[queuedSquareColor]
            
                node.run(SKAction.wait(forDuration: 1.0))
                game!.fronteerSquareArray.remove(at: 0)
        }
        
        if game!.visitedNodeArray.count > 0{
            let wait = SKAction.wait(forDuration: 1.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.visitedNodeArray[0]
                node.run(sequance)
            
                let visitedSquareColor = legendData[4][1] as! Int // "Visited Square"
                node.fillColor = colors[visitedSquareColor]
            
                game!.visitedNodeArray.remove(at: 0)
        }
        game.update(time: currentTime)
    }
}
