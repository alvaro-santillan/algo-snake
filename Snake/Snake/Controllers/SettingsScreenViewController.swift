//
//  SettingsViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsSceenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    
    // Text Buttons
    @IBOutlet weak var clearBarrierButton: UIButton!
    @IBOutlet weak var clearPathButton: UIButton!
    @IBOutlet weak var godModeButton: UIButton!
    @IBOutlet weak var snakeSpeedButton: UIButton!
    @IBOutlet weak var foodWeightButton: UIButton!
    @IBOutlet weak var foodCountButton: UIButton!
    
    // Icon Buttons
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    
    let defaults = UserDefaults.standard
    let colors = [
        UIColor(red: 0.94, green: 0.33, blue: 0.31, alpha: 1.00), // Light Red
        UIColor(red: 0.83, green: 0.18, blue: 0.18, alpha: 1.00), // Dark Red
        UIColor(red: 0.93, green: 0.25, blue: 0.48, alpha: 1.00), // Light Pink
        UIColor(red: 0.76, green: 0.09, blue: 0.36, alpha: 1.00), // Dark Pink
        UIColor(red: 0.67, green: 0.28, blue: 0.74, alpha: 1.00), // Light Purple
        UIColor(red: 0.48, green: 0.12, blue: 0.64, alpha: 1.00), // Dark Purple
        UIColor(red: 0.49, green: 0.34, blue: 0.76, alpha: 1.00), // Light Deep Purple
        UIColor(red: 0.32, green: 0.18, blue: 0.66, alpha: 1.00), // Dark Deep Purple
        UIColor(red: 0.36, green: 0.42, blue: 0.75, alpha: 1.00), // Light Indigo
        UIColor(red: 0.19, green: 0.25, blue: 0.62, alpha: 1.00), // Dark Indigo
        UIColor(red: 0.26, green: 0.65, blue: 0.96, alpha: 1.00), // Light Blue
        UIColor(red: 0.10, green: 0.46, blue: 0.82, alpha: 1.00), // Dark Blue
        UIColor(red: 0.16, green: 0.71, blue: 0.96, alpha: 1.00), // Light Light Blue
        UIColor(red: 0.01, green: 0.53, blue: 0.82, alpha: 1.00), // Dark Light Blue
        UIColor(red: 0.15, green: 0.78, blue: 0.85, alpha: 1.00), // Light Cyan
        UIColor(red: 0.00, green: 0.59, blue: 0.65, alpha: 1.00), // Dark Cyan
        UIColor(red: 0.15, green: 0.65, blue: 0.60, alpha: 1.00), // Light Teal
        UIColor(red: 0.00, green: 0.47, blue: 0.42, alpha: 1.00), // Dark Teal
        UIColor(red: 0.40, green: 0.73, blue: 0.42, alpha: 1.00), // Light Green
        UIColor(red: 0.22, green: 0.56, blue: 0.24, alpha: 1.00), // Dark Green
        UIColor(red: 0.61, green: 0.80, blue: 0.40, alpha: 1.00), // Light Light Green
        UIColor(red: 0.41, green: 0.62, blue: 0.22, alpha: 1.00), // Dark Light Green
        UIColor(red: 0.83, green: 0.88, blue: 0.34, alpha: 1.00), // Light Lime
        UIColor(red: 0.69, green: 0.71, blue: 0.17, alpha: 1.00), // Dark Lime
        UIColor(red: 1.00, green: 0.93, blue: 0.35, alpha: 1.00), // Light Yellow
        UIColor(red: 0.98, green: 0.75, blue: 0.18, alpha: 1.00), // Dark Yellow
        UIColor(red: 1.00, green: 0.79, blue: 0.16, alpha: 1.00), // Light Amber
        UIColor(red: 1.00, green: 0.63, blue: 0.00, alpha: 1.00), // Dark Amber
        UIColor(red: 1.00, green: 0.65, blue: 0.15, alpha: 1.00), // Light Orange
        UIColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00), // Dark Orange
        UIColor(red: 1.00, green: 0.44, blue: 0.26, alpha: 1.00), // Light Deep Orange
        UIColor(red: 0.90, green: 0.29, blue: 0.10, alpha: 1.00)] // Dark Deep Orange
    let lightBackgroundColors = [
        UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00), // White Clouds
        UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.00), // White Silver
        UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.00), // Light Gray Concrete
        UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.00)] // Light Gray Asbestos
    let darkBackgroundColors = [
        UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
        UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00), // Dark Gray Green Sea
        UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
        UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00)] // Dark Gray Green Sea
    var legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        loadButtonStyling()
    }
    
    func loadUserData() {
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    func loadButtonStyling() {
        var options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonLoader(targetButton: snakeSpeedButton, key: "Snake Speed Text Setting", optionArray: options)
        options = ["Food Weight: 1", "Food Weight: 2", "Food Weight: 3", "Food Weight: 5"]
        fourOptionButtonLoader(targetButton: foodWeightButton, key: "Food Weight Setting", optionArray: options)
        options = ["Food Count: 1", "Food Count: 2", "Food Count: 3", "Food Count: 5"]
        fourOptionButtonLoader(targetButton: foodCountButton, key: "Food Count Setting", optionArray: options)
        
        boolButtonLoader(isIconButton: false, targetButton: godModeButton, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
        boolButtonLoader(isIconButton: true, targetButton: soundButton, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: stepOrPlayPauseButton, key: "Step Mode On Setting", trueOption: "Step_Icon_Set", falseOption: "Play_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: darkOrLightModeButton, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsScreenTableViewCell
        let cellText = (legendData[indexPath.row][0] as? String)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.legendOptionText.text = legendData[indexPath.row][0] as? String
        cell.legendOptionSquareColor.backgroundColor = colorPaletteDesigner(cellText: cellText)[(legendData[indexPath.row][1] as? Int)!]
        cell.legendOptionSquareColor.layer.borderWidth = 1
        cell.legendOptionSquareColor.layer.cornerRadius = cell.legendOptionSquareColor.frame.size.width/4
        cell.legendOptionSquareColor.tag = indexPath.row
        cell.legendOptionSquareColor.isUserInteractionEnabled = true
        cell.legendOptionSquareColor.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedSquare = tapGestureRecognizer.view as! UIImageView
        let cellText = legendData[tappedSquare.tag][0] as! String
        let colorPalette = colorPaletteDesigner(cellText: cellText)
        var colorID = (legendData[tappedSquare.tag][1] as! Int) + 1
        
        colorID == colorPalette.count ? (colorID = 0) : ()
        defaults.setColor(color: colorPalette[(legendData[tappedSquare.tag][1] as! Int)], forKey: legendData[tappedSquare.tag][0] as! String)
        legendData[tappedSquare.tag][1] = colorID
        defaults.set(legendData, forKey: "Legend Preferences")
        tableVIew.reloadData()
        changeNotifier()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: UIButton) {
        sender.setTitle("Gameboard Cleared", for: .normal)
        clearBarrierButton.setTitle("Barriers Cleared", for: .normal)
        clearPathButton.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear All Setting")
    }
    
    @IBAction func clearBarrierButtonTapped(_ sender: UIButton) {
        sender.setTitle("Barriers Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Barrier Setting")
    }
    
    @IBAction func clearPathButtonTapped(_ sender: UIButton) {
        sender.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Path Setting")
    }
    
    @IBAction func snakeSpeedButtonTapped(_ sender: UIButton) {
        let options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonResponder(sender, isSpeedButton: true, key: "Snake Speed Text Setting", optionArray: options)
    }
    
    @IBAction func foodWeightButtonTapped(_ sender: UIButton) {
        let options = ["Food Weight: 1", "Food Weight: 2", "Food Weight: 3", "Food Weight: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Weight Setting", optionArray: options)
    }
    
    @IBAction func foodCountButtonTapped(_ sender: UIButton) {
        let options = ["Food Count: 1", "Food Count: 2", "Food Count: 3", "Food Count: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Count Setting", optionArray: options)
    }
    
    @IBAction func godButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: false, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
    }
    
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
    }
    
    @IBAction func stepButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Step Mode On Setting", trueOption: "Step_Icon_Set", falseOption: "Play_Icon_Set")
    }
    
    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
        
        if (defaults.bool(forKey: "Dark Mode On Setting")) == true {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
                self.overrideUserInterfaceStyle = .dark
                self.presentingViewController?.overrideUserInterfaceStyle = .dark
            })
        } else {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
                self.overrideUserInterfaceStyle = .light
                self.presentingViewController?.overrideUserInterfaceStyle = .light
            })
        }
        tableVIew.reloadData()
    }
}
