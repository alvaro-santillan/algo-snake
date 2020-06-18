//
//  GameScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameScreenViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    
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
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadUserData() {
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    func loadButtonStyling() {
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Pause_Icon_Set", falseOption: "Play_Icon_Set")
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        self.removeFromParent()
        self.currentGame?.viewController.removeFromParent()
        self.dismiss(animated: true)
    }
    
    @IBAction func stepButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Game Is Paused Setting", trueOption: "Pause_Icon_Set", falseOption: "Play_Icon_Set")
    }
    
    @IBAction func barrierButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "Plus_Icon_Set"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Minus_Icon_Set"), for: .normal)
            sender.tag = 0
        }
    }
}
