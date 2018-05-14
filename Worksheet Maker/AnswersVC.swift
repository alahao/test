//
//  AnswersVC.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/16/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import UIKit
import GameKit
import BarcodeScanner
import Flurry_iOS_SDK

class AnswersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOpertaionSign = ""
    let question = questionArray()
    let operation = Operation()
    var cellNumber = 2
    var pageNumber : Int? = 1
    var cellHeight = 50
    
    @IBOutlet weak var scanCode: UIButton!
    @IBOutlet weak var answerTableView: UITableView!
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var answerCodeL: UITextField!
    @IBOutlet weak var answerCodeR: UITextField!
    
    @IBAction func scanCodePush(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "ANSWERS"
        present(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("$A_worksheetAnswerCode: \(worksheetAnswerCode)")
        translatingSeed()
        generatingPage()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    // 2. GENERATE 10 lines of questions per page
    func generatingPage() {
        answerTableView.delegate = self
        answerTableView.dataSource = self
        
        print("generate page")
        
        
        question.questionArray.removeAll()
        questionNumber = 0
        print("$ new cell number is \(cellNumber)")
        cellNumber = 10 * pageNumber!
        if cellNumber > 0 {
            for _ in 1...cellNumber {
                
                func checkDuplicate() {
                    var resultArray = operation.runOperation()
                    print("$$$resultArray: \(resultArray)")
                    print("$$$questionArray: \(question.questionArray.suffix(2))")
                    if question.questionArray.suffix(20).contains(where: { $0.contains(resultArray[1]) }) || question.questionArray.suffix(20).contains(where: { $0.contains(resultArray[3]) }) || resultArray[1] == resultArray [3] {
                        print("$$$caught duplicated questions")
                        questionNumber = questionNumber - 2
                        checkDuplicate()
                    } else {
                        question.questionArray.append(resultArray)
                    }
                }
                checkDuplicate()
            }
            self.answerTableView.reloadData()
        }
        
    }
    
    
    // 4. CREATE TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 10 * pageNumber!
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerSheetCell", for: indexPath) as! TableViewAnswerCell
        //Display Anwsers
        
        // Display attributed Answer in bold
        func setAttributedString(questionArrayRow : Int, answerArrayRow : Int) -> NSAttributedString {
            let yourAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)]
            let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
            let attributedString = NSMutableAttributedString(string: String(question.questionArray[indexPath.row][questionArrayRow]), attributes: yourAttributes)
            let partTwo = NSMutableAttributedString(string: String(question.questionArray[indexPath.row][answerArrayRow]), attributes: yourOtherAttributes)
            attributedString.append(partTwo)
            
            return attributedString
        }
        
        cell.setLQN.text = String(describing: question.questionArray[indexPath.row][0])
        cell.setLQ.attributedText = setAttributedString(questionArrayRow: 1, answerArrayRow: 4)
        
        
        cell.setRQN.text = String(describing: question.questionArray[indexPath.row][2])
        cell.setRQ.attributedText = setAttributedString(questionArrayRow: 3, answerArrayRow: 5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    
}



// MARK: - BarcodeScannerCodeDelegate

