//
//  ViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageQuestionLabel: UILabel!
    @IBAction func stepperAction(_ sender: UIStepper) {
        selectedPageNumber = Int(sender.value)
        pageLabel.text = "\(Int(sender.value)) Pages"
        pageQuestionLabel.text = "\(Int(sender.value) * 20) Questions"
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentDifficulty(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedDifficulty = 0
        case 1:
            selectedDifficulty = 1
        case 2:
            selectedDifficulty = 2
        default:
            break
        }
    }
    
    var selectedOperation = "+"
    var selectedPageNumber = 1
    var selectedOperationLabel = "Plus"
    var selectedDifficulty = 0
    
    @IBAction func buttonPlus(_ sender: Any) {
        selectedOperation = "Plus"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMinus(_ sender: Any) {
        selectedOperation = "Minus"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMul(_ sender: Any) {
        selectedOperation = "Times"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    @IBAction func buttonDiv(_ sender: Any) {
        selectedOperation = "Division"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonFraction(_ sender: Any) {
        selectedOperation = "Fraction"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonDec(_ sender: Any) {
        selectedOperation = "Decimal"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMix(_ sender: Any) {
        selectedOperation = "Mixed"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCreateWorkSheet" {
        let destinationVC =  segue.destination as! WorksheetVC
        destinationVC.numberOperation = selectedOperation
        destinationVC.pageNumber = selectedPageNumber
        destinationVC.difficulty = selectedDifficulty
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

