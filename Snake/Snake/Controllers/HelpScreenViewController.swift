//
//  HelpViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var backToPreviousScreenButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Views
        leftView.layer.shadowColor = UIColor.darkGray.cgColor
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = .zero
        
        // Buttons
        rateButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        rateButton.layer.cornerRadius = 6
        rateButton.layer.shadowColor = UIColor.darkGray.cgColor
        rateButton.layer.shadowRadius = 5
        rateButton.layer.shadowOpacity = 0.2
        rateButton.layer.shadowOffset = .zero
        backToPreviousScreenButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        backToPreviousScreenButton.layer.cornerRadius = 6
        backToPreviousScreenButton.layer.shadowColor = UIColor.darkGray.cgColor
        backToPreviousScreenButton.layer.shadowRadius = 5
        backToPreviousScreenButton.layer.shadowOpacity = 0.2
        backToPreviousScreenButton.layer.shadowOffset = .zero
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        homeButton.layer.cornerRadius = 6
        homeButton.layer.shadowColor = UIColor.darkGray.cgColor
        homeButton.layer.shadowRadius = 5
        homeButton.layer.shadowOpacity = 0.2
        homeButton.layer.shadowOffset = .zero
    }

    @IBAction func personalWebisteButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://alvarosantillan.com/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func rateButton(_ sender: UIButton) {
        print("Rate pushed")
    }
}
