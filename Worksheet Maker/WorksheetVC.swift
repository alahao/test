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
    var numberOpertaionSign = ""
    
    // Fraction
    var fOneLN = 0
    var fOneLD = 0
    var fOneRN = 0
    var fOneRD = 0
    var fOneAnswerN = 0
    var fOneAnswerD = 0
    var fTwoLN = 0
    var fTwoLD = 0
    var fTwoRN = 0
    var fTwoRD = 0
    var fTwoAnswerN = 0
    var fTwoAnswerD = 0
    // End Fraction
    
    //    var operationName = ""
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 40
    
    var headerCells = [21,42,63,84,100,120,140,160,180,200,220,240,260,280,300]
    
    var questionNumber = 0
    var questionArray = [["Quesion 1","Quesion 2","Answers1","Answers2"]]
    //    var questionFractionArray = [[0,0,0,0,0,0,0,0,0,0,0,0]]
    
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
    
    func generatingRandomNumber(numberAMin: UInt32, numberAMax: UInt32, numberBMin: UInt32, numberBMax: UInt32) {
        if numberOperation == "Plus" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberAnswerOne = numberOne + numberTwo
            numberAnswerTwo = numberThree + numberFour
        } else if numberOperation == "Minus" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(UInt32(numberOne) - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(UInt32(numberThree) - numberBMin) + numberBMin)
            numberAnswerOne = numberOne - numberTwo
            numberAnswerTwo = numberThree - numberFour
        } else if numberOperation == "Times" {
            numberOne = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberThree = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberFour = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberAnswerOne = numberOne * numberTwo
            numberAnswerTwo = numberThree * numberFour
        } else if numberOperation == "Division" {
            numberTwo = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberAnswerOne = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberFour = Int(arc4random_uniform(numberAMax - numberAMin) + numberAMin)
            numberAnswerTwo = Int(arc4random_uniform(numberBMax - numberBMin) + numberBMin)
            numberOne = numberAnswerOne * numberTwo
            numberThree = numberAnswerTwo * numberFour
        }
        
        questionArray.append(["\(numberOne) \(numberOpertaionSign) \(numberTwo) = ", "\(numberThree) \(numberOpertaionSign) \(numberFour) = ", "\(numberAnswerOne) "," \(numberAnswerTwo)"])
        //        print("$ Running questionArray Append = \(questionArray)")
    }
    
    func generatingRandomFraction(nLMin: UInt32, nLMax: UInt32, dLMin: UInt32, dLMax: UInt32, nRMin: UInt32, nRMax: UInt32, dRMin: UInt32, dRMax: UInt32) {
        fOneLN = Int(arc4random_uniform(nLMax - nLMin) + nLMin)
        fOneLD = Int(arc4random_uniform(dLMax - dLMin) + dLMin)
        fOneRN = Int(arc4random_uniform(nRMax - nRMin) + nRMin)
        fOneRD = Int(arc4random_uniform(dRMax - dRMin) + dRMin)
        
        fTwoLN = Int(arc4random_uniform(nLMax - nLMin) + nLMin)
        fTwoLD = Int(arc4random_uniform(dLMax - dLMin) + dLMin)
        fTwoRN = Int(arc4random_uniform(nRMax - nRMin) + nRMin)
        fTwoRD = Int(arc4random_uniform(dRMax - dRMin) + dRMin)
        
        fOneAnswerN = fOneLN * fOneRD + fOneRN * fOneLD
        fOneAnswerD = fOneLD * fOneRD
        
        fTwoAnswerN = fTwoLN * fTwoRD + fTwoRN * fTwoLD
        fTwoAnswerD = fTwoLD * fTwoRD
        
        questionArray.append(["\(fOneLN)/\(fOneLD) + \(fOneRN)/\(fOneRD) = "," \(fTwoLN)/\(fTwoLD) + \(fTwoRN)/\(fTwoRD) = "," \(fOneAnswerN)/\(fOneAnswerD)","\(fTwoAnswerN)/\(fTwoAnswerD)"])
    }
    
    //Operations
    func OperationPlus() { // A+B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99)}
    func OperationMinus() { // A-B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99)}
    func OperationMul() { // A*B=C
        generatingRandomNumber(numberAMin: 11, numberAMax: 99, numberBMin: 11, numberBMax: 99)}
    func OperationDivision() { // C/A=B
        generatingRandomNumber(numberAMin: 2, numberAMax: 9, numberBMin: 2, numberBMax: 9)}
    func OperationFraction() { //
        generatingRandomFraction(nLMin: 2, nLMax: 9, dLMin: 2, dLMax: 9, nRMin: 2, nRMax: 9, dRMin: 2, dRMax: 9)
    }
    
    func operationType() {
        if numberOperation == "Plus" {
            numberOpertaionSign = "+"
            OperationPlus()
        } else if numberOperation == "Minus" {
            numberOpertaionSign = "−"
            OperationMinus()
        } else if numberOperation == "Times" {
            numberOpertaionSign = "×"
            OperationMul()
        } else if numberOperation == "Division" {
            numberOpertaionSign = "÷"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
        
        let pointSizeL : CGFloat = 22.0
        let pointSizeS : CGFloat = 12.0
        let systemFontDesc = UIFont.systemFont(ofSize: pointSizeS, weight: UIFont.Weight.light).fontDescriptor
        let fractionFontDesc = systemFontDesc.addingAttributes([
            UIFontDescriptor.AttributeName.featureSettings: [[
                UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                ]]])
        
        if numberOperation == "Fraction" {
            cell.numberOneLabel.font = UIFont(descriptor: fractionFontDesc, size: pointSizeL)
            cell.numberAnswerLabel.font = UIFont(descriptor: fractionFontDesc, size: pointSizeS)
            cell.numberThreeLabel.font = UIFont(descriptor: fractionFontDesc, size: pointSizeL)
            cell.numberAnswerTwoLabel.font = UIFont(descriptor: fractionFontDesc, size: pointSizeS)
        }
        
        cell.RowNumber.text = String(indexPath.row * 2 + 1)
        cell.numberOneLabel.text = String(describing: questionArray[indexPath.row][0])
        cell.numberAnswerLabel.text = String(describing: questionArray[indexPath.row][2])
        cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
        cell.numberThreeLabel.text = String(describing: questionArray[indexPath.row][1])
        cell.numberAnswerTwoLabel.text = String(describing: questionArray[indexPath.row][3])
        return cell
    }
    
    // SIMPLE PDF
    func loadSimplePDF() {
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        
        var tableDef = TableDefinition (
            alignments: [.left, .left, .center, .center],
            columnWidths: [240, 240, 40, 40],
            fonts: [UIFont.systemFont(ofSize: 20),UIFont.systemFont(ofSize: 20),
                    UIFont.systemFont(ofSize: 10),UIFont.systemFont(ofSize: 10)],
            textColors: [UIColor.black])
        
        if numberOperation == "Fraction" {
            // Fraction font size
            let pointSizeL : CGFloat = 30.0
            let pointSizeS : CGFloat = 15.0
            let systemFontDesc = UIFont.systemFont(ofSize: pointSizeS, weight: UIFont.Weight.light).fontDescriptor
            let fractionFontDesc = systemFontDesc.addingAttributes([
                UIFontDescriptor.AttributeName.featureSettings: [[
                    UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                    ]]])
            
            tableDef = TableDefinition (
                alignments: [.left, .left, .center, .center],
                columnWidths: [240, 240, 50, 60],
                fonts: [UIFont(descriptor: fractionFontDesc,
                               size: pointSizeL),UIFont(descriptor: fractionFontDesc,
                                                        size: pointSizeL), UIFont(descriptor: fractionFontDesc,
                                                                                  size: pointSizeS),UIFont(descriptor: fractionFontDesc,
                                                                                                           size: pointSizeS)], textColors: [UIColor.black])
        }
        
        // Create Table
        while currentPageArrayStart + 19 < cellNumber {
            pdf.addText("\(numberOperation) Worksheet", font: UIFont(name: "Baskerville", size: 35)!, textColor: UIColor.darkGray)
            pdf.addLineSpace(10)
            let currentPageArray = questionArray[currentPageArrayStart...currentPageArrayStart + 19]
            pdf.addTable(currentPageArray.count, columnCount: 4, rowHeight: 36.0, tableLineWidth: 0, tableDefinition: tableDef, dataArray: Array(currentPageArray))
            currentPageArrayStart = currentPageArrayStart + 20
            pdf.addLineSpace(10)
            pdf.addText("Created by WORKSHEET MAKER, download free on Apple AppStore", font: UIFont.systemFont(ofSize: 12), textColor: UIColor.darkGray)
            
            if currentPageArrayStart < cellNumber {
                pdf.beginNewPage()
            }
        }
        currentPageArrayStart = 0
        let pdfData = pdf.generatePDFdata()
        
        // Save as a local file
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("WorksheetMaker.pdf")
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
