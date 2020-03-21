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
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var highScoreLabel: UITextField!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var leftView: UIView!
    
    let pathFindingAlgorithmList = [["Player","0","0"], ["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    let mazeGenrationAlgorithims = [["None","0","0"], ["Recursive backtracking algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Eller's algorithm","1","1"], ["Sidewinder algorithm","1","1"], ["Prim's algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Depth-first search","1","0"], ["Breadth-first search","1","0"]]
    let vsList = [["Player","0","0"],["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
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
}