extension AnswersVC: BarcodeScannerCodeDelegate {
    func translatingSeed() {
        if worksheetAnswerCode[0] == 1 {
            selectedOpertaions["plus"] = true
        } else {
            selectedOpertaions["plus"] = false
        }
        if worksheetAnswerCode[1] == 1 {
            selectedOpertaions["minus"] = true
        } else {
            selectedOpertaions["minus"] = false
        }
        if worksheetAnswerCode[2] == 1 {
            selectedOpertaions["multiplication"] = true
        } else {
            selectedOpertaions["multiplication"] = false
        }
        if worksheetAnswerCode[3] == 1 {
            selectedOpertaions["division"] = true
        } else {
            selectedOpertaions["division"] = false
        }
        if worksheetAnswerCode[4] == 1 {
            selectedOpertaions["fraction"] = true
        } else {
            selectedOpertaions["fraction"] = false
        }
        if worksheetAnswerCode[5] == 1 {
            selectedOpertaions["decimal"] = true
        } else {
            selectedOpertaions["decimal"] = false
        }
        pageNumber = Int((worksheetAnswerCode[7] * 10) + worksheetAnswerCode[8])
        print("Scanned Page Number is \(String(describing: pageNumber!))")
        difficulty = Int(worksheetAnswerCode[6])
        print("Scanned difficulty is \(String(describing: difficulty!))")
        answerSeed?.seed = UInt64(worksheetAnswerCode.suffix(5).map{String($0)}.joined())!
        print("$answerseed scanned is \(String(describing: answerSeed!.seed))")
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        worksheetAnswerCode = code.compactMap{Int(String($0))}
        print("$$worksheetAnswerCode: \(worksheetAnswerCode), code is: \(code)")
        
        
        enum codeError : Error {
            case invalidA
            case invalidPageNumber
            case invalidKey
            case invalidDifficulty
        }
        
        func checkError() throws {
            guard let ws : Int = worksheetAnswerCode.count, ws > 13 && ws < 15 else {
                print("$$error code count")
                throw codeError.invalidKey
            }
            
            guard let userPageNumber = Int?((worksheetAnswerCode[7] * 10) + worksheetAnswerCode[8]), userPageNumber > 0 && userPageNumber <= 10 else {
                print("$$error pageNumber")
                throw codeError.invalidPageNumber
            }
            
            guard let userDifficulty = Int?(worksheetAnswerCode[6]), userDifficulty >= 0 && userDifficulty < 3 else {
                print("$$error difficulty")
                throw codeError.invalidDifficulty
            }
            
            translatingSeed()
            
            print("Barcode Data: \(code)")
            print("Symbology Type: \(type)")
            print("$Scanned worksheetAnswerCode is \(worksheetAnswerCode)")
            
            generatingPage()
            
            //Pl,Mi,Mu,Di,Fr,De
            var logOperation = [String]()
            if selectedOpertaions["plus"] == true {
                logOperation.append("Pl")
            }
            if selectedOpertaions["minus"] == true {
                logOperation.append("Mi")
            }
            if selectedOpertaions["multiplication"] == true {
                logOperation.append("Mu")
            }
            if selectedOpertaions["division"] == true {
                logOperation.append("Di")
            }
            if selectedOpertaions["fraction"] == true {
                logOperation.append("Fr")
            }
            if selectedOpertaions["decimal"] == true {
                logOperation.append("De")
            }
            
            let printParams = ["Difficulty": String(difficulty!), "Page Number": String(pageNumber!), "Seed": worksheetAnswerCode.suffix(5).map{String($0)}.joined(), "Operation": logOperation.map{String($0)}.joined(separator: " ")]
            
            Flurry.logEvent("Scanned Answer Code", withParameters: printParams)
            Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Worksheet Scanned"])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                controller.dismiss(animated: true, completion: nil)
            }

        }
        
        
        do {
            try checkError()
        } catch codeError.invalidPageNumber {
            print("$invalidPageNumber")
            Flurry.logEvent("Event", withParameters: ["Errors" : "Scan error, invalidPageNumber"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controller.resetWithError(message: "Invalid Barcode, please try again.")
            }
            worksheetAnswerCode = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            question.questionArray.removeAll()
            
        } catch codeError.invalidDifficulty {
            print("$invalidDifficulty")
            Flurry.logEvent("Event", withParameters: ["Errors" : "Scan error, invalidDifficulty"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controller.resetWithError(message: "Invalid Barcode, please try again.")            }
            worksheetAnswerCode = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            question.questionArray.removeAll()
            
        }  catch codeError.invalidKey {
            print("$invalidKey")
            Flurry.logEvent("Event", withParameters: ["Errors" : "Scan error, wrong number of code digits"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controller.resetWithError(message: "Invalid Barcode, please try again.")
            }
            worksheetAnswerCode = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            question.questionArray.removeAll()
            
            
        } catch let otherError {
            print("$otherError")
            Flurry.logEvent("Event", withParameters: ["Errors" : "Scan error, otherError"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controller.resetWithError(message: "Invalid Barcode, please try again.")
            }
            worksheetAnswerCode = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            question.questionArray.removeAll()
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension AnswersVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print("$error: \(error)")
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension AnswersVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
