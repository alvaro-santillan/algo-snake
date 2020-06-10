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
        if UserDefaults.standard.integer(forKey: "darkOrLightButton") == 0 {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
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

    @IBAction func ReturnToSettingsButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func linkedInButtonPressed(_ sender: UIButton) {
        var webURL = "https://www.linkedin.com/in/álvarosantillan"
        webURL = webURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        var appURL = "linkedin://in/álvarosantillan"
        appURL = appURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        if UIApplication.shared.canOpenURL(URL(string: appURL)! as URL) {
            UIApplication.shared.open(URL(string: appURL)! as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: webURL)! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func personalWebisteButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://alvarosantillan.com/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func githubButtonPressed(_ sender: UIButton) {
        var webURL = "https://github.com/AFSM1995"
        webURL = webURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        UIApplication.shared.open(URL(string: webURL)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func rateButton(_ sender: UIButton) {
        var webURL = "https://www.linkedin.com/in/álvarosantillan"
        webURL = webURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        let appID = "1287000522"
        var appURL = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        appURL = appURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        if UIApplication.shared.canOpenURL(URL(string: appURL)! as URL) {
            UIApplication.shared.open(URL(string: appURL)! as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: webURL)! as URL, options: [:], completionHandler: nil)
        }
    }
}
