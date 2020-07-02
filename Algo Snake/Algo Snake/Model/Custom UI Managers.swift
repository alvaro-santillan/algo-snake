//
//  Custom UI Managers.swift
//  Snake
//
//  Created by Álvaro Santillan on 6/15/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class GeneralUIButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 6
        self.imageView?.contentMode = .scaleAspectFit
    }
}

class TextUIButton: GeneralUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.2
    }
}

class IconUIButton: GeneralUIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        self.layer.shadowOpacity = 0.5
    }
}

class LeftUIView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
    }
}
    
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

func boolButtonLoader(isIconButton: Bool, targetButton: UIButton, key: String, trueOption: String, falseOption: String) {
    let buttonSetting = UserDefaults.standard.bool(forKey: key)
    if isIconButton {
        buttonSetting ? (targetButton.setImage(UIImage(named: trueOption), for: .normal)) : (targetButton.setImage(UIImage(named: falseOption), for: .normal))
    } else {
        buttonSetting ? (targetButton.setTitle(trueOption, for: .normal)) : (targetButton.setTitle(falseOption, for: .normal))
    }
}

func fourOptionButtonLoader(targetButton: UIButton, key: String, optionArray: [String]) {
    let buttonSetting = UserDefaults.standard.integer(forKey: key)
    if buttonSetting == 1 {
        targetButton.setTitle(optionArray[0], for: .normal)
    } else if buttonSetting == 2 {
        targetButton.setTitle(optionArray[1], for: .normal)
    } else if buttonSetting == 3 {
        targetButton.setTitle(optionArray[2], for: .normal)
    } else {
        targetButton.setTitle(optionArray[3], for: .normal)
    }
}

func boolButtonResponder(_ sender: UIButton, isIconButton: Bool, key: String, trueOption: String, falseOption: String) {
    sender.tag = NSNumber(value: UserDefaults.standard.bool(forKey: key)).intValue
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
    UserDefaults.standard.set(Bool(truncating: sender.tag as NSNumber), forKey: key)
    changeNotifier()
}

func fourOptionButtonResponder(_ sender: UIButton, isSpeedButton: Bool, key: String, optionArray: [String]) {
    var gameMoveSpeed = Float()
    sender.tag = UserDefaults.standard.integer(forKey: key)

    if isSpeedButton {gameMoveSpeed = UserDefaults.standard.float(forKey: "Snake Move Speed")}
    if sender.tag == 1 {
        sender.setTitle(optionArray[1], for: .normal)
        sender.tag = 2
        if isSpeedButton {gameMoveSpeed = 0.25}
    } else if sender.tag == 2 {
        sender.setTitle(optionArray[2], for: .normal)
        sender.tag = 3
        if isSpeedButton {gameMoveSpeed = 0.10}
    } else if sender.tag == 3 {
        sender.setTitle(optionArray[3], for: .normal)
        sender.tag = 5
        if isSpeedButton {gameMoveSpeed = 0.01}
    } else {
        sender.setTitle(optionArray[0], for: .normal)
        sender.tag = 1
        if isSpeedButton {gameMoveSpeed = 0.50}
    }
    
    UserDefaults.standard.set(sender.tag, forKey: key)
    if isSpeedButton {UserDefaults.standard.set(gameMoveSpeed, forKey: "Snake Move Speed")}
    changeNotifier()
}

func colorPaletteManager(cellText: (String?)) -> ([UIColor]) {
    if cellText == "Gameboard" {
        return UserDefaults.standard.bool(forKey: "Dark Mode On Setting") ? darkBackgroundColors : lightBackgroundColors
    } else {
        return colors
    }
}

func changeNotifier() {
    UserDefaults.standard.set(true, forKey: "Settings Value Modified")
}
