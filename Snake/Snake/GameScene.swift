//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//
//  Knwon Bugs
//  Extra valid row on the bottom of the screen.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Home screen var`s to store objects
    var gameLogo: SKLabelNode!
    var highScore: SKLabelNode!
    var playButton: SKShapeNode!
    var playButtonTapped = false
    var foodPosition: CGPoint?
    
    var carry: GameViewController!
    
    
    
    // Used to store data and managing user movement.
    var game: GameManager!
    
    // Used for storing keystone game information.
    var snakeBodyPos: [(Int, Int)] = []
    var snakeHeadPos: [(Int, Int)] = []
    var algoithimChoice: Int = 0
    var gameScore: SKLabelNode!
    var gameBackground: SKShapeNode!
    var gameBoard: [(node: SKShapeNode, x: Int, y: Int)] = []
    

    
    // Spritekit vesrion of didLoad() ie gameScene has loaded.
    override func didMove(to view: SKView) {
        initializeWelcomeScreen()
        // Used to store data and managing user movement.
        game = GameManager(scene: self)
        initializeGameView()
        
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
    
    // Welcome menu objects defined
    private func initializeWelcomeScreen() {
//        algoithimChoice = carry.selectDFS
        
        // Define game title
//        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
//        gameLogo.zPosition = 1
//        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
//        gameLogo.fontSize = 60
//        gameLogo.text = "SNAKE"
//        gameLogo.fontColor = SKColor.white
        // Add to the game scene
//        self.addChild(gameLogo)
        
        // Define best score label
        highScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        highScore.zPosition = 1
//        highScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        highScore.fontSize = 40
        highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        highScore.fontColor = SKColor.white
        // Add to the game scene
        self.addChild(highScore)
        
        // Define play button
//        playButton = SKShapeNode()
//        playButton.name = "play_button"
//        playButton.zPosition = 1
//        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
//        playButton.fillColor = SKColor.white
//
//        // SKShapeNodes for this project due to their simplicity, this is an alternative to creating your graphics in an image editor. This line of code creates a path in the shape of a triangle.
//        // Please note if you plan on building and publishing an app you should use SKSpriteNodes to load an image you have created, ShapeNodes can cause performance issues when used in large quantities as they are dynamically drawn once per frame.
//        let topCorner = CGPoint(x: -50, y: 50)
//        let bottomCorner = CGPoint(x: -50, y: -50)
//        let middle = CGPoint(x: 50, y: 0)
//        let path = CGMutablePath()
//        path.addLine(to: topCorner)
//        path.addLines(between: [topCorner, bottomCorner, middle])
//
//        // Set the triangular path we created to the playButton sprite and add to the GameScene.
//        playButton.path = path
//        self.addChild(playButton)
        startGame()
    }
    
    private func initializeGameView() {
        // Initialize current game score label.
        gameScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameScore.zPosition = 2
        gameScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        gameScore.fontSize = 40
        gameScore.isHidden = true
        gameScore.text = "Score: 0"
        gameScore.fontColor = SKColor.white
        self.addChild(gameScore)
        
        // Create ShapeNode in which the gameboard can reside.
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.0)
        gameBackground.isHidden = true
        self.addChild(gameBackground)
        
        // Create the game board.
        createGameBoard()
    }
    
    var matrix = [[Int]]()
    var row = [Int]()
    // Create a game board, initialize array of cells.
    private func createGameBoard() {
        let width = frame.size.width
        let height = frame.size.height
        
        // Size of square
        let cellWidth: CGFloat = 10
//        let numRows = 41
//        let numCols = 73
        let numRows = 15
        let numCols = 15
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        
        // Loop through rows and columns and create cells.
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.darkGray
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
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
        // Print Results

        game.bringOvermatrix(tempMatrix: matrix)
    }
    
    // Called when the play button is tapped.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        startGame()
//        if playButtonTapped == false {
//            startGame()
//            playButtonTapped = true
//        }
    }
    
    // Start the game
    private func startGame() {
        // Move the game logo off the screen.
//        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
//            self.gameLogo.isHidden = true
//        }

        // Shrink and hide button
//        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
//            self.playButton.isHidden = true
//        }

        // Move best score label to the bottom of the screen.
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBackground.isHidden = false
            self.gameScore.isHidden = false
            self.game.initiateSnakeStartingPosition()
        }
    }
    
    
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
    
    
}
