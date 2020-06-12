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
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var highScoreLabel: UITextField!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    let pathFindingAlgorithmList = [["Player","0","0"], ["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    let mazeGenrationAlgorithims = [["None","0","0"], ["Recursive backtracking algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Eller's algorithm","1","1"], ["Sidewinder algorithm","1","1"], ["Prim's algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Depth-first search","1","0"], ["Breadth-first search","1","0"]]
    let vsList = [["Player","0","0"],["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    override func viewWillAppear(_ animated: Bool) {
//        print("--------------qqqqqqqqqqweqweqweqweqweqweqwe---------------")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        if (self.isBeingDismissed || self.isMovingFromParent) {
//            print("---asdasdasdasd---")
//        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
//        print("---qqqwqwqwqw---")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("--------------zxzxzxzxzxzxzxzxzxzxzxzxzxzxzx---------------")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("--------------asdjfhasdhfkasdhfjkasdhfkjad---------------")
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("--------------dafsdfakjsdfkjashdfhasdjkfhasd---------------")
        
//        self.clearsSelectionOnViewWillAppear = false
        highScoreLabel.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        lastScoreLabel.text = "Last Score: \(UserDefaults.standard.integer(forKey: "lastScore"))"
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        
        // Views
        leftView.layer.shadowColor = UIColor.darkGray.cgColor
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = .zero
        
        // Buttons
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.shadowColor = UIColor.darkGray.cgColor
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.shadowOpacity = 0.2
        settingsButton.layer.shadowOffset = .zero
        startButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        startButton.layer.cornerRadius = 6
        startButton.layer.shadowColor = UIColor.darkGray.cgColor
        startButton.layer.shadowRadius = 5
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowOffset = .zero
    }
    
    @IBAction func startTapped(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameScreen") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.myLabel.text = tableViewDisplayList[indexPath.row][0]
        
        if tableViewDisplayList[indexPath.row][1] == "1" {
            cell.myImage.image = UIImage(named: "Guaranteed_Icon.pdf")
            cell.myImage.layer.borderWidth = 1
            cell.myImage.layer.cornerRadius = cell.myImage.frame.size.width/2
            cell.myImage.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][1] == "0" {
            cell.myImage.image = UIImage(named: "")
            cell.myImage.layer.borderWidth = 0
        }
        
        if tableViewDisplayList[indexPath.row][2] == "1" {
            cell.myImage2.image = UIImage(named: "Optimal_Icon.pdf")
            cell.myImage2.layer.borderWidth = 1
            cell.myImage2.layer.cornerRadius = cell.myImage2.frame.height/2
            cell.myImage2.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][2] == "0" {
            cell.myImage2.image = UIImage(named: "")
            cell.myImage2.layer.borderWidth = 0
        }
        
        return cell
    }
    
    var algoChoice = UserDefaults.standard.integer(forKey: "Algorithim Choice")
    var barrierChoice = UserDefaults.standard.integer(forKey: "Barrier Choice")

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            algoChoice = indexPath.row
            UserDefaults.standard.set(indexPath.row, forKey: "Algorithim Choice")
            UserDefaults.standard.set(pathFindingAlgorithmList[indexPath.row][0], forKey: "Algorithim Choice Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            barrierChoice = indexPath.row
            UserDefaults.standard.set(indexPath.row, forKey: "Barrier Choice")
        }
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            let indexPath = IndexPath(row: algoChoice, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        if segControl.selectedSegmentIndex == 1 {
            let indexPath = IndexPath(row: barrierChoice, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
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
