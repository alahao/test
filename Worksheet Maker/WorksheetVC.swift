//
//  WorksheetVC.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import SimplePDF

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var worksheetTableView: UITableView!
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswerOne = 0
    var numberOperation = ""
    var numberThree = 0
    var numberFour = 0
    var numberAnswerTwo = 0
    var numberOperationTwo = ""
    
    // Fraction
    var fractionOneLN = 0
    var fractionOneLD = 0
    var fractionOneRN = 0
    var fractionOneRD = 0
    var fractionOneAnswerN = 0
    var fractionOneAnswerD = 0
    var fractionTwoLN = 0
    var fractionTwoLD = 0
    var fractionTwoRN = 0
    var fractionTwoRD = 0
    var fractionTwoAnswerN = 0
    var fractionTwoAnswerD = 0
    // End Fraction
    
    var operationName = ""
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 40

    var headerCells = [21,42,63,84,100,120,140,160,180,200,220,240,260,280,300]
    
    var questionNumber = 0
    var questionArray = [["Quesion 1","Quesion 2","Answers1", "Answers2"]]
    var questionFractionArray = [[0,0,0,0,0,0,0,0,0,0,0,0]]
    
    var currentPageArrayStart = 0

    //Share Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        print("# Button Pressed")
        loadSimplePDF()
    //savePdfDataWithTableView(tableView: worksheetTableView)
        loadPDFAndShare()
    }
    
    //Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(WorksheetVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        removeAllArray()
        self.worksheetTableView.reloadData()
        refreshControl.endRefreshing()
    }

    func removeAllArray() {
        questionArray.removeAll()
    }
    
    func generatingPage() {
        cellNumber = 20 * pageNumber
        removeAllArray()
        for _ in 1...cellNumber {
            operationType()
//            print("$ Running generating Page")
        }
    }
    
    func generatingRandomNumber(numberAMin: UInt32, numberAMax: UInt32, numberBMin: UInt32, numberBMax: UInt32, operation: String) {
        if operation == "plus" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberAnswerOne = numberOne + numberTwo
            numberAnswerTwo = numberThree + numberFour
        } else if operation == "minus" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(UInt32(numberOne) - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(UInt32(numberThree) - numberBMin) + numberBMin)
            numberAnswerOne = numberOne - numberTwo
            numberAnswerTwo = numberThree - numberFour
        } else if operation == "multiplication" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberAnswerOne = numberOne * numberTwo
            numberAnswerTwo = numberThree * numberFour
        } else if operation == "division" {
            numberTwo = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberAnswerOne = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberFour = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberAnswerTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberOne = numberAnswerOne * numberTwo
            numberThree = numberAnswerTwo * numberFour
        }
        
        questionArray.append(["\(numberOne) \(numberOperation) \(numberTwo) = ", "\(numberThree) \(numberOperation) \(numberFour) = ", "\(numberAnswerOne) "," \(numberAnswerTwo)"])
