//
//  GameScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class GameScreenViewController: UIViewController {
    var currentGame: GameManager?
    var colorNumbertTest = 999
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.integer(forKey: "darkOrLightButton") == 0 {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        // Buttons
        scoreButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        scoreButton.layer.cornerRadius = 6
        scoreButton.layer.shadowColor = UIColor.darkGray.cgColor
        scoreButton.layer.shadowRadius = 5
        scoreButton.layer.shadowOpacity = 0.5
        scoreButton.layer.shadowOffset = .zero
        stepOrPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        stepOrPlayPauseButton.layer.cornerRadius = 6
        stepOrPlayPauseButton.layer.shadowColor = UIColor.darkGray.cgColor
        stepOrPlayPauseButton.layer.shadowRadius = 5
        stepOrPlayPauseButton.layer.shadowOpacity = 0.5
        stepOrPlayPauseButton.layer.shadowOffset = .zero
        weightButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        weightButton.layer.cornerRadius = 6
        weightButton.layer.shadowColor = UIColor.darkGray.cgColor
        weightButton.layer.shadowRadius = 5
        weightButton.layer.shadowOpacity = 0.5
        weightButton.layer.shadowOffset = .zero
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        homeButton.layer.cornerRadius = 6
        homeButton.layer.shadowColor = UIColor.darkGray.cgColor
        homeButton.layer.shadowRadius = 5
        homeButton.layer.shadowOpacity = 0.5
        homeButton.layer.shadowOffset = .zero
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.shadowColor = UIColor.darkGray.cgColor
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.shadowOpacity = 0.5
        settingsButton.layer.shadowOffset = .zero
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameManager
                currentGame?.viewController = self
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    @IBAction func stepOrPlayPauseButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "play-solid.pdf"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "pause-solid.pdf"), for: .normal)
            sender.tag = 0
        }
    }
    
    func printStuff() {
        print("printing stuff")
    }
    
    @IBAction func weightButton(_ sender: UIButton) {
        print("weight pushed")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
