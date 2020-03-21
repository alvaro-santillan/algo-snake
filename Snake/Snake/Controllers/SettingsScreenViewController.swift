//
//  SettingsViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let pathFindingAlgorithmList = [["Player","1","1"], ["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    let mazeGenrationAlgorithims = [["None","0","0"], ["Recursive backtracking algorithm","1","1"], ["Hunt and kill algorithm","1","1"], ["Eller's algorithm","1","1"], ["Sidewinder algorithm","1","1"], ["Prim's algorithm","1","1"], ["Kruskal's algorithm","1","1"], ["Depth-first search","1","0"], ["Breadth-first search","1","0"]]
    let vsList = [["Player","0","0"],["Breath First Search","1","0"], ["Depth First Search","1","0"], ["Greedy Depth First Search","1","0"], ["Uniform Cost Search","1","1"], ["Dijkstra's Search","1","1"], ["A-Star Search","1","1"]]
    
    let array = ["1","2","3","4","5","6","7"]
    
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SettingsScreenTableViewCell
        
//        cell2.myLabell.text = array[indexPath.row]
        cell2.myLabell.text = pathFindingAlgorithmList[indexPath.row][0]
        
        if tableViewDisplayList[indexPath.row][1] == "1" {
            cell2.myImagee.image = UIImage(named: "garrenteed.pdf")
            cell2.myImagee.layer.borderWidth = 1
            cell2.myImagee.layer.cornerRadius = cell2.myImagee.frame.size.width/2
            cell2.myImagee.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][1] == "0" {
            cell2.myImagee.image = UIImage(named: "")
            cell2.myImagee.layer.borderWidth = 0
        }

        if tableViewDisplayList[indexPath.row][2] == "1" {
            cell2.myImage22.image = UIImage(named: "optimal.jpg")
            cell2.myImage22.layer.borderWidth = 1
            cell2.myImage22.layer.cornerRadius = cell2.myImage22.frame.height/2
            cell2.myImage22.clipsToBounds = true
        } else if tableViewDisplayList[indexPath.row][2] == "0" {
            cell2.myImage22.image = UIImage(named: "")
            cell2.myImage22.layer.borderWidth = 0
        }
        return cell2
    }
    
    @IBAction func godButton(_ sender: UIButton) {
        print("god button pushed")
    }
}
