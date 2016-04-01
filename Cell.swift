//
//  Cell.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.myImage.image = nil
        self.statusImage.image = nil
    }

}
