//
//  SettingsScreenTableViewCell.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsScreenTableViewCell: UITableViewCell {
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var myImagee: UIImageView!
    @IBOutlet weak var myLabell: UILabel!
    @IBOutlet weak var myImage22: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
