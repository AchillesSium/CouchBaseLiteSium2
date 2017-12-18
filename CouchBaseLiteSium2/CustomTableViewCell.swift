//
//  CustomTableViewCell.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 18/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemText: UILabel!
    
    @IBOutlet weak var numberOfItemText: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
