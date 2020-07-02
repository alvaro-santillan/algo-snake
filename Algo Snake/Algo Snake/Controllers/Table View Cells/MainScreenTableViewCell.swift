//
//  ViewControllerTableViewCell.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/14/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var guaranteedIconSquare: UIImageView!
    @IBOutlet weak var optimalIconSquare: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
