//
//  ViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

var currentSwitch = 0
var selectedOpertaions = ["plus": true, "minus": false, "multiplication": false, "division": false, "fraction": false, "decimal": false]
var selectedButtons = ["plus": true, "minus": false, "multiplication": false, "division": false, "fraction": false, "decimal": false]

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func checkEmptySelection() {
        print("$\(selectedOpertaions)")
        if selectedOpertaions.values.contains(true) == false {
            let alert = UIAlertController(title: "Something is missing...", message: "Please select at least one operation.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    
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
    
    let pagePickersPage = ["1 Page", "2 Pages", "3 Pages", "4 Pages", "5 Pages", "6 Pages", "7 Pages", "8 Pages", "9 Pages", "10 Pages"]
    let pagePickrsQuestion = [", 20 Questions", ", 40 Questions", ", 60 Questions", ", 80 Questions", ", 100 Questions", ", 120 Questions", ", 140 Questions", ", 160 Questions", ", 180 Questions", ", 200 Questions"]
    
    @IBOutlet weak var pagePicker: UIPickerView!
    @IBOutlet weak var buttonPlusColor: UIButton!
    @IBOutlet weak var buttonMinusColor: UIButton!
    @IBOutlet weak var buttonMultiplicationColor: UIButton!
    @IBOutlet weak var buttonDivisionColor: UIButton!
    @IBOutlet weak var buttonFractionColor: UIButton!
    @IBOutlet weak var buttonDecimalColor: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor(red: 76.0/255.0, green: 153.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        pickerLabel.text = pagePickersPage[row] + pagePickrsQuestion[row]
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 18)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pagePickersPage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPageNumber = row + 1
    }
    
    
    @IBAction func buttonPlus(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func buttonMinus(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func buttonMul(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    @IBAction func buttonDiv(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func buttonFraction(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func buttonDec(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        }
    }
    
    
    // GENERATE BUTTON
    @IBAction func generatePressed(_ sender: Any) {
        checkSelectedButtons()
        checkEmptySelection()
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
        Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Generate Button Pressed"])
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCreateWorkSheet" {
            let destinationVC =  segue.destination as! WorksheetVC
            numberOperation = selectedOperation
            destinationVC.pageNumber = selectedPageNumber
            difficulty = selectedDifficulty
            
        }
    }
    
// ****  CHECK BUTTONS
    func checkSelectedButtons() {
        
        selectedOpertaions = ["plus": false, "minus": false, "multiplication": false, "division": false, "fraction": false, "decimal": false]
        selectedButtons = ["plus": false, "minus": false, "multiplication": false, "division": false, "fraction": false, "decimal": false]
        
        if buttonPlusColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "plus")
            selectedButtons.updateValue(true, forKey: "plus")
        }
        if buttonMinusColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "minus")
            selectedButtons.updateValue(true, forKey: "minus")
        }
        if buttonMultiplicationColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "multiplication")
            selectedButtons.updateValue(true, forKey: "multiplication")
        }
        if buttonDivisionColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "division")
            selectedButtons.updateValue(true, forKey: "division")
        }
        if buttonFractionColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "fraction")
            selectedButtons.updateValue(true, forKey: "fraction")
        }
        if buttonDecimalColor.isSelected {
            selectedOpertaions.updateValue(true, forKey: "decimal")
            selectedButtons.updateValue(true, forKey: "decimal")
        }
        print("$*Check Buttons Result, Button: \(selectedOpertaions)")
        print("$*Operation: \(selectedOpertaions)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonPlusColor.backgroundColor = UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        buttonPlusColor.isSelected = true
        print("$selectedOperation:\(selectedOpertaions), $worksheetAnswerCode: \(worksheetAnswerCode)")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


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
