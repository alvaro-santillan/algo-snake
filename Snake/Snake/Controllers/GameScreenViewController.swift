//
//  GameScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameScreenViewController: UIViewController {
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var barrierButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var currentGame: GameManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        loadButtonStyling()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameManager
                currentGame?.viewController = self
            }
        }
    }
    
    func loadUserData() {
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    func loadButtonStyling() {
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
        UserDefaults.standard.bool(forKey: "Game Is Paused Setting") ? (barrierButton.isEnabled = true) : (barrierButton.isEnabled = false)
        UserDefaults.standard.set(true, forKey: "Add Barrier Mode On Setting")
        boolButtonLoader(isIconButton: true, targetButton: barrierButton, key: "Add Barrier Mode On Setting", trueOption: "Plus_Icon_Set", falseOption: "Minus_Icon_Set")
        
        scoreButton.layer.borderWidth = 2
        scoreButton.layer.borderColor = UIColor.systemPink.cgColor
    }
    
//    let legendData = [["Snake Head", 0], ["Snake Body", 0], ["Food", 3], ["Path", 17], ["Visited Square", 5], ["Queued Square", 15], ["Barrier", 7], ["Weight", 19],  ["Gameboard", 1]]
    let legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
    
    @IBAction func scoreButtonTapped(_ sender: UIButton) {
        
        func scoreButtonBackgroundManager(_ sender: UIButton) {
            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
            sender.tag = sender.tag + 1
        }
        
        // If button tapped switch to next option.
        switch sender.tag {
//        case 0:
//            print("Snake lenght count")
//            scoreButtonBackgroundManager(sender)
////            sender.tag = 1
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
//        case 1:
//            print("Food count")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 2
//        case 2:
//            print("Path square count")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 3
//        case 3:
//            print("Visited square")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 4
//        case 4:
//            print("Queued Square")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 5
//        case 5:
//            print("Barrier count")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 6
//        case 6:
//            print("Weight")
//            scoreButtonBackgroundManager(sender)
////            sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
////            sender.tag = 7
        case 7:
            print("Score")
            sender.backgroundColor = UIColor(named: "UI Button")!.withAlphaComponent(0.5)
            sender.tag = 8
        case 8:
            print("High score")
            sender.backgroundColor = UIColor(named: "UI Button")!.withAlphaComponent(0.5)
            sender.tag = 0
        default:
            scoreButtonBackgroundManager(sender)
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        self.removeFromParent()
        self.currentGame?.viewController.removeFromParent()
        self.dismiss(animated: true)
    }
    
    @IBAction func stepButtonTapped(_ sender: UIButton) {
        // If the game is paused, then the correct icon to display is play.
        boolButtonResponder(sender, isIconButton: true, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
        sender.tag == 1 ? (barrierButton.isEnabled = true) : (barrierButton.isEnabled = false)
        
    }
    
    @IBAction func barrierButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Add Barrier Mode On Setting", trueOption: "Plus_Icon_Set", falseOption: "Minus_Icon_Set")
    }
}
