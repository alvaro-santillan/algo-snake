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
    // Home screen var`s to store objects
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var playButtonTapped = false
    var scorePos: CGPoint?
    
    // Used to store data and managing user movement.
    var game: GameManager!
    
    // Used for storing keystone game information.
    var snakeBodyPos: [(Int, Int)] = []
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
        // Define game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKE"
        gameLogo.fontColor = SKColor.red
        // Add to the game scene
        self.addChild(gameLogo)
        
        // Define best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.white
        // Add to the game scene
        self.addChild(bestScore)
        
        // Define play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan

        // SKShapeNodes for this project due to their simplicity, this is an alternative to creating your graphics in an image editor. This line of code creates a path in the shape of a triangle.
        // Please note if you plan on building and publishing an app you should use SKSpriteNodes to load an image you have created, ShapeNodes can cause performance issues when used in large quantities as they are dynamically drawn once per frame.
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])

        // Set the triangular path we created to the playButton sprite and add to the GameScene.
        playButton.path = path
        self.addChild(playButton)
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
        
        // Create ShapeNode in wich the gameboard can reside.
        let width = frame.size.width - 0
        let height = frame.size.height - 0
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBackground.fillColor = SKColor.darkGray
        gameBackground.zPosition = 1
        gameBackground.isHidden = true
        self.addChild(gameBackground)
        
        // Create the game board.
        createGameBoard(width: Int(width), height: Int(height))
    }
    
    //create a game board, initialize array of cells
    private func createGameBoard(width: Int, height: Int) {
        let screenWidth = UIScreen.main.nativeBounds.width
        _ = UIScreen.main.nativeBounds.height
        print("billy-bo-billy", screenWidth)
        
        // Size of square
        let cellWidth: CGFloat = 27.5
        let numRows = 40
        let numCols = 20
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameBoard.append((node: cellNode, x: i, y: j))
                gameBackground.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    
    // Called when the play button is tapped.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playButtonTapped == false {
            startGame()
            playButtonTapped = true
        }
    }
    
    // Start the game
    private func startGame() {
        // Move the game logo off the screen.
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
        }

        // Shrink and hide button
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }

        // Move best score label to the bottom of the screen.
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
//            self.gameBackground.setScale(0)
//            self.gameScore.setScale(0)
            self.gameBackground.isHidden = false
            self.gameScore.isHidden = false
//            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.4))
//            self.gameScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
}
