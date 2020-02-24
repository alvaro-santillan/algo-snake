//
//  GameViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var highScoreLabel: UITextField!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var segControlWindow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startMenu(_ sender: UIButton) {

    }
    @IBAction func StartButton(_ sender: UIButton) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .fill
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            settingsButton.isHidden = true
            startButton.isHidden = true
            highScoreLabel.isHidden = true
            lastScoreLabel.isHidden = true
            titleLabel.isHidden = true
            segControl.isHidden = true
            segControlWindow.isHidden = true
        }
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
