//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    // Game construction
    let defaults = UserDefaults.standard
    weak var viewController: GameScreenViewController!
    var game: GameManager!
    var algorithimChoiceName: SKLabelNode!
    var gameBackground: SKShapeNode!
    var gameBoard: [SkNodeAndLocation] = []
    var rowCount = 7 // 7.5 Temp gets updated when the gameboard gets created.
    var columnCount = 14 // 14 Temp gets updated when the gameboard gets created.
    let pathFindingAlgorithimChoice = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    let mazeGeneratingAlgorithimChoice = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    
    // Game settings
    var pathFindingAnimationSpeed = Float()
    var settingsWereChanged = Bool()
    var clearAllWasTapped = Bool()
    var clearBarriersWasTapped = Bool()
    var clearPathWasTapped = Bool()
    
    var snakeHeadSquareColor = UIColor()
    var snakeBodySquareColor = UIColor()
    var foodSquareColor = UIColor()
    var pathSquareColor = UIColor()
    var visitedSquareColor = UIColor()
    var queuedSquareColor = UIColor()
    var barrierSquareColor = UIColor()
    var weightSquareColor = UIColor()
    var gameboardSquareColor = UIColor()
    var fadedGameBoardSquareColor = UIColor()
    var gameBackgroundColor = UIColor()
    var screenLabelColor = UIColor()
    var scoreButtonColor = UIColor()

    override func didMove(to view: SKView) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
        
        game = GameManager(scene: self)
        // Disable buttons for initial animation.
        animationDualButtonManager(buttonsEnabled: false)
        settingLoader(firstRun: true)
        createScreenLabels()
        createGameBoard()
        swipeManager(swipeGesturesAreOn: true)
        startTheGame()
    }
    
    func settingLoader(firstRun: Bool) {
        settingsWereChanged = true
        
        // Retrive legend preferences
        let legendData = defaults.array(forKey: "Legend Preferences") as! [[Any]]
        
        // Update pathfinding animation speed
        pathFindingAnimationSpeed = (defaults.float(forKey: "Snake Move Speed") * 0.14)
        
        // Update square colors, seen by the user in the next frame update.
        snakeHeadSquareColor = colors[legendData[0][1] as! Int]
        snakeBodySquareColor = colors[legendData[1][1] as! Int]
        foodSquareColor = colors[legendData[2][1] as! Int]
        pathSquareColor = colors[legendData[3][1] as! Int]
        visitedSquareColor = colors[legendData[4][1] as! Int]
        queuedSquareColor = colors[legendData[5][1] as! Int]
        barrierSquareColor = colors[legendData[6][1] as! Int]
        weightSquareColor = colors[legendData[7][1] as! Int]
        
        if defaults.bool(forKey: "Dark Mode On Setting") {
            gameboardSquareColor = darkBackgroundColors[legendData[8][1] as! Int]
            fadedGameBoardSquareColor = darkBackgroundColors[legendData[8][1] as! Int].withAlphaComponent(0.5)
            gameBackgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
            screenLabelColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
            scoreButtonColor = UIColor(red: 0.25, green: 0.25, blue: 0.27, alpha: 1.00)
        } else {
            gameboardSquareColor = lightBackgroundColors[legendData[8][1] as! Int]
            fadedGameBoardSquareColor = lightBackgroundColors[legendData[8][1] as! Int].withAlphaComponent(0.5)
            gameBackgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
            screenLabelColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
            scoreButtonColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        }
        
        if firstRun {
            // Populate score button text on first run.
            updateScoreButtonText()
        } else {
            // Update stored UI colors.
            gameBackground!.fillColor = gameBackgroundColor
            gameBackground!.strokeColor = gameBackgroundColor
            algorithimChoiceName.fontColor = screenLabelColor
//            self.viewController?.scoreButton.layer.borderColor = scoreButtonColor.withAlphaComponent(0.8).cgColor
//            self.viewController?.scoreButton.layer.backgroundColor = scoreButtonColor.withAlphaComponent(0.5).cgColor
            
            // Check and respond to clear button interactions.
            clearButtonManager()
        }
        // Render the changed square color live.
        settingsChangeSquareColorManager()
        defaults.set(false, forKey: "Settings Value Modified")
    }
    
    // Effects happen in real time.
    func clearButtonManager() {
        if defaults.bool(forKey: "Clear All Setting") {
            // Visually convert each square back to a gameboard square.
            for i in (game.displayFronteerSquareArray) {
                for j in i {
                    j.square.fillColor = gameboardSquareColor
                    game.matrix[j.location.x][j.location.y] = 0
                }
            }
            
            // Prevent barriers from respawning.
            game.barrierNodesWaitingToBeDisplayed.removeAll()
            game.barrierNodesWaitingToBeRemoved.removeAll()
            clearAllWasTapped = true
            defaults.set(false, forKey: "Clear All Setting")
            
        } else if (defaults.bool(forKey: "Clear Barrier Setting")) {
            // Visually convert each square back to a gameboard square.
            for i in (game.barrierNodesWaitingToBeDisplayed) {
                i.square.fillColor = gameboardSquareColor
                game.matrix[i.location.x][i.location.y] = 0
            }
            
            // Prevent barriers from respawning.
            game.barrierNodesWaitingToBeDisplayed.removeAll()
            game.barrierNodesWaitingToBeRemoved.removeAll()
            clearBarriersWasTapped = true
            defaults.set(false, forKey: "Clear Barrier Setting")
            
        } else if (defaults.bool(forKey: "Clear Path Setting")) {
            // Visually convert each square back to a gameboard square.
            for i in (game.displayPathSquareArray) {
                i.square.fillColor = gameboardSquareColor
                game.matrix[i.location.x][i.location.y] = 0
            }
            clearPathWasTapped = true
            defaults.set(false, forKey: "Clear Path Setting")
        }
    }
    
    // Contains duplicate functions.
    func settingsChangeSquareColorManager() {
        
        func colorQueued() {
            for i in (game.displayFronteerSquareArray) {
                for j in i {
                    j.square.fillColor = queuedSquareColor
                }
            }
        }
        
        func colorVisited() {
            for i in (game.displayVisitedSquareArray) {
                i.square.fillColor = visitedSquareColor
            }
        }
        
        func colorPath() {
            for i in game.displayPathSquareArray {
                i.square.fillColor = pathSquareColor
            }
        }
        
        func colorBarriers() {
            game.barrierSquareManager()
            
            for i in game.barrierNodesWaitingToBeDisplayed {
                i.square.fillColor = barrierSquareColor
//                updateScoreButtonText()
            }
        }
        
        func colorSnake() {
            for (index, squareAndLocation) in game.snakeBodyPos.enumerated() {
                if index == 0 {
                    squareAndLocation.square.fillColor = snakeHeadSquareColor
                } else {
                    squareAndLocation.square.fillColor = snakeBodySquareColor
                }
            }
        }
        
        func colorFood() {
            for i in (game.foodPosition) {
                i.square.fillColor = foodSquareColor
            }
        }
        
        if pathFindingAnimationsHaveEnded == true {
            if clearAllWasTapped != true {
                colorTheGameboard()
                colorQueued()
                colorVisited()
                if clearPathWasTapped != true {
                    colorPath()
                }
                
                if clearBarriersWasTapped != true {
                    colorBarriers()
                }
                colorSnake()
                colorFood()
            }
        }
    }
    
    private func createScreenLabels() {
        let pathFindingAlgorithimName = defaults.string(forKey: "Selected Path Finding Algorithim Name")
        let mazeGenerationAlgorithimName = defaults.string(forKey: "Selected Maze Algorithim Name")
        
        algorithimChoiceName = SKLabelNode(fontNamed: "Dogica_Pixel")
        algorithimChoiceName.text = "Path: \(pathFindingAlgorithimName ?? "Player"), Maze: \(mazeGenerationAlgorithimName ?? "None")"
        algorithimChoiceName.fontColor = screenLabelColor
        algorithimChoiceName.fontSize = 11
        algorithimChoiceName.horizontalAlignmentMode = .center
        algorithimChoiceName.position = CGPoint(x: 0, y: 185)
        algorithimChoiceName.zPosition = 1
        self.addChild(algorithimChoiceName)
    }
    
    private func createGameBoard() {
        func createBackground() {
            let screenSizeRectangle = CGRect(x: 0-frame.size.width/2, y: 0-frame.size.height/2, width: frame.size.width, height: frame.size.height)
            gameBackground = SKShapeNode(rect: screenSizeRectangle)
            gameBackground.fillColor = gameBackgroundColor
            gameBackground.strokeColor = gameBackgroundColor
            gameBackground.name = "gameBackground"
            self.addChild(gameBackground)
        }
        
        let squareWidth: CGFloat = 25
        // Creates the correct number of rows and columns based on screen size.
        // temp removal
        let realRowCount = Int(((frame.size.height)/squareWidth).rounded(.up)) // 17
        let realColumnCount = Int(((frame.size.width)/squareWidth).rounded(.up)) // 30
        rowCount = realRowCount
        columnCount = realColumnCount
        
        var matrix = [[Int]]()
        var row = [Int]()
        let shrinkRatio: CGFloat = 0.06
        let cornerRatio: CGFloat = 0.14
        let shrinkedSquareWidth = squareWidth - (squareWidth * shrinkRatio)
        let shrinkedSquareCornerRadius = squareWidth * cornerRatio
        var xAncor = CGFloat(0 - (Int(squareWidth) * columnCount)/2)
        var yAncor = CGFloat(0 + (Int(squareWidth) * rowCount)/2)
        xAncor = CGFloat(xAncor + (squareWidth/2))
        yAncor = CGFloat(yAncor - (squareWidth/2))
        
        createBackground()
        
        for x in 0...rowCount - 1 {
            for y in 0...columnCount - 1 {
                let square = SKShapeNode.init(rectOf: CGSize(width: shrinkedSquareWidth, height: shrinkedSquareWidth), cornerRadius: shrinkedSquareCornerRadius)
            
                // Make gameboard edges unexsesible and dimmer.
                if x == 0 || x == (rowCount - 1) {
                    row.append(9)
                    square.fillColor = fadedGameBoardSquareColor
                } else if y == 0 || y == (columnCount - 1) {
                    row.append(9)
                    square.fillColor = fadedGameBoardSquareColor
                } else {
                    row.append(0)
                    square.fillColor = gameboardSquareColor
                }
                
                square.name = String(x) + "," + String(y)
                square.position = CGPoint(x: xAncor, y: yAncor)
                square.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                
                gameBoard.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                gameBackground.addChild(square)
                
                xAncor += squareWidth
            }
            matrix.append(row)
            row = [Int]()
            // Update x and y
            xAncor = CGFloat(xAncor - CGFloat(Int(squareWidth) * columnCount))
            yAncor -= squareWidth
        }
        game.bringOvermatrix(tempMatrix: matrix)
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
    
    private func startTheGame() {
        let topCenter = CGPoint(x: 0, y: (frame.size.height / 2) - 25)
        algorithimChoiceName.run(SKAction.move(to: topCenter, duration: 0.4)) {
            self.game.initiateSnakeStartingPosition()
            self.game.spawnFoodBlock()
        }
        startingAnimationAndSquareColoring()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if defaults.bool(forKey: "Game Is Paused Setting") {
            swipeManager(swipeGesturesAreOn: false)
            barrierManager(touches: touches)
            swipeManager(swipeGesturesAreOn: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if defaults.bool(forKey: "Game Is Paused Setting") {
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
            for square in game.snakeBodyPos {if squareLocation.x == square.location.x && squareLocation.y == square.location.y {return true}}
            for square in game.foodPosition {if squareLocation.x == square.location.y && squareLocation.y == square.location.x {return true}}
            for square in game.pathBlockCordinates {if squareLocation.x == square.y && squareLocation.y == square.x {return true}}
            return false
        }
        
        for touch in touches {
            if let selectedSquare = selectSquareFromTouch(touch.location(in: self)) {
                let squareLocationAsString = (selectedSquare.name)?.components(separatedBy: ",")
                let squareLocation = Tuple(x: Int(squareLocationAsString![0])!, y: Int(squareLocationAsString![1])!)
                let vibration = UIImpactFeedbackGenerator(style: .medium)
                
                if squareLocation.x != 0 && squareLocation.x != (rowCount - 1) {
                    if squareLocation.y != 0 && squareLocation.y != (columnCount - 1) {
                        if !(IsSquareOccupied(squareLocation: squareLocation)) {
                            if self.viewController?.barrierButton.isEnabled == true {
                                if defaults.bool(forKey: "Add Barrier Mode On Setting") {
//                                    updateScoreButtonText()
                                    game.barrierNodesWaitingToBeDisplayed.append(SkNodeAndLocation(square: selectedSquare, location: squareLocation))
                                    selectedSquare.fillColor = barrierSquareColor
                                    colorTheBarriers()
                                    game.matrix[squareLocation.x][squareLocation.y] = 7
                                } else {
//                                    updateScoreButtonText()
                                    game.barrierNodesWaitingToBeRemoved.append(SkNodeAndLocation(square: selectedSquare, location: squareLocation))
                                    selectedSquare.fillColor = gameboardSquareColor
                                    colorTheBarriers()
                                    game.matrix[squareLocation.x][squareLocation.y] = 0
                                }
                            }
                            vibration.impactOccurred()
                        }
                    }
                }
                selectedSquare.run(animationSequanceManager(animation: 2))
            }
        }
    }
    
    // Animations
    var gamboardAnimationEnded = Bool()
    
    func startingAnimationAndSquareColoring() {
        // 1
        func gameBoardAnimation(_ nodes: [SkNodeAndLocation]) {
            let lastIndex = ((nodes.count) - 1)
            var gameBoardSquareWait = SKAction()
            for (squareIndex, squareAndLocation) in nodes.enumerated() {
                if squareIndex != lastIndex {
                    squareAndLocation.square.run(.sequence([gameBoardSquareWait, animationSequanceManager(animation: 1)]))
                } else {
                    squareAndLocation.square.run(.sequence([gameBoardSquareWait, animationSequanceManager(animation: 1)]), completion: {snakeBodyAnimationBegining()})
                }
                gameBoardSquareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.0006) // 0.003
            }
        }
        
        // 2
        func snakeBodyAnimationBegining() {
            let lastIndex = ((game.snakeBodyPos.count) - 1)
            var snakeBodySquareWait = SKAction()
            
            for (squareIndex, squareAndLocation) in game.snakeBodyPos.enumerated() {
                squareAndLocation.square.run(.sequence([snakeBodySquareWait]), completion: {snakeBodyAnimationEnding(square: squareAndLocation.square, squareIndex: squareIndex, lastIndex: lastIndex)})
                snakeBodySquareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.0085) // 0.085
            }
        }
        
        // 3
        func snakeBodyAnimationEnding(square: SKShapeNode, squareIndex: Int, lastIndex: Int) {
            square.run(.sequence([animationSequanceManager(animation: 2)]))
            if squareIndex == 0 {
                square.fillColor = snakeHeadSquareColor
            } else {
                square.fillColor = snakeBodySquareColor
            }
            
            if squareIndex == lastIndex {
                foodSquareAnimationBegining()
            }
        }
        
        // 4
        func foodSquareAnimationBegining() {
            for squareAndLocation in game.foodPosition {
                squareAndLocation.square.run(.sequence([animationSequanceManager(animation: 3)]), completion: {foodSquareAnimationEnding(square: squareAndLocation.square)})
            }
        }
        
        // 5
        func foodSquareAnimationEnding(square: SKShapeNode) {
            square.run(.sequence([animationSequanceManager(animation: 2)]))
            square.fillColor = foodSquareColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.firstAnimationSequanceHasCompleted = true
                self.gamboardAnimationEnded = true
                if self.pathFindingAlgorithimChoice == 0 {
                    // No pathfinding animation on player node, enable the buttons after inital animation.
                    self.animationDualButtonManager(buttonsEnabled: true)
                }
            }
        }
        gameBoardAnimation(gameBoard)
    }
    
    var firstAnimationSequanceHasCompleted = Bool()
    var pathFindingAnimationsHaveEnded = Bool()
    var visitedSquareDispatchCalled = Bool()
    var pathSquareDispatchCalled = Bool()
    var visitedSquareWait = SKAction()
    var pathSquareWait = SKAction()
    var animatedVisitedSquareCount = 0
    var animatedQueuedSquareCount = 0
    
    func pathFindingAnimationsAndSquareColoring() {
        func visitedSquareAnimationBegining() {
            // Color all squares while in animation mode.
            colorTheSnake()
            colorTheFood()
            colorTheBarriers()
            
            for (squareIIndex, squareAndLocation) in game.visitedNodeArray.enumerated() {
                // Easter would go here enable this one
                squareAndLocation.square.run(.sequence([visitedSquareWait]), completion: {visitedSquareAnimationEnding(squareAndLocation: squareAndLocation)})
                visitedSquareWait = .wait(forDuration: TimeInterval(squareIIndex) * Double(pathFindingAnimationSpeed))
                game.visitedNodeArray.remove(at: 0)
            }
        }
        
        func visitedSquareAnimationEnding(squareAndLocation: SkNodeAndLocation) {
            // Make sure the game dosent animate over food and the snake head.
            // Cant animate the head or food after the fact becouse it will ruin the animation. (Big-O).
            // Snake body and barriers will never be a consern since pathfinding animation ignores them.
            if !(game.foodPosition.contains(squareAndLocation)) && (game.snakeBodyPos[0] != squareAndLocation) {
                squareAndLocation.square.run(.sequence([animationSequanceManager(animation: 2)]))
                squareAndLocation.square.fillColor = visitedSquareColor
                updateScoreButtonText()
            }
            animatedVisitedSquareCount += 1
            
            // runs one time.
            if !visitedSquareDispatchCalled {
                DispatchQueue.main.asyncAfter(deadline: .now() + visitedSquareWait.duration) {
                    pathSquareAnimationBegining(run: self.visitedSquareDispatchCalled)
                }
                visitedSquareDispatchCalled = true
            }
        }
        
        func queuedSquareAnimationBegining() {
            var queuedSquareWait = SKAction()
            pathFindingAnimationsHaveEnded = false
            
            for (squareIndex, innerSquareArray) in game.fronteerSquareArray.enumerated() {
                for squareAndLocation in innerSquareArray {
                    // Easter would go here enable this one
                    squareAndLocation.square.run(.sequence([queuedSquareWait]), completion: {queuedSquareAnimationEnding(squareAndLocation: squareAndLocation)})
                    queuedSquareWait = .wait(forDuration: TimeInterval(squareIndex) * Double(pathFindingAnimationSpeed))
                }
                game.fronteerSquareArray.remove(at: 0)
            }
        }
        
        func queuedSquareAnimationEnding(squareAndLocation: SkNodeAndLocation) {
            // Make sure the game dosent animate over food and the snake head.
            // Cant animate the head or food after the fact becouse it will ruin the animation. (Big-O).
            // Snake body and barriers will never be a consern since pathfinding animation ignores them.
            if !(game.foodPosition.contains(squareAndLocation)) && (game.snakeBodyPos[0] != squareAndLocation) {
                squareAndLocation.square.run(.sequence([animationSequanceManager(animation: 2)]))
                squareAndLocation.square.fillColor = queuedSquareColor
                updateScoreButtonText()
            }
            animatedQueuedSquareCount += 1
        }
        
        func pathSquareAnimationBegining(run: Bool) {
            let lastIndex = ((game.pathSquareArray.count) - 1)
            for (squareIndex, squareAndLocation) in game.pathSquareArray.enumerated() {
                squareAndLocation.square.run(.sequence([pathSquareWait,animationSequanceManager(animation: 3)]), completion: {pathSquareAnimationEnding(square: squareAndLocation.square, squareIndex: squareIndex, lastIndex: lastIndex)})
                pathSquareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.005)
                game.pathSquareArray.remove(at: 0)
            }
        }
        
        func pathSquareAnimationEnding(square: SKShapeNode, squareIndex: Int, lastIndex: Int) {
            // Make sure the game dosent animate over food and the snake head.
            // Cant animate the head or food after the fact becouse it will ruin the animation. (Big-O).
            // Snake body and barriers will never be a consern since pathfinding animation ignores them.
            if squareIndex != 0 && squareIndex != lastIndex {
                square.run(.sequence([animationSequanceManager(animation: 2)]))
                square.fillColor = pathSquareColor
                updateScoreButtonText()
            }

            // runs one time.
            if !pathSquareDispatchCalled {
                DispatchQueue.main.asyncAfter(deadline: .now() + pathSquareWait.duration) {
                    // Animation ended re-enable the buttons.
                    self.animationDualButtonManager(buttonsEnabled: true)
                    self.pathFindingAnimationsHaveEnded = true
                    self.firstAnimationSequanceHasCompleted = true
                    
                    // new potential clean up needed.
                    // only when step mode is off should this run
                    if self.pathFindingAlgorithimChoice != 0 {
                        if !(UserDefaults.standard.bool(forKey: "Step Mode On Setting")) {
                            // temp change from 6
                            if self.game.snakeBodyPos.count != 26 {
                                UserDefaults.standard.set(false, forKey: "Game Is Paused Setting")
                                self.game.paused = false
                            }
                        }
                    }
                }
                pathSquareDispatchCalled = true
            }
        }
        
        visitedSquareDispatchCalled = false
        pathSquareDispatchCalled = false
        queuedSquareAnimationBegining()
        visitedSquareAnimationBegining()
    }
    
    func squareColoringWhileSnakeIsMoving() {
        if pathFindingAlgorithimChoice == 0 {
            colorTheGameboard()
            colorTheSnake()
            colorTheFood()
            colorThePath()
            colorTheBarriers()
        } else if pathFindingAnimationsHaveEnded == true && game.paused == false {
            colorTheGameboard()
            colorTheSnake()
            colorTheFood()
            colorThePath()
            colorTheBarriers()
        }
    }
    
    // Start: Square coloring helper functions.
    func colorTheGameboard() {
        for i in gameBoard {
            if i.location.x == 0 || i.location.x == (rowCount - 1) {
                i.square.fillColor = fadedGameBoardSquareColor
            } else if i.location.y == 0 || i.location.y == (columnCount - 1) {
                i.square.fillColor = fadedGameBoardSquareColor
            } else {
                i.square.fillColor = gameboardSquareColor
            }
        }
    }
    
    func colorTheSnake() {
        for (index, squareAndLocation) in game.snakeBodyPos.enumerated() {
            if index == 0 {
                squareAndLocation.square.fillColor = snakeHeadSquareColor
            } else {
                squareAndLocation.square.fillColor = snakeBodySquareColor
            }
        }
    }
    
    func colorTheFood() {
        for i in (game.foodPosition) {
            i.square.fillColor = foodSquareColor
        }
    }
    
    func colorThePath() {
        for i in (game.displayPathSquareArray) {
            i.square.fillColor = pathSquareColor
        }
    }
    
    func colorTheBarriers() {
        game.barrierSquareManager()
        
        for i in (game.barrierNodesWaitingToBeDisplayed) {
            i.square.fillColor = barrierSquareColor
        }
        updateScoreButtonText()
    }
    
    // Start: Animation helper function.
    func animationSequanceManager(animation: Int) -> SKAction {
        let wait0 = SKAction.wait(forDuration: 0.80)
        let wait1 = SKAction.wait(forDuration: 0.16)
        let wait2 = SKAction.wait(forDuration: 0.07)
        let grow1 = SKAction.scale(by: 1.05, duration: 0.10)
        let scale1 = SKAction.scale(to: 1.0, duration: 0.12)
        let shrink1 = SKAction.scale(by: 0.90, duration: 0.10)
        let shrink2 = SKAction.scale(by: 0.95, duration: 0.05)
        let shrink3 = SKAction.scale(by: 0.95, duration: 0.10)
        let shrink4 = SKAction.scale(by: 0.97, duration: 0.05)
        let shrink5 = SKAction.scale(by: 0.75, duration: 0.05)

        if animation == 1 {
            return SKAction.sequence([wait0, grow1, wait1, shrink1, wait1, scale1, shrink2, wait2, scale1])
        } else if animation == 2 {
            return SKAction.sequence([grow1, wait1, shrink3, wait1, scale1, shrink4, wait2, scale1])
        } else {
            return SKAction.sequence([shrink5, wait1, scale1])
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Check if user settings were modified.
        defaults.bool(forKey: "Settings Value Modified") ? (settingLoader(firstRun: false)) : ()
        // Check if score button was tapped.
        defaults.bool(forKey: "Score Button Is Tapped") ? (updateScoreButtonText()) : ()
        
        if pathFindingAlgorithimChoice != 0 {
            if game!.visitedNodeArray.count > 0 && gamboardAnimationEnded == true {
                // Dissble buttons for pathfinding animation.
                animationDualButtonManager(buttonsEnabled: false)
                pathFindingAnimationsAndSquareColoring()
            }
//            else {
//                // new
//                animationDualButtonManager(buttonsEnabled: true)
//            }
        }
        
        game.update(time: currentTime)
    }
    
    func updateScoreButtonHalo() {
        if game.conditionGreen {
            self.viewController?.scoreButton.layer.borderColor = UIColor.green.cgColor
        } else if game.conditionYellow {
            self.viewController?.scoreButton.layer.borderColor = UIColor.yellow.cgColor
        } else if game.conditionRed {
            self.viewController?.scoreButton.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func updateScoreButtonText() {
        let scoreButtonTag = self.viewController?.scoreButton.tag
        
        switch scoreButtonTag {
            case 1: // Highscore
                self.viewController?.scoreButton.setTitle("HS: " + String(defaults.integer(forKey: "highScore")), for: .normal)
            case 2: // Snake lenght
                self.viewController?.scoreButton.setTitle(String(game.snakeBodyPos.count), for: .normal)
            case 3: // Food
                self.viewController?.scoreButton.setTitle(String(game.foodPosition.count), for: .normal)
            case 4: // Path
                self.viewController?.scoreButton.setTitle(String(game.moveInstructions.count), for: .normal)
            case 5: // Visited
                self.viewController?.scoreButton.setTitle(String(animatedVisitedSquareCount), for: .normal)
            case 6: // Queued
                self.viewController?.scoreButton.setTitle(String(animatedQueuedSquareCount), for: .normal)
            case 7: // Barriers
                self.viewController?.scoreButton.setTitle(String(game.barrierNodesWaitingToBeDisplayed.count), for: .normal)
            case 8: // Weight
                self.viewController?.scoreButton.setTitle("NA", for: .normal)
            case 9: // Score
                if defaults.bool(forKey: "God Button On Setting") {
                    self.viewController?.scoreButton.setTitle("NA", for: .normal)
                } else {
                    self.viewController?.scoreButton.setTitle(String(game.currentScore), for: .normal)
                }
            default:
                print("Score button loading error")
        }
        defaults.set(false, forKey: "Score Button Is Tapped")
    }
    
    // barrier drawing should not work while animating fix.
    func animationDualButtonManager(buttonsEnabled: Bool) {
        if buttonsEnabled == true {
            self.viewController?.barrierButton.isEnabled = true
            self.viewController?.playButton.isEnabled = true
        } else if buttonsEnabled == false {
            self.viewController?.playButton.isEnabled = false
            self.viewController?.barrierButton.isEnabled = false
        }
    }
}
