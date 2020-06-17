//
//  GameViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var highScoreLabel: UITextField!

    let pathFindingAlgorithmList = [["Player","0","0"], ["A-Star Search","1","1"], ["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Dijkstra's Search","1","1"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"]]
    let mazeGenrationAlgorithims = [["None","0","0"], ["Breadth-first search","1","0"], ["Depth-first search","1","0"], ["Eller's algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Prim's algorithm","1","1"], ["Recursive backtracking algorithm","1","1"], ["Sidewinder algorithm","1","1"]]
    var selectedPathAlgorithim = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var selectedMazeAlgorithim = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfFirstRun()
        loadUserData()
    }
    
    func checkIfFirstRun() {
        if !UserDefaults.standard.bool(forKey: "Not First Launch") {
            let legendData = [["Snake Head", 0], ["Snake Body", 0], ["Food", 3], ["Path", 17], ["Visited Square", 5], ["Queued Square", 15], ["Barrier", 7], ["Weight", 19],  ["Gameboard", 1]]
            
            UserDefaults.standard.set(legendData, forKey: "Legend Preferences")
            UserDefaults.standard.set(2, forKey: "Snake Speed Text Setting")
            UserDefaults.standard.set(0.01, forKey: "Snake Move Speed")
            UserDefaults.standard.set(true, forKey: "Food Weight Setting")
            UserDefaults.standard.set(true, forKey: "Food Count Setting")
            UserDefaults.standard.set(false, forKey: "God Button On Setting")
            UserDefaults.standard.set(true, forKey: "Volume On Setting")
            UserDefaults.standard.set(false, forKey: "Step Mode On Setting")
            UserDefaults.standard.set(true, forKey: "Dark Mode On Setting")
            UserDefaults.standard.set(true, forKey: "Not First Launch")
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func loadUserData() {
        highScoreLabel.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        lastScoreLabel.text = "Last Score: \(UserDefaults.standard.integer(forKey: "lastScore"))"
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        segControl.font(name: "Dogica_Pixel", size: 9)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return tableViewDisplayList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.myLabel.text = tableViewDisplayList[indexPath.row][0]
        cell.myImage.contentMode = .scaleAspectFit
        cell.layer.cornerRadius = 5
        
        tableViewDisplayList[indexPath.row][1] == "1" ? (cell.myImage.image = UIImage(named: "Guaranteed_Icon_Set.pdf")) : (cell.myImage.image = nil)
        tableViewDisplayList[indexPath.row][2] == "1" ? (cell.myImage2.image = UIImage(named: "Optimal_Icon_Set.pdf")) : (cell.myImage2.image = nil)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            selectedPathAlgorithim = indexPath.row
            UserDefaults.standard.set(indexPath.row, forKey: "Selected Path Finding Algorithim")
            UserDefaults.standard.set(pathFindingAlgorithmList[indexPath.row][0], forKey: "Selected Path Finding Algorithim Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            selectedMazeAlgorithim = indexPath.row
            UserDefaults.standard.set(indexPath.row, forKey: "Selected Maze Algorithim")
            UserDefaults.standard.set(pathFindingAlgorithmList[indexPath.row][0], forKey: "Selected Maze Algorithim Name")
        }
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var choice = Int()
        segControl.selectedSegmentIndex == 0 ? (choice = selectedPathAlgorithim) : (choice = selectedMazeAlgorithim)
        tableView.selectRow(at: [0, choice], animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameScreen") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        segControl.selectedSegmentIndex == 0 ? (tableViewDisplayList = pathFindingAlgorithmList) : (tableViewDisplayList = mazeGenrationAlgorithims)
        tableVIew.reloadData()
    }
}
