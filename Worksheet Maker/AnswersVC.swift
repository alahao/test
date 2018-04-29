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
    var pageNumber : Int? = 1
    var cellHeight = 40
 
    @IBOutlet weak var answerTableView: UITableView!
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var answerCodeL: UITextField!
    @IBOutlet weak var answerCodeR: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        answerCodeL.text = answerCodeLText
        answerCodeR.text = answerCodeRText
        errorMessage.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAnswerButton(_ sender: Any) {
        
        self.view.endEditing(true)
        
        enum codeError : Error {
            case invalidA
            case invalidPageNumber
            case invalidKey
            case invalidDifficulty
        }
        
        func checkError() throws {
            guard let userPageNumber = Int(answerCodeL.text!.dropFirst(2)), userPageNumber > 0, userPageNumber <= 20 else {
                throw codeError.invalidPageNumber
            }
            
            guard let userDifficulty = Int(answerCodeL.text!.dropFirst(1).prefix(1)), userDifficulty >= 0, userDifficulty < 3 else {
                throw codeError.invalidDifficulty
            }
            
            guard let userAnswerCodeR = answerCodeR.text, userAnswerCodeR != "" else {
                throw codeError.invalidKey
            }
            errorMessage.text = ""
            answerSeed?.seed = UInt64(answerCodeR.text!)!
            answerTableView.delegate = self
            answerTableView.dataSource = self
            question.questionArray.removeAll()
            pageNumber = Int(answerCodeL.text!.dropFirst(2))!
            difficulty = Int(answerCodeL.text!.dropFirst(1).prefix(1))!
        
            generatingPage()
            self.answerTableView.reloadData()
            print("good array is \(question.questionArray)")
        }
        
        do {
        try checkError()
        } catch codeError.invalidPageNumber {
            errorMessage.text = "Invalid code, please re-enter, eg. 112-12345"
            question.questionArray.removeAll()
            pageNumber = 0
            self.answerTableView.reloadData()
        } catch codeError.invalidDifficulty {
            errorMessage.text = "Invalid code, please re-enter, eg. 112-12345"
            question.questionArray.removeAll()
            pageNumber = 0
            self.answerTableView.reloadData()
        }  catch codeError.invalidKey {
            errorMessage.text = "Invalid code, please re-enter, eg. 112-12345"
            question.questionArray.removeAll()
            pageNumber = 0
            self.answerTableView.reloadData()
           
        } catch let otherError {
            errorMessage.text = "Invalid code, please re-enter, eg. 112-12345"
            question.questionArray.removeAll()
            pageNumber = 0
            self.answerTableView.reloadData()
            }
    }
    
    
        // 2. GENERATE 20 lines of questions per page
        func generatingPage() {
            print("generate page")
            if answerCodeL.text!.prefix(1) == "1" {
                numberOperation = "Addition"
            } else if answerCodeL.text!.prefix(1) == "2" {
                numberOperation = "Subtraction"
            } else if answerCodeL.text!.prefix(1) == "3" {
                numberOperation = "Multiplication"
            } else if answerCodeL.text!.prefix(1) == "4" {
                numberOperation = "Division"
            } else if answerCodeL.text!.prefix(1) == "5" {
                numberOperation = "Fraction"
            } else if answerCodeL.text!.prefix(1) == "6" {
                numberOperation = "Decimal"
            } else if answerCodeL.text!.prefix(1) == "7" {
                numberOperation = "Mixed"
            }
            
            cellNumber = 20 * pageNumber!
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
                question.questionArray.append(operation.OperationFraction())
            } else if numberOperation == "Decimal" { //Decimal
                question.questionArray.append(operation.OperationDecimal())
            } else if numberOperation == "Mixed" { // Mixed 1/4 + 2/4 = 3/4
                question.questionArray.append(operation.CalculatePMTD())
            }
        }
    
    
    // 4. CREATE TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber!
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

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
