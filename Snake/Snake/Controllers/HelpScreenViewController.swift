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
        loadUserData()
    }
    
    func loadUserData() {
        UserDefaults.standard.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }

    @IBAction func ReturnToSettingsButtonPressed(_ sender: UIButton) {self.dismiss(animated: true)}
    
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
