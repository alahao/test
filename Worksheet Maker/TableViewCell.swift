//
//  TableViewCell.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var numberOneLabel: UILabel!
    @IBOutlet weak var numberThreeLabel: UILabel!
 
    @IBOutlet weak var RowNumber: UILabel!
    @IBOutlet weak var RowNumberTwo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
