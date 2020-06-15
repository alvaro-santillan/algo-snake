//
//  Custom UI Styling.swift
//  Snake
//
//  Created by Álvaro Santillan on 6/15/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsUIButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 6
        self.imageView?.contentMode = .scaleAspectFit
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

class LeftUIView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
    }
}
