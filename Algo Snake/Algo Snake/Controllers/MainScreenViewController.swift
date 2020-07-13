//
//  MainScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var highScoreLabel: UITextField!
    
    
    //let pathFindingAlgorithmList = [["Player","0","0"], ["A-Star Search","1","1"], ["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Dijkstra's Search","1","1"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"]]
    
    //let mazeGenrationAlgorithimList = [["None","0","0"], ["Breadth-first search","1","0"], ["Depth-first search","1","0"], ["Eller's algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Prim's algorithm","1","1"], ["Recursive backtracking algorithm","1","1"], ["Sidewinder algorithm","1","1"]]
    
    let pathFindingAlgorithmList = [["Player","0","0"], ["A Star Search","0","0"], ["Breath First Search","0","0"], ["Depth First Search","0","0"], ["Dijkstra`s Search","0","0"], ["Uniform Cost Search","0","0"]]
    
    let mazeGenrationAlgorithimList = [["None","0","0"], ["Depth First Search","0","0"]]
    
    let defaults = UserDefaults.standard
    var selectedPathAlgorithim = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var selectedMazeAlgorithim = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfFirstRun()
        loadUserData()
    }
    
    func checkIfFirstRun() {
        if !defaults.bool(forKey: "Not First Launch") {
            let legendData = [["Snake Head", 9], ["Snake Body", 11], ["Food", 0], ["Path", 15], ["Visited Square", 6], ["Queued Square", 5], ["Barrier Coming Soon", 17], ["Weight", 19],  ["Gameboard", 0]]
            
            defaults.set(legendData, forKey: "Legend Preferences")
            defaults.set(2, forKey: "Snake Speed Text Setting")
            defaults.set(0.25, forKey: "Snake Move Speed")
            defaults.set(true, forKey: "Food Weight Setting")
            defaults.set(true, forKey: "Food Count Setting")
            defaults.set(false, forKey: "God Button On Setting")
            defaults.set(true, forKey: "Volume On Setting")
            defaults.set(false, forKey: "Step Mode On Setting")
            defaults.set(true, forKey: "Dark Mode On Setting")
            defaults.set(true, forKey: "Not First Launch")
            defaults.set(true, forKey: "Game Is Paused Setting")
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func loadUserData() {
        highScoreLabel.text = "High Score: \(defaults.integer(forKey: "highScore"))"
        lastScoreLabel.text = "Last Score: \(defaults.integer(forKey: "lastScore"))"
        defaults.bool(forKey: "Dark Mode On Setting") ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        segControl.font(name: "Dogica_Pixel", size: 9)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return tableViewDisplayList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.label.text = tableViewDisplayList[indexPath.row][0]
        cell.guaranteedIconSquare.contentMode = .scaleAspectFit
        cell.layer.cornerRadius = 5
        
        tableViewDisplayList[indexPath.row][1] == "1" ? (cell.guaranteedIconSquare.image = UIImage(named: "Guaranteed_Icon_Set.pdf")) : (cell.guaranteedIconSquare.image = nil)
        tableViewDisplayList[indexPath.row][2] == "1" ? (cell.optimalIconSquare.image = UIImage(named: "Optimal_Icon_Set.pdf")) : (cell.optimalIconSquare.image = nil)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            selectedPathAlgorithim = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Path Finding Algorithim")
            defaults.set(pathFindingAlgorithmList[indexPath.row][0], forKey: "Selected Path Finding Algorithim Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            selectedMazeAlgorithim = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Maze Algorithim")
            defaults.set(mazeGenrationAlgorithimList[indexPath.row][0], forKey: "Selected Maze Algorithim Name")
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
        segControl.selectedSegmentIndex == 0 ? (tableViewDisplayList = pathFindingAlgorithmList) : (tableViewDisplayList = mazeGenrationAlgorithimList)
        tableVIew.reloadData()
    }
}
