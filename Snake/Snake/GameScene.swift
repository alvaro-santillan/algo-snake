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
    var correctGameboardSquareColor = UIColor()
    var correctBackgroundColor = UIColor()
    let legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]

    override func didMove(to view: SKView) {
        game = GameManager(scene: self)
        darkModeChecker()
        initializeWelcomeScreen()
        initializeGameView()
        swipeManager(swipeGesturesAreOn: true)
    }
    
    func swipeManager(swipeGesturesAreOn: Bool) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        swipeUp.direction = .up
        swipeRight.direction = .right
        swipeLeft.direction = .left
        
        if swipeGesturesAreOn == true {
            view!.addGestureRecognizer(swipeRight)
            view!.addGestureRecognizer(swipeLeft)
            view!.addGestureRecognizer(swipeUp)
            view!.addGestureRecognizer(swipeDown)
        } else {
            view!.gestureRecognizers?.removeAll()
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
    
    func darkModeChecker() {
        let gameboardIDColor = legendData[8][1] as! Int // "Gameboard"
        
        if UserDefaults.standard.bool(forKey: "Dark Mode On Setting") {
            correctGameboardSquareColor = darkBackgroundColors[gameboardIDColor]
            correctBackgroundColor = UIColor.black
        } else {
            correctGameboardSquareColor = lightBackgroundColors[gameboardIDColor]
            correctBackgroundColor = UIColor.white
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !(UserDefaults.standard.bool(forKey: "Game Is Paused Setting")) {
            swipeManager(swipeGesturesAreOn: false)
            let barrierColor = legendData[6][1] as! Int // "Barrier Square"
            
            for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = self.nodes(at: location)
                for node in touchedNode {
                    if let nodee = node as? SKShapeNode {
                        if node.name != "gameBackground" {
                            let locationArray = (nodee.name)?.components(separatedBy: ",")
                            let nodeLocation = Tuple(x: Int(locationArray![0])!, y: Int(locationArray![1])!)
                            var tappedOnSnake = Bool()
                        
                            for i in snakeBodyPos {
                                if nodeLocation.x == i.0 && nodeLocation.y == i.1 {
                                    tappedOnSnake = true
                                    break
                                }
                            }
                            
                            
                            
                            let grow = SKAction.scale(by: 1.05, duration: 0.10)
                            let shrink = SKAction.scale(by: 0.95, duration: 0.10)
                            let wait = SKAction.wait(forDuration: 0.16)
                            let scale = SKAction.scale(to: 1.0, duration: 0.12)
                            let shrink2 = SKAction.scale(by: 0.97, duration: 0.05)
                            let wait2 = SKAction.wait(forDuration: 0.07)
                            
                            if tappedOnSnake != true {
                                if UserDefaults.standard.bool(forKey: "Add Barrier Mode On Setting") {
                                    game.matrix[nodeLocation.x][nodeLocation.y] = 1
                                    game.barrierNodesWaitingToBeDisplayed.append(nodeLocation)
                                    nodee.fillColor = colors[barrierColor]
                                    nodee.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                                } else {
                                    darkModeChecker()
                                    game.matrix[nodeLocation.x][nodeLocation.y] = 0
                                    game.barrierNodesWaitingToBeRemoved.append(nodeLocation)
                                    nodee.fillColor = correctGameboardSquareColor
                                    nodee.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !(UserDefaults.standard.bool(forKey: "Game Is Paused Setting")) {
            swipeManager(swipeGesturesAreOn: false)
                let barrierColor = legendData[6][1] as! Int // "Barrier Square"
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
                            if node.name != "gameBackground" {
                                let locationArray = (node.name)?.components(separatedBy: ",")
                                let nodeLocation = Tuple(x: Int(locationArray![0])!, y: Int(locationArray![1])!)
                                var tappedOnSnake = Bool()
                            
                                for i in snakeBodyPos {
                                    if nodeLocation.x == i.0 && nodeLocation.y == i.1 {
                                        tappedOnSnake = true
                                        break
                                    }
                                }
                                
                                for i in game.foodLocationArray {
                                    if nodeLocation.x == i[0] && nodeLocation.y == i[1] {
                                        tappedOnSnake = true
                                        break
                                    }
                                }
                                
                                if tappedOnSnake != true {
                                    if UserDefaults.standard.bool(forKey: "Add Barrier Mode On Setting") {
                                        game.barrierNodesWaitingToBeDisplayed.append(nodeLocation)
                                        game.matrix[nodeLocation.x][nodeLocation.y] = 1
                                        touchedNode.fillColor = colors[barrierColor]
                                        touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                                    } else {
                                        darkModeChecker()
                                        game.matrix[nodeLocation.x][nodeLocation.y] = 0
                                        game.barrierNodesWaitingToBeRemoved.append(nodeLocation)
                                        touchedNode.fillColor = correctGameboardSquareColor
                                        touchedNode.run(SKAction.sequence([grow, wait, shrink, wait, scale, shrink2, wait2, scale]))
                                    }
                                }
                            }
                        }
                    }
                }
            swipeManager(swipeGesturesAreOn: true)
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
        gameBackground.fillColor = correctBackgroundColor
        gameBackground.strokeColor = correctBackgroundColor
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
                
                cellNode.fillColor = correctGameboardSquareColor
                cellNode.strokeColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:0.00)
                cellNode.name = String(i) + "," + String(j)
                
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
