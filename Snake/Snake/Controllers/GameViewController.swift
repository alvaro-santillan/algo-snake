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

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let pathFindingAlgorithmList = ["Breath First Search", "Depth First Search", "Greedy Depth First Search", "Uniform Cost Search", "Dijstras Search", "A-Star Search"]
    let mazeGenrationAlgorithims = ["Recursive backtracking algorithm", "Hunt and kill algorithm", "Eller's algorithm", "Sidewinder algorithm", "Prim's algorithm", "Kruskal's algorithm", "Depth-first search", "Breadth-first search"]
    let vsList = ["Player","Breath First Search", "Depth First Search", "Greedy Depth First Search", "Uniform Cost Search", "Dijstras Search", "A-Star Search"]
    
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tableViewDisplayList[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var highScoreLabel: UITextField!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var segControlWindow: UIView!
    @IBOutlet weak var DFS: UIButton!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var leftView: UIView!
    var selectDFS: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segControlOption(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            tableViewDisplayList = pathFindingAlgorithmList
            tableVIew.reloadData()
        }
        else if segControl.selectedSegmentIndex == 1 {
            tableViewDisplayList = mazeGenrationAlgorithims
            tableVIew.reloadData()
        }
        else {
            tableViewDisplayList = vsList
            tableVIew.reloadData()
        }
    }
    
    @IBAction func startMenu(_ sender: UIButton) {

    }
    
    @IBAction func DFSButton(_ sender: UIButton) {
        selectDFS = 1
        print("changed to 1")
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
            leftView.isHidden = true
            rightView.isHidden = true
//            segControlWindow.isHidden = true
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
