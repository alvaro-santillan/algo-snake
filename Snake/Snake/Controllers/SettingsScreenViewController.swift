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
    
    let legendData = [["Player", 1], ["Player", 0]]
    
    let colors = [
            UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.00), // Teal Turquoise
            UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.00), // Teal GreenSea
            UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.00), // Green Emerald
            UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.00), // Green Nephritis
            UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.00), // Blue Peter River
            UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.00), // Blue Belize Hole
            UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.00), // Purple Amethyst
            UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.00), // Purple Wisteria
            UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
            UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00), // Dark Gray Green Sea
            UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.00), // Light Gray Concrete
            UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.00), // Light Gray Asbestos
            UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00), // White Clouds
            UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.00), // White Silver
            UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.00), // Red Alizarin
            UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.00), // Red Pomegranate
            UIColor(red:0.90, green:0.49, blue:0.13, alpha:1.00), // Orange Carrot
            UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.00), // Orange Pumpkin
            UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.00), // Yellow Sun Flower
            UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.00) // Yellow Orange
        ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SettingsScreenTableViewCell
        cell2.myLabell.text = legendData[indexPath.row][0] as? String
        cell2.myImagee.backgroundColor = colors[(legendData[indexPath.row][1] as? Int)!]
        cell2.myImagee.layer.borderWidth = 1
        cell2.myImagee.layer.cornerRadius = cell2.myImagee.frame.size.width/2
        cell2.myImagee.clipsToBounds = true
        
        return cell2
    }
    
    @IBAction func godButton(_ sender: UIButton) {
        print("god button pushed")
    }
}
