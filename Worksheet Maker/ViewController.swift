//
//  ViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

var currentSwitch = 0


@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var goToAnswer: UIBarButtonItem!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageQuestionLabel: UILabel!
    @IBAction func stepperAction(_ sender: UIStepper) {
        selectedPageNumber = Int(sender.value)
        if selectedPageNumber == 1 {
            pageLabel.text = "\(Int(sender.value)) PAGE"
        } else {
        pageLabel.text = "\(Int(sender.value)) PAGES"
        }
        pageQuestionLabel.text = "\(Int(sender.value) * 20) QUESTIONS TOTAL"
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentDifficulty(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedDifficulty = 0
            currentSwitch = 0
        case 1:
            selectedDifficulty = 1
            currentSwitch = 1
        case 2:
            selectedDifficulty = 2
            currentSwitch = 2
        default:
            break
        }
    }
    
    var selectedOperation = "+"
    var selectedPageNumber = 1
    var selectedOperationLabel = "Addition"
    var selectedDifficulty = 0
    
    @IBAction func buttonPlus(_ sender: Any) {
        selectedOperation = "Addition"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMinus(_ sender: Any) {
        selectedOperation = "Subtraction"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMul(_ sender: Any) {
        selectedOperation = "Multiplication"
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
        numberOperation = selectedOperation
        destinationVC.pageNumber = selectedPageNumber
        difficulty = selectedDifficulty
        
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

