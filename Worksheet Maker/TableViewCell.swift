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
    @IBOutlet weak var numberAnswerLabel: UILabel!
    @IBOutlet weak var numberThreeLabel: UILabel!
    @IBOutlet weak var numberAnswerTwoLabel: UILabel!
    
    @IBOutlet weak var RowNumber: UILabel!
    @IBOutlet weak var RowNumberTwo: UILabel!
    
    // Fraction
    @IBOutlet weak var fRowNumberOne: UILabel!

    @IBOutlet weak var oneLN: UILabel!
    @IBOutlet weak var oneLD: UILabel!
    @IBOutlet weak var oneRN: UILabel!
    @IBOutlet weak var oneRD: UILabel!
    
    @IBOutlet weak var fRowNumberTwo: UILabel!
    @IBOutlet weak var fAnswerOneNumber: UILabel!
    @IBOutlet weak var fAnswerOneR: UILabel!
    @IBOutlet weak var fAnswerOneD: UILabel!
    // End Fraction
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
