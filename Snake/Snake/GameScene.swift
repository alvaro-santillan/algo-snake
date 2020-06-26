//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var game: GameManager!
    var algorithimChoiceName: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var foodPosition = [CGPoint]()
    var gameBackground: SKShapeNode!
    var gameBoard: [(node: SKShapeNode, x: Int, y: Int)] = []
    let rowCount = 17 // 17
    let columnCount = 30 // 30
    
    var snakeHeadSquareColor = UIColor() // "Snake Head"
    var snakeBodySquareColor = UIColor() // "Snake Body"
    var foodSquareColor = UIColor() // "Food"
    var pathSquareColor = UIColor() // "Path"
    var visitedSquareColor = UIColor() // "Visited Square"
    var queuedSquareColor = UIColor() // "Queued Square"
    var barrierSquareColor = UIColor() // "Barrier"
    var weightSquareColor = UIColor() // "Weight"
    var gameboardSquareColor = UIColor() // "Gameboard"
    var gameboardBackgroundColor = UIColor() // Background

    override func didMove(to view: SKView) {
        game = GameManager(scene: self)
        settingLoader(firstRun: true)
        createScreenLabels()
        createGameBoard()
        swipeManager(swipeGesturesAreOn: true)
        startGame()
    }
    
    func settingLoader(firstRun: Bool) {
        let legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
        var correctColorArray = [UIColor]()
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") ? (correctColorArray = darkBackgroundColors) : (correctColorArray = lightBackgroundColors)
        
        snakeHeadSquareColor = colors[legendData[0][1] as! Int] // "Snake Head"
        snakeBodySquareColor = colors[legendData[1][1] as! Int] // "Snake Body"
        foodSquareColor = colors[legendData[2][1] as! Int] // "Food"
        pathSquareColor = colors[legendData[3][1] as! Int] // "Path"
        visitedSquareColor = colors[legendData[4][1] as! Int] // "Visited Square"
        queuedSquareColor = colors[legendData[5][1] as! Int] // "Queued Square"
        barrierSquareColor = colors[legendData[6][1] as! Int] // "Barrier"
        weightSquareColor = colors[legendData[7][1] as! Int] // "Weight"
        gameboardSquareColor = correctColorArray[legendData[8][1] as! Int] // "Gameboard"
        gameboardBackgroundColor = UIColor(named: "Left View Background")!
        UserDefaults.standard.set(false, forKey: "Settings Value Modified")
        
        if !(firstRun) {
            if UserDefaults.standard.bool(forKey: "Clear All Setting") {
                game.barrierNodesWaitingToBeDisplayed.removeAll()
                game.barrierNodesWaitingToBeRemoved.removeAll()
                // clear path
                // clear visited
                // clear queued
                UserDefaults.standard.set(false, forKey: "Clear All Setting")
            } else {
                if UserDefaults.standard.bool(forKey: "Clear Barrier Setting") {
                    game.barrierNodesWaitingToBeDisplayed.removeAll()
                    game.barrierNodesWaitingToBeRemoved.removeAll()
                    UserDefaults.standard.set(false, forKey: "Clear Barrier Setting")
                }
                
                if UserDefaults.standard.bool(forKey: "Clear Path Setting") {
                    // Path
                    UserDefaults.standard.set(false, forKey: "Clear Path Setting")
                }
            }
        }
    }
    
    private func createScreenLabels() {
        let pathFindingAlgorithimName = UserDefaults.standard.string(forKey: "Selected Path Finding Algorithim Name")
        let mazeGenerationAlgorithimName = UserDefaults.standard.string(forKey: "Selected Maze Algorithim Name")
        
        algorithimChoiceName = SKLabelNode(fontNamed: "Dogica_Pixel")
        algorithimChoiceName.text = "Path: \(pathFindingAlgorithimName ?? "Player"), Maze: \(mazeGenerationAlgorithimName ?? "None")"
        algorithimChoiceName.fontColor = UIColor(named: "Text")
        algorithimChoiceName.fontSize = 11
        algorithimChoiceName.horizontalAlignmentMode = .center
        algorithimChoiceName.position = CGPoint(x: 0, y: 185)
        algorithimChoiceName.zPosition = 1
        self.addChild(algorithimChoiceName)
    }
    
    private func createGameBoard() {
        func createBackground() {
            let screenSizeRectangle = CGRect(x: 0-frame.size.width/2, y: 0-frame.size.height/2, width: frame.size.width, height: frame.size.height)
            gameBackground = SKShapeNode(rect: screenSizeRectangle, cornerRadius: 0)
            gameBackground.fillColor = gameboardBackgroundColor
            gameBackground.strokeColor = gameboardBackgroundColor
            gameBackground.name = "gameBackground"
            self.addChild(gameBackground)
        }
        
        var matrix = [[Int]]()
        var row = [Int]()
        let squareWidth: CGFloat = 25
        let shrinkRatio: CGFloat = 0.06
        let cornerRatio: CGFloat = 0.14
        let shrinkedSquareWidth = squareWidth - (squareWidth * shrinkRatio)
        let shrinkedSquareCornerRadius = squareWidth * cornerRatio
        var x = CGFloat(0 - (Int(squareWidth) * columnCount)/2)
        var y = CGFloat(0 + (Int(squareWidth) * rowCount)/2)
        x = CGFloat(x + (squareWidth/2))
        y = CGFloat(y - (squareWidth/2))
        
        createBackground()
        
        // i = x and j = y confirmed
        for i in 0...rowCount - 1 {
            for j in 0...columnCount - 1 {
                let square = SKShapeNode.init(rectOf: CGSize(width: shrinkedSquareWidth, height: shrinkedSquareWidth), cornerRadius: shrinkedSquareCornerRadius)
                
                square.name = String(i) + "," + String(j)
                square.position = CGPoint(x: x, y: y)
                square.fillColor = gameboardSquareColor
                square.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
                gameBoard.append((node: square, x: i, y: j))
                gameBackground.addChild(square)
                
                // Temp removal
//                if i == 0 || i == (rowCount - 1) {
//                    row.append(9)
//                } else if j == 0 || j == (columnCount - 1) {
//                    row.append(9)
//                } else {
                    row.append(0)
//                }
                
                x += squareWidth
            }
            matrix.append(row)
            row = [Int]()
            // reset x, iterate y
            x = CGFloat(x - CGFloat(Int(squareWidth) * columnCount))
            y -= squareWidth
        }
        game.bringOvermatrix(tempMatrix: matrix)
        animateTheGameboard()
    }
    
    func animateTheGameboard() {
        func animateNodes(_ nodes: [SKShapeNode]) {
            var squareWait = SKAction()
            for (squareIndex, square) in nodes.enumerated() {
                square.run(.sequence([squareWait, gameSquareAnimation(animation: 1)]))
                squareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.003)
            }
        }
        
        var squares = [SKShapeNode]()
        for i in gameBoard {
            squares.append(i.node)
        }
        // Temp removal
