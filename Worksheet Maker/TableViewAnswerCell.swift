//
//  TableViewCell.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

class TableViewAnswerCell: UITableViewCell {
  
    @IBOutlet weak var setLQN: UILabel!
    @IBOutlet weak var setLQ: UILabel!
    
    @IBOutlet weak var setRQN: UILabel!
    @IBOutlet weak var setRQ: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
