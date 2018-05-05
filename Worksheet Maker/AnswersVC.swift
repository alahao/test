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

class AnswersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOpertaionSign = ""
    let question = questionArray()
    let operation = Operation()
    var cellNumber = 2
    var pageNumber : Int? = 1
    var cellHeight = 40
    
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
        //        worksheetAnswerCode = stringSeedOperation + String(difficulty!) + String(format: "%02d", pageNumber) + "\(Int(answerSeedNumber))
        generatingPage()
        
        //        let viewController = makeBarcodeScannerViewController()
        //        viewController.title = "ANSWER"
        //        present(viewController, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    // 2. GENERATE 10 lines of questions per page
    func generatingPage() {
        answerTableView.delegate = self
        answerTableView.dataSource = self
        
        print("generate page")
        
        localAssignOperation()
        pageNumber = Int((worksheetAnswerCode[7] * 10) + worksheetAnswerCode[8])
        print("Scanned Page Number is \(String(describing: pageNumber!))")
        difficulty = Int(worksheetAnswerCode[6])
        print("Scanned difficulty is \(String(describing: difficulty!))")
        answerSeed?.seed = UInt64(worksheetAnswerCode.suffix(5).map{String($0)}.joined())!
        print("$answerseed scanned is \(String(describing: answerSeed!.seed))")
            
            question.questionArray.removeAll()
            questionNumber = 0
            print("$ new cell number is \(cellNumber)")
            cellNumber = 10 * pageNumber!
        if cellNumber > 0 {
            for _ in 1...cellNumber {
            question.questionArray.append(operation.runOperation())
            
            }
            self.answerTableView.reloadData()
        }}
    
    
    // 4. CREATE TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 10 * pageNumber!
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerSheetCell", for: indexPath) as! TableViewAnswerCell
        //Display Anwsers
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
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerController {
        let viewController = BarcodeScannerController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    
}

extension UIViewController {
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


// MARK: - BarcodeScannerCodeDelegate

extension AnswersVC: BarcodeScannerCodeDelegate {
    func localAssignOperation() {
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
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        worksheetAnswerCode = code.compactMap{Int(String($0))}
        
        enum codeError : Error {
            case invalidA
            case invalidPageNumber
            case invalidKey
            case invalidDifficulty
        }
        
        func checkError() throws {
            guard let userPageNumber = pageNumber, userPageNumber > 0, userPageNumber <= 10 else {
                throw codeError.invalidPageNumber
            }
            
            guard let userDifficulty = Int?(worksheetAnswerCode[6]), userDifficulty >= 0, userDifficulty < 3 else {
                print("error difficulty")
                throw codeError.invalidDifficulty
            }
            
            print("Barcode Data: \(code)")
            print("Symbology Type: \(type)")
            print("$Scanned worksheetAnswerCode is \(worksheetAnswerCode)")
            
            generatingPage()
            
            controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                controller.resetWithError()
            }
        }
        
        
        do {
            try checkError()
        } catch codeError.invalidPageNumber {
            print("$invalidPageNumber")
            controller.resetWithError()
            worksheetAnswerCode.removeAll()
            question.questionArray.removeAll()
            
        } catch codeError.invalidDifficulty {
            print("$invalidDifficulty")
            controller.resetWithError()
            worksheetAnswerCode.removeAll()
            question.questionArray.removeAll()
            
        }  catch codeError.invalidKey {
            print("$invalidKey")
            controller.resetWithError(message: "Error message")
            worksheetAnswerCode.removeAll()
            question.questionArray.removeAll()
            
            
        } catch let otherError {
            print("$otherError")
            controller.resetWithError(message: "Error message")
            worksheetAnswerCode.removeAll()
            question.questionArray.removeAll()
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension AnswersVC: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension AnswersVC: BarcodeScannerDismissalDelegate {
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