//        animateNodes(squares)
    }
    
    var hit = false
    func animateThePath(pathBlocks: [(Int, Int)]) {
        
        func animateNodes(_ nodes: [SKShapeNode]) {
            var squareWait = SKAction()
            for (squareIndex, square) in nodes.enumerated() {
                
                square.run(.sequence([squareWait, gameSquareAnimation(animation: 2)]))
                squareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.03)
                square.fillColor = pathSquareColor
            }
        }
        
        var squares = [SKShapeNode]()
//        print(pathBlocks)
        if game.newPath == true {
            for i in pathBlocks {
                if let ttt = gameBoard.first(where: {$0.x == i.1 && $0.y == i.0})?.node {
                    squares.append(ttt)
                } else {
                    print("Error not found")
                    print(i)
                }
            }
            animateNodes(squares)
            game.newPath = false
        }
    }
    
    func gameSquareAnimation(animation: Int) -> SKAction {
        let wait0 = SKAction.wait(forDuration: 0.80)
        let wait1 = SKAction.wait(forDuration: 0.16)
        let wait2 = SKAction.wait(forDuration: 0.07)
        let grow1 = SKAction.scale(by: 1.05, duration: 0.10)
        let scale1 = SKAction.scale(to: 1.0, duration: 0.12)
        let shrink1 = SKAction.scale(by: 0.90, duration: 0.10)
        let shrink2 = SKAction.scale(by: 0.95, duration: 0.05)
        let shrink3 = SKAction.scale(by: 0.95, duration: 0.10)
        let shrink4 = SKAction.scale(by: 0.97, duration: 0.05)

        if animation == 1 {
            return SKAction.sequence([wait0, grow1, wait1, shrink1, wait1, scale1, shrink2, wait2, scale1])
        } else {
            return SKAction.sequence([grow1, wait1, shrink3, wait1, scale1, shrink4, wait2, scale1])
        }
    }
    
    func swipeManager(swipeGesturesAreOn: Bool) {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        
        if swipeGesturesAreOn {
            view!.addGestureRecognizer(swipeUp)
            view!.addGestureRecognizer(swipeRight)
            view!.addGestureRecognizer(swipeDown)
            view!.addGestureRecognizer(swipeLeft)
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
    
    private func startGame() {
        let topCenter = CGPoint(x: 0, y: (frame.size.height / 2) - 25)
        algorithimChoiceName.run(SKAction.move(to: topCenter, duration: 0.4)) {
            self.game.initiateSnakeStartingPosition()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            swipeManager(swipeGesturesAreOn: false)
            barrierManager(touches: touches)
            swipeManager(swipeGesturesAreOn: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            swipeManager(swipeGesturesAreOn: false)
            barrierManager(touches: touches)
            swipeManager(swipeGesturesAreOn: true)
        }
    }
    
    func barrierManager(touches: Set<UITouch>) {
        func selectSquareFromTouch(_ touchLocation: CGPoint) -> SKShapeNode? {
            let squares = self.nodes(at: touchLocation)
            for square in squares {
                if square is SKShapeNode {
                    if square.name != "gameBackground" {
                        return (square as! SKShapeNode)
                    }
                }
            }
            return nil
        }
        
        func IsSquareOccupied(squareLocation: Tuple) -> Bool {
            for square in game.snakeBodyPos {if squareLocation.x == square.x && squareLocation.y == square.y {return true}}
            for square in game.foodLocationArray {if squareLocation.x == square[0] && squareLocation.y == square[1] {return true}}
            for square in game.pathBlockCordinates {if squareLocation.x == square.1 && squareLocation.y == square.0 {return true}}
            return false
        }
        
        for touch in touches {
            if let selectedSquare = selectSquareFromTouch(touch.location(in: self)) {
                let squareLocationAsString = (selectedSquare.name)?.components(separatedBy: ",")
                let squareLocation = Tuple(x: Int(squareLocationAsString![0])!, y: Int(squareLocationAsString![1])!)
                
                // temparary removal
//                if squareLocation.x != 0 && squareLocation.x != (rowCount - 1) {
//                    if squareLocation.y != 0 && squareLocation.y != (columnCount - 1) {
                        if !(IsSquareOccupied(squareLocation: squareLocation)) {
                            if UserDefaults.standard.bool(forKey: "Add Barrier Mode On Setting") {
                                game.barrierNodesWaitingToBeDisplayed.append(squareLocation)
                                selectedSquare.fillColor = barrierSquareColor
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                game.matrix[squareLocation.x][squareLocation.y] = 7
                            } else {
                                game.barrierNodesWaitingToBeRemoved.append(squareLocation)
                                selectedSquare.fillColor = gameboardSquareColor
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                game.matrix[squareLocation.x][squareLocation.y] = 0
                            }
                        }
//                    }
//                }
                selectedSquare.run(gameSquareAnimation(animation: 2))
            }
        }
    }
    
    // Called before each frame is rendered
    // perhapse this can be used to pass in settings? maybe
    override func update(_ currentTime: TimeInterval) {
        UserDefaults.standard.bool(forKey: "Settings Value Modified") ? (settingLoader(firstRun: false)) : ()
        game.viewControllerComunicationsManager(updatingPlayButton: false)
        
        if game!.fronteerSquareArray.count > 0 {
            let wait = SKAction.wait(forDuration: 0.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.fronteerSquareArray[0]
                node.run(sequance)
                node.fillColor = queuedSquareColor
                node.run(SKAction.wait(forDuration: 1.0))
                game!.fronteerSquareArray.remove(at: 0)
        }
        
        if game!.visitedNodeArray.count > 0{
            let wait = SKAction.wait(forDuration: 1.0)
            let sequance = SKAction.sequence([wait])
                let node = game!.visitedNodeArray[0]
                node.run(sequance)
                node.fillColor = visitedSquareColor
                game!.visitedNodeArray.remove(at: 0)
        }
        game.update(time: currentTime)
    }
}
