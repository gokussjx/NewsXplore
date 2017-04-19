//
//  ReportSourceTableViewCell.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/18/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceTitle: UILabel!
    @IBOutlet weak var sourceDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
