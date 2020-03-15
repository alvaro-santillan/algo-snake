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
    
    let pathFindingAlgorithmList = [["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijstras Search","1","1"], ["A-Star Search","1","1"]]
    let mazeGenrationAlgorithims = [["Recursive backtracking algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Eller's algorithm","1","1"], ["Sidewinder algorithm","1","1"], ["Prim's algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Depth-first search","1","0"], ["Breadth-first search","1","0"]]
    let vsList = [["Player","0","0"],["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijstras Search","1","1"], ["A-Star Search","1","1"]]
    
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.myLabel.text = tableViewDisplayList[indexPath.row][0]
        
        if tableViewDisplayList[indexPath.row][1] == "1" {
            cell.myImage.image = UIImage(named: "garrenteed.pdf")
            cell.myImage.layer.borderWidth = 1
            cell.myImage.layer.cornerRadius = cell.myImage.frame.size.width/2
            cell.myImage.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][1] == "0" {
            cell.myImage.image = UIImage(named: "")
            cell.myImage.layer.borderWidth = 0
        }
        
        if tableViewDisplayList[indexPath.row][2] == "1" {
            cell.myImage2.image = UIImage(named: "optimal.jpg")
            cell.myImage2.layer.borderWidth = 1
            cell.myImage2.layer.cornerRadius = cell.myImage2.frame.height/2
            cell.myImage2.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][2] == "0" {
            cell.myImage2.image = UIImage(named: "")
            cell.myImage2.layer.borderWidth = 0
        }
        return cell
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var highScoreLabel: UITextField!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var DFS: UIButton!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var leftView: UIView!
    var selectDFS: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
//        startButton.imageView?.contentMode = .scaleAspectFit
//        startButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
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