//        print("$ Running questionArray Append = \(questionArray)")
    }
    
    func generatingRandomFraction(nLMin: UInt32, nLMax: UInt32, dLMin: UInt32, dLMax: UInt32, nRMin: UInt32, nRMax: UInt32, dRMin: UInt32, dRMax: UInt32) {
        fractionOneLN = Int(arc4random_uniform(nLMax - nLMin) + nLMin)
        fractionOneLD = Int(arc4random_uniform(dLMax - dLMin) + dLMin)
        fractionOneRN = Int(arc4random_uniform(nRMax - nRMin) + nRMin)
        fractionOneRD = Int(arc4random_uniform(dRMax - dRMin) + dRMin)
        
        fractionTwoLN = Int(arc4random_uniform(nLMax - nLMin) + nLMin)
        fractionTwoLD = Int(arc4random_uniform(dLMax - dLMin) + dLMin)
        fractionTwoRN = Int(arc4random_uniform(nRMax - nRMin) + nRMin)
        fractionTwoRD = Int(arc4random_uniform(dRMax - dRMin) + dRMin)
        
        fractionOneAnswerN = fractionOneLN * fractionOneRD + fractionOneRN * fractionOneLD
        fractionOneAnswerD = fractionOneLD * fractionOneRD
        
        fractionTwoAnswerN = fractionTwoLN * fractionTwoRD + fractionTwoRN * fractionTwoLD
        fractionTwoAnswerD = fractionTwoLD * fractionTwoRD
        
        questionFractionArray.append([fractionOneLN, fractionOneLD, fractionOneRN, fractionOneRD, fractionTwoLN, fractionTwoLD, fractionTwoRN, fractionTwoRD, fractionOneAnswerN, fractionOneAnswerD, fractionTwoAnswerN, fractionTwoAnswerD])
    }
    
    //Operations
    func OperationPlus() { // A+B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99, operation: "plus")}
    func OperationMinus() { // A-B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99, operation: "minus")}
    func OperationMul() { // A*B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99, operation: "multiplication")}
    func OperationDivision() { // C/A=B
        generatingRandomNumber(numberAMin: 2, numberAMax: 9, numberBMin: 2, numberBMax: 9, operation: "division")}
    func OperationFraction() { //
        generatingRandomFraction(nLMin: 2, nLMax: 9, dLMin: 2, dLMax: 9, nRMin: 2, nRMax: 9, dRMin: 2, dRMax: 9)
    }
    
    func operationType() {
        if numberOperation == "+" {
            OperationPlus()
        } else if numberOperation == "-" {
            OperationMinus()
        } else if numberOperation == "X" {
            OperationMul()
        } else if numberOperation == "/" {
            OperationDivision()
        } else if numberOperation == "Fraction" {
            OperationFraction()
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generatingPage()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
    }
    
    // Tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOperation == "Fraction" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCellFraction", for: indexPath) as! TableViewCell
            cell.fRowNumberOne.text = String(indexPath.row * 2 + 1)
            cell.fRowNumberTwo.text = String(indexPath.row * 2 + 2)
            cell.oneLN.text = String(describing: questionFractionArray[indexPath.row][0])
            cell.oneLD.text = String(describing: questionFractionArray[indexPath.row][1])
            cell.oneRN.text = String(describing: questionFractionArray[indexPath.row][2])
            cell.oneRD.text = String(describing: questionFractionArray[indexPath.row][3])
            cell.fAnswerOneR.text = String(describing: questionFractionArray[indexPath.row][8])
            cell.fAnswerOneD.text = String(describing: questionFractionArray[indexPath.row][9])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
            cell.RowNumber.text = String(indexPath.row * 2 + 1)
            cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
            cell.numberOneLabel.text = String(describing: questionArray[indexPath.row][0])
            cell.numberAnswerLabel.text = String(describing: questionArray[indexPath.row][2])
            cell.numberThreeLabel.text = String(describing: questionArray[indexPath.row][1])
            return cell
        }
    }
    
    //SIMPLE PDF
    func loadSimplePDF() {

    let A4paperSize = CGSize(width: 595, height: 842)
    let pdf = SimplePDF(pageSize: A4paperSize)

    pdf.addText("Plus Worksheet")
    // or
    // pdf.addText("Hello World!", font: myFont, textColor: myTextColor)
    let tableDef = TableDefinition(alignments: [.left, .left, .center, .center],
                                       columnWidths: [240, 240, 30, 30],
                                       fonts: [UIFont.systemFont(ofSize: 20),UIFont.systemFont(ofSize: 20),UIFont.systemFont(ofSize: 10),UIFont.systemFont(ofSize: 10)],
                                       textColors: [UIColor.black])
        while currentPageArrayStart + 19 < cellNumber {
            print("cell number is \(cellNumber), currentPageArrayStart is \(currentPageArrayStart)")
    let currentPageArray = questionArray[currentPageArrayStart...currentPageArrayStart + 19]
    pdf.addTable(currentPageArray.count, columnCount: 4, rowHeight: 35.0, tableLineWidth: 0, tableDefinition: tableDef, dataArray: Array(currentPageArray))
    pdf.beginNewPage()
        currentPageArrayStart = currentPageArrayStart + 20
        }
    let pdfData = pdf.generatePDFdata()
        
    // Save as a local file
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
    try? pdfData.write(to: docURL as URL, options: .atomic)
    }
    
    // Load PDF
    func loadPDFAndShare() {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: docURL.path){
            
            let activityViewController = UIActivityViewController (activityItems: [docURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("# Document was not found")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
