//
//  ReportsListTableViewCell.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 3/18/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportsListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
