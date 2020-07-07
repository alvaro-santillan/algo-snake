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
    
    weak var mainScreenViewController: MainScreenViewController!
    
    let defaults = UserDefaults.standard
    let legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
    let scenee = SKScene()
    var currentGame: GameManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        homeButtonDisabler()
        loadButtonStyling()
        loadScoreButtonStyling()
        
        if let view = self.view as! SKView? {
            if let scenee = SKScene(fileNamed: "GameScene") {
                // Present the scene
                view.presentScene(scenee)
                currentGame = scenee as? GameManager
                currentGame?.viewController = self
            }
        }
    }
    
    func loadUserData() {
        defaults.bool(forKey: "Dark Mode On Setting") ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    // If home button is pressed right as view loads a memory leak ocurse.
    func homeButtonDisabler() {
        homeButton.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.homeButton.isEnabled = true
        }
    }
    
    func loadButtonStyling() {
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
        defaults.bool(forKey: "Game Is Paused Setting") ? (barrierButton.isEnabled = true) : (barrierButton.isEnabled = false)
        defaults.set(true, forKey: "Add Barrier Mode On Setting")
        
        boolButtonLoader(isIconButton: true, targetButton: barrierButton, key: "Add Barrier Mode On Setting", trueOption: "Plus_Icon_Set", falseOption: "Minus_Icon_Set")
    }
    
    func loadScoreButtonStyling() {
        scoreButton.layer.borderWidth = 2
        scoreButton.layer.borderColor = UIColor(named: "UI Button")!.withAlphaComponent(0.8).cgColor
        scoreButton.layer.backgroundColor = UIColor(named: "UI Button")!.withAlphaComponent(0.5).cgColor
    }
    
    func reloadStepButtonSettings(isTheGamePaused: Bool) {
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
        defaults.bool(forKey: "Game Is Paused Setting") ? (barrierButton.isEnabled = true) : (barrierButton.isEnabled = false)
        
        boolButtonLoader(isIconButton: true, targetButton: barrierButton, key: "Add Barrier Mode On Setting", trueOption: "Plus_Icon_Set", falseOption: "Minus_Icon_Set")
    }
    
    @IBAction func scoreButtonTapped(_ sender: UIButton) {
        
        // If button tapped switch to next option.
        switch sender.tag {
            case 1:
                print("Snake lenght count")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 2
            case 2:
                print("Food count")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 3
            case 3:
                print("Path square count")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 4
            case 4:
                print("Visited square")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 5
            case 5:
                print("Queued Square")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 6
            case 6:
                print("Barrier count")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 7
            case 7:
                print("Weight")
                sender.backgroundColor = colors[(legendData[sender.tag][1] as? Int)!].withAlphaComponent(0.5)
                sender.tag = 8
            case 8:
                print("Score")
                sender.backgroundColor = UIColor(named: "UI Button")!.withAlphaComponent(0.5)
                sender.tag = 9
            case 9:
                print("High score")
                sender.backgroundColor = UIColor(named: "UI Button")!.withAlphaComponent(0.5)
                sender.tag = 1
            default:
                print("Score button loading error")
        }
        defaults.set(true, forKey: "Score Button Is Tapped")
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
