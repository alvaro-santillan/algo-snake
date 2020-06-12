//
//  SettingsViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                set(colorData, forKey: key)
            } catch let err {
                print("error archiving color data", err)
            }
        }
    }
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            do {
                color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch let err {
                print("error unarchiving color data", err)
            }
        }
        return color
    }
}

class SettingsUIButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 6
    }
}

class TextUIButton: SettingsUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.2
    }
}

class IconUIButton: SettingsUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        self.layer.shadowOpacity = 0.5
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    
    // Text Buttons
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var clearBarrierButton: UIButton!
    @IBOutlet weak var clearPathButton: UIButton!
    @IBOutlet weak var godModeButton: UIButton!
    @IBOutlet weak var snakeSpeedButton: UIButton!
    @IBOutlet weak var foodWeightButton: UIButton!
    @IBOutlet weak var foodCountButton: UIButton!
    
    // Icon Buttons
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    let defaults = UserDefaults.standard
    var legendData = [["Snake", 0], ["Snake Head", 0], ["Food", 3], ["Path", 17], ["Visited Square", 5], ["Queued Square", 15], ["Unvisited Square", 13], ["Barrier", 7], ["Weight", 19]]
    var SavedlegendData = [[Any]]()
    var SavedSpeed = Int()
    var gameMoveSpeed = Float()
    var foodWeight = Int()
    var savedFoodCount = Int()
    var savedGodButton = Int()
    var muteButton = Int()
    var stopOrPlayButton = Int()
    var darkOrLightButton = Int()
    
    var snake = UIColor()
    var snakeHead = UIColor()
    var food = UIColor()
    var path = UIColor()
    var visitedSquare = UIColor()
    var queuedSquare = UIColor()
    var unvisitedSquare = UIColor()
    var barrier = UIColor()
    var weight = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.integer(forKey: "darkOrLightButton") == 0 {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        // Views
        leftView.layer.shadowColor = UIColor.darkGray.cgColor
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = .zero
        
        snake = defaults.colorForKey(key: "Snake") ?? colors[legendData[0][1] as! Int]
        snakeHead = defaults.colorForKey(key: "Head") ?? colors[legendData[1][1] as! Int]
        food = defaults.colorForKey(key: "Food") ?? colors[legendData[2][1] as! Int]
        path = defaults.colorForKey(key: "Path") ?? colors[legendData[3][1] as! Int]
        visitedSquare = defaults.colorForKey(key: "Visited Square") ?? colors[legendData[4][1] as! Int]
        queuedSquare = defaults.colorForKey(key: "Queued Square") ?? colors[legendData[5][1] as! Int]
        unvisitedSquare = defaults.colorForKey(key: "Unvisited Square") ?? colors[legendData[6][1] as! Int]
        barrier = defaults.colorForKey(key: "Barrier") ?? colors[legendData[7][1] as! Int]
        weight = defaults.colorForKey(key: "Weight") ?? colors[legendData[8][1] as! Int]
        
//        Settings data percestence
        SavedlegendData = (defaults.array(forKey: "legendPrefences") as? [[Any]] ?? legendData)
        legendData = SavedlegendData
        
        SavedSpeed = defaults.integer(forKey: "SavedSpeedSetting")
        if SavedSpeed == 1 {
            snakeSpeedButton.setTitle("Speed: Fast", for: .normal)
        } else if SavedSpeed == 2 {
            snakeSpeedButton.setTitle("Speed: Extreme", for: .normal)
        } else if SavedSpeed == 3 {
            snakeSpeedButton.setTitle("Speed: Slow", for: .normal)
        } else {
            snakeSpeedButton.setTitle("Speed: Normal", for: .normal)
        }

        // can probilby be reduced in size.
        foodWeight = defaults.integer(forKey: "FoodWeightSetting")
        print("Food weight", foodWeight)
        if foodWeight == 1 {
            foodWeightButton.setTitle("Food Weight: 2", for: .normal)
        } else if foodWeight == 2 {
            foodWeightButton.setTitle("Food Weight: 3", for: .normal)
        } else if foodWeight == 4 {
            foodWeightButton.setTitle("Food Weight: 5", for: .normal)
        } else {
            foodWeightButton.setTitle("Food Weight: 1", for: .normal)
        }
        
        savedFoodCount = defaults.integer(forKey: "FoodCountSetting")
        if savedFoodCount == 1 {
            foodCountButton.setTitle("Food Count: 2", for: .normal)
        } else if savedFoodCount == 2 {
            foodCountButton.setTitle("Food Count: 3", for: .normal)
        } else if savedFoodCount == 4 {
            foodCountButton.setTitle("Food Count: 5", for: .normal)
        } else {
            foodCountButton.setTitle("Food Count: 1", for: .normal)
        }
        
        func boolButtonLoader(isIconButton: Bool, targetButton: UIButton, key: String, trueOption: String, falseOption: String) {
            let buttonSetting = NSNumber(value: defaults.bool(forKey: key)).intValue
            if isIconButton == true {
                buttonSetting == 1 ? (targetButton.setImage(UIImage(named: trueOption), for: .normal)) : (targetButton.setImage(UIImage(named: falseOption), for: .normal))
            } else {
                buttonSetting == 1 ? (targetButton.setTitle(trueOption, for: .normal)) : (targetButton.setTitle(falseOption, for: .normal))
            }
        }
        
        boolButtonLoader(isIconButton: false, targetButton: godModeButton, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
        boolButtonLoader(isIconButton: true, targetButton: soundButton, key: "Volume On Setting", trueOption: "Volume_On_Icon.pdf", falseOption: "Volume_Mute_Icon.pdf")
        boolButtonLoader(isIconButton: true, targetButton: stepOrPlayPauseButton, key: "Step Mode On Setting", trueOption: "Step_Icon.pdf", falseOption: "Play_Icon.pdf")
        boolButtonLoader(isIconButton: true, targetButton: darkOrLightModeButton, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon.pdf", falseOption: "Light_Mode_Icon.pdf")
    }
    
    let colors = [ // Range 0 to 19
        UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00), // White Clouds
        UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.00), // White Silver
        UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.00), // Light Gray Concrete
        UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.00), // Light Gray Asbestos
        UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
        UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00), // Dark Gray Green Sea
        UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.00), // Purple Amethyst
        UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.00), // Purple Wisteria
        UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.00), // Blue Peter River
        UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.00), // Blue Belize Hole
        UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.00), // Green Emerald
        UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.00), // Green Nephritis
        UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.00), // Teal Turquoise
        UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.00), // Teal GreenSea
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
        cell2.myImagee.layer.cornerRadius = cell2.myImagee.frame.size.width/4
        cell2.myImagee.clipsToBounds = true
        cell2.selectionStyle = UITableViewCell.SelectionStyle.none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell2.myImagee.tag = indexPath.row
        cell2.myImagee.isUserInteractionEnabled = true
        cell2.myImagee.addGestureRecognizer(tapGestureRecognizer)
        return cell2
    }
    
    // method to run when imageview is tapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        var colorID = (legendData[imgView.tag][1] as! Int) + 1
        if colorID == colors.count {colorID = 0}
        legendData[imgView.tag][1] = colorID
        defaults.set(legendData, forKey: "legendPrefences")
        defaults.setColor(color: colors[(legendData[imgView.tag][1] as? Int)!], forKey: legendData[imgView.tag][0] as! String)
        tableVIew.reloadData()
    }
    
    func boolButtonResponder(_ sender: UIButton, isIconButton: Bool, key: String, trueOption: String, falseOption: String) {
        sender.tag = NSNumber(value: defaults.bool(forKey: key)).intValue
        if isIconButton {
            // If on when clicked, change to off, and vise versa.
            if sender.tag == 1 {
                sender.setImage(UIImage(named: falseOption), for: .normal)
                sender.tag = 0
            } else {
                sender.setImage(UIImage(named: trueOption), for: .normal)
                sender.tag = 1
            }
        } else {
            // If on when clicked, change to off, and vise versa.
            if sender.tag == 1 {
                sender.setTitle(falseOption, for: .normal)
                sender.tag = 0
            } else {
                sender.setTitle(trueOption, for: .normal)
                sender.tag = 1
            }
        }
        defaults.set(Bool(truncating: sender.tag as NSNumber), forKey: key)
    }
    
    func fourOptionButtonResponder(_ sender: UIButton, isSpeedButton: Bool, key: String, optionArray: [String]) {
        sender.tag = defaults.integer(forKey: key)
        if isSpeedButton {gameMoveSpeed = defaults.float(forKey: "Snake Move Speed")}
        if sender.tag == 1 {
            sender.setTitle(optionArray[1], for: .normal)
            sender.tag = 2
            if isSpeedButton {gameMoveSpeed = 0.10}
        } else if sender.tag == 2 {
            sender.setTitle(optionArray[2], for: .normal)
            sender.tag = 3
            if isSpeedButton {gameMoveSpeed = 0.01}
        } else if sender.tag == 3 {
            sender.setTitle(optionArray[3], for: .normal)
            sender.tag = 5
            if isSpeedButton {gameMoveSpeed = 0.50}
        } else {
            sender.setTitle(optionArray[0], for: .normal)
            sender.tag = 1
            if isSpeedButton {gameMoveSpeed = 0.25}
        }
        defaults.set(sender.tag, forKey: key)
        if isSpeedButton {defaults.set(gameMoveSpeed, forKey: "Snake Move Speed")}
    }
    
    @IBAction func clearAllButton(_ sender: UIButton) {
        sender.setTitle("Gameboard Cleared", for: .normal)
        clearBarrierButton.setTitle("Barriers Cleared", for: .normal)
        clearPathButton.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear All Setting")
    }
    
    @IBAction func clearBarrierButtonPressed(_ sender: UIButton) {
        sender.setTitle("Barriers Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Barrier Setting")
    }
    
    @IBAction func clearPathButtonPressed(_ sender: UIButton) {
        sender.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Path Setting")
    }
    
    @IBAction func snakeSpeedButtonPressed(_ sender: UIButton) {
        let options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonResponder(sender, isSpeedButton: true, key: "Snake Speed Setting", optionArray: options)
    }
    
    @IBAction func foodWeightButtonPressed(_ sender: UIButton) {
        let options = ["Food Weight: 1", "Food Weight: 2", "Food Weight: 3", "Food Weight: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Weight Setting", optionArray: options)
    }
    
    @IBAction func foodCountButtonPressed(_ sender: UIButton) {
        let options = ["Food Count: 1", "Food Count: 2", "Food Count: 3", "Food Count: 5"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Food Count Setting", optionArray: options)
    }
    
    @IBAction func godButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: false, key: "God Button On Setting", trueOption: "God Mode: On", falseOption: "God Mode: Off")
    }
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Volume On Setting", trueOption: "Volume_On_Icon.pdf", falseOption: "Volume_Mute_Icon.pdf")
    }
    
    @IBAction func stepButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Step Mode On Setting", trueOption: "Step_Icon.pdf", falseOption: "Play_Icon.pdf")
    }
    
    @IBAction func darkModeButtonPressed(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon.pdf", falseOption: "Light_Mode_Icon.pdf")
        defaults.integer(forKey: "Dark Mode On Setting") == 1 ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
}
