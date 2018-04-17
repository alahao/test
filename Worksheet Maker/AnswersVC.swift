//
//  AnswersVC.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/16/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import UIKit
import GameKit

class AnswersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOpertaionSign = ""
    let question = questionArray()
    let operation = Operation()
    var cellNumber = 2
    var answerCodeLText = ""
    var answerCodeRText = ""
    var pageNumber = 1
    var cellHeight = 40
 
    @IBOutlet weak var answerTableView: UITableView!
    
    @IBOutlet weak var answerCodeL: UITextField!
    @IBOutlet weak var answerCodeR: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerCodeL.text = answerCodeLText
        answerCodeR.text = answerCodeRText
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAnswerButton(_ sender: Any) {
        answerSeed.seed = UInt64(answerCodeR.text!)!
        print("$seed number is \(answerSeed.seed)")
        answerTableView.delegate = self
        answerTableView.dataSource = self
        question.questionArray.removeAll()
        generatingPage()
        self.answerTableView.reloadData()
    }
    
    
        // 2. GENERATE 20 lines of questions per page
        func generatingPage() {
            pageNumber = Int(answerCodeL.text!.dropFirst())!
            if answerCodeL.text!.prefix(1) == "A" {
                numberOperation = "Addition"
            } else if answerCodeL.text!.prefix(1) == "B" {
                numberOperation = "Subtraction"
            } else if answerCodeL.text!.prefix(1) == "C" {
                numberOperation = "Multiplication"
            } else if answerCodeL.text!.prefix(1) == "D" {
                numberOperation = "Division"
            } else if answerCodeL.text!.prefix(1) == "E" {
                numberOperation = "Fraction"
            } else if answerCodeL.text!.prefix(1) == "F" {
                numberOperation = "Decimal"
            } else if answerCodeL.text!.prefix(1) == "G" {
                numberOperation = "Mixed"
            }
            
            print("$pageNumber is \(pageNumber)")
            print("$First Letter is \(answerCodeL.text!.prefix(0))")
            print("$AssignedO is \(numberOperation)")
            cellNumber = 20 * pageNumber
            question.questionArray.removeAll()
            questionNumber = 0
            
            for _ in 1...cellNumber {
                assignOpeartion()
             
            }
        }
        
        // 3. ASSIGN OPERATION TYPE, Send to Opertaion Class to calculate
        func assignOpeartion() {
            if numberOperation == "Addition" { // Addition A+B=C
                numberOpertaionSign = "+"
                question.questionArray.append(operation.CalculatePMTD())
            } else if numberOperation == "Subtraction" { // Subtraction A-B=C
                numberOpertaionSign = "−"
                question.questionArray.append(operation.CalculatePMTD())
            } else if numberOperation == "Multiplication" { // Multiplication A*B=C
                numberOpertaionSign = "×"
                question.questionArray.append(operation.CalculatePMTD())
            } else if numberOperation == "Division" { // Division C/A=B
                numberOpertaionSign = "÷"
                question.questionArray.append(operation.CalculatePMTD())
            } else if numberOperation == "Fraction" { // Fraction
                question.questionArray = operation.OperationFraction()
            } else if numberOperation == "Decimal" { //Decimal
                question.questionArray = operation.OperationDecimal()
            } else if numberOperation == "Mixed" { // Mixed 1/4 + 2/4 = 3/4
                question.questionArray.append(operation.CalculatePMTD())
            }
        }
    
    
    // 4. CREATE TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerSheetCell", for: indexPath) as! TableViewAnswerCell
        
        cell.setLQN.text = String(describing: question.questionArray[indexPath.row][0])
        cell.setLQ.text = "\(question.questionArray[indexPath.row][1] + question.questionArray[indexPath.row][4])"
        cell.setRQN.text = String(describing: question.questionArray[indexPath.row][2])
        cell.setRQ.text = "\(question.questionArray[indexPath.row][3] + question.questionArray[indexPath.row][5])"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
