//
//  WorksheetVC.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import SimplePDF


public extension Int {
    
    /// Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        return Int.random(n: Int.max)
    }
    
    /// Random integer between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random Int point number between 0 and n max
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    ///  Random integer between min and max
    ///
    /// - Parameters:
    ///   - min:    Interval minimun
    ///   - max:    Interval max
    /// - Returns:  Returns a random Int point number between 0 and n max
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
        
    }
}

// MARK: Double Extension

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

// MARK: Float Extension

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

// MARK: CGFloat Extension

public extension CGFloat {
    
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(Float.random)
    }
    
    /// Random CGFloat between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

extension UIFont
{
    static func ftionFont(ofSize pointSize: CGFloat) -> UIFont
    {
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize).fontDescriptor
        let ftionFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                        ], ]
            ] )
        return UIFont(descriptor: ftionFontDesc, size:pointSize)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//START HERE

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var worksheetTableView: UITableView!
    
    var randomOperationSign = 0
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswerOne = 0
    var numberAnswerTwo = 0
    var numberOperation = ""
    var numberOpertaionSign = ""
    
    var questionSetOne = ""
    var questionSetTwo = ""
    
    // Fraction
    var fLN = 0
    var fLD = 0
    var fRN = 0
    var fRD = 0
    var fOneAnswerN = 0
    var fOneAnswerD = 0
    var fTwoLN = 0
    var fTwoLD = 0
    var fTwoRN = 0
    var fTwoRD = 0
    var fTwoAnswerN = 0
    var fTwoAnswerD = 0
    // End Fraction
    
    // Decimal
    var decNumberOne = 0.00
    var decNumberTwo = 0.00
    var decNumberAnswerOne = 0.00
    var decNumberOperation = ""
    var decNumberThree = 0.00
    var decNumberFour = 0.00
    var decNumberAnswerTwo = 0.00
    var decNumberOperationTwo = ""
    var decNumberOpertaionSignL = ""
    var decNumberOpertaionSignR = ""
    
    //    var operationName = ""
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 40
    let questionAnswerDivider = "┊"
    
    var questionNumber = 0
    var questionArray = [["Quesion 1","Quesion 2", "space", "divider", "Answers1","Answers2"]]
    
    var currentPageArrayStart = 0
    
    //Share Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        print("# Button Pressed")
        loadSimplePDF()
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
        }
    }
    
    
    func generatingRandomNumber(numberAMin: Int, numberAMax: Int, numberBMin: Int, numberBMax: Int) {

        
        if numberOperation == "Plus" {
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberBMax)
            numberAnswerOne = numberOne + numberTwo
            questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberBMax)
            numberAnswerTwo = numberOne + numberTwo
            questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        } else if numberOperation == "Minus" {
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberOne)
            numberAnswerOne = numberOne - numberTwo
            questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberOne)
            numberAnswerTwo = numberOne - numberTwo
            questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        } else if numberOperation == "Times" {
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberBMax)
            numberAnswerOne = numberOne * numberTwo
            questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
            numberOne = Int.random(min: numberAMin, max: numberAMax)
            numberTwo = Int.random(min: numberBMin, max: numberBMax)
            numberAnswerTwo = numberOne * numberTwo
            questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        } else if numberOperation == "Division" {
            numberTwo = Int.random(min: numberAMin, max: numberAMax)
            numberAnswerOne = Int.random(min: numberBMin, max: numberBMax)
            numberOne = numberAnswerOne * numberTwo
            questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
            numberTwo = Int.random(min: numberAMin, max: numberAMax)
            numberAnswerTwo = Int.random(min: numberBMin, max: numberBMax)
            numberOne = numberAnswerTwo * numberTwo
            questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        }
//        else if numberOperation == "Mixed" {
//            numberTwo = Int.random(min: numberAMin, max: numberAMax)
//            numberAnswerOne = Int.random(min: numberBMin, max: numberBMax)
//            numberFour = Int.random(min: numberAMin, max: numberAMax)
//            numberAnswerTwo = Int.random(min: numberBMin, max: numberBMax)
//            numberOne = numberAnswerOne * numberTwo
//            numberThree = numberAnswerTwo * numberFour
//        }
        
        questionArray.append([questionSetOne, questionSetTwo, "", questionAnswerDivider, "\(numberAnswerOne) "," \(numberAnswerTwo)"])
    }
    
    func generatingRandomFraction(nLMin: Int, nLMax: Int, dLMin: Int, dLMax: Int, nRMin: Int, nRMax: Int, dRMin: Int, dRMax: Int) {
        fLN = Int.random(min: nLMin, max: nLMax)
        fLD = Int.random(min: dLMin, max: dLMax)
        fRN = Int.random(min: nRMin, max: nRMax)
        fRD = Int.random(min: dRMin, max: dRMax)
        
        fOneAnswerN = fLN * fRD + fRN * fLD
        fOneAnswerD = fLD * fRD
        questionSetOne = "\(fLN)/\(fLD) + \(fRN)/\(fRD) = "
        
        fLN = Int.random(min: nLMin, max: nLMax)
        fLD = Int.random(min: dLMin, max: dLMax)
        fRN = Int.random(min: nRMin, max: nRMax)
        fRD = Int.random(min: dRMin, max: dRMax)
        
        fTwoAnswerN = fLN * fRD + fRN * fLD
        fTwoAnswerD = fLD * fRD
        questionSetTwo = "\(fLN)/\(fLD) + \(fRN)/\(fRD) = "
        
        let simplifiedfAnswer = simplifiedFraction(numerator: fOneAnswerN, denominator: fOneAnswerD)
        let simplifiedfTwoAnswer = simplifiedFraction(numerator: fTwoAnswerN, denominator: fTwoAnswerD)
        
        questionArray.append([questionSetOne, questionSetTwo, "", questionAnswerDivider, simplifiedfAnswer, simplifiedfTwoAnswer])
    }
    
    func generatingRandomDecimal(numberAMin: Double, numberAMax: Double, numberBMin: Double, numberBMax: Double)
    {
        var decNumberAnswer = 0.00
    
        func randomDecimalOperation() {
        decNumberOne = Double.random(min: numberAMin, max: numberAMax)
        decNumberOne = decNumberOne.rounded(toPlaces: 2)
        decNumberTwo = Double.random(min: numberBMin, max: numberBMax)
        decNumberTwo = decNumberTwo.rounded(toPlaces: 2)
            
            randomOperationSign = Int.random(min: 0, max: 4)
            if randomOperationSign == 0 || randomOperationSign == 1 {
                numberOpertaionSign = "+"
                decNumberAnswer = decNumberOne + decNumberTwo
            } else if randomOperationSign == 2 || randomOperationSign == 3 {
                numberOpertaionSign = "-"
                decNumberAnswer = decNumberOne
                decNumberOne = decNumberAnswer + decNumberTwo
                
            } else if randomOperationSign == 4 {
                numberOpertaionSign = "×"
                decNumberTwo = decNumberTwo.rounded(toPlaces: 1)
                decNumberAnswer = decNumberOne * decNumberTwo
            }
        }
    
        randomDecimalOperation()
        questionSetOne = "\(decNumberOne) \(numberOpertaionSign) \(decNumberTwo) = "
        decNumberAnswerOne = decNumberAnswer
        
        randomDecimalOperation()
        questionSetTwo = "\(decNumberOne) \(numberOpertaionSign) \(decNumberTwo) = "
        decNumberAnswerTwo = decNumberAnswer
        
        questionArray.append([questionSetOne, questionSetTwo, "", questionAnswerDivider, "\(decNumberAnswerOne) "," \(decNumberAnswerTwo)"])
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
    func OperationFraction() { // 1/4 + 2/4 = 3/4
        generatingRandomFraction(nLMin: 2, nLMax: 9, dLMin: 2, dLMax: 9, nRMin: 2, nRMax: 9, dRMin: 2, dRMax: 9)}
    func OperationDecimal() { // 1/4 + 2/4 = 3/4
        generatingRandomDecimal(numberAMin: 2, numberAMax: 9, numberBMin: 2, numberBMax: 9)}
    func OperationMixed() { // 1/4 + 2/4 = 3/4
        generatingRandomNumber(numberAMin: 2, numberAMax: 9, numberBMin: 2, numberBMax: 9)}
    
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
        } else if numberOperation == "Decimal" {
            OperationDecimal()
        } else if numberOperation == "Mixed" {
            OperationMixed()
        }
    }
    
    func simplifiedFraction(numerator: Int, denominator: Int) -> (String)
    {
        var x = numerator
        var y = denominator
        while (y != 0) {
            let buffer = y
            y = x % y
            x = buffer
        }
        
        let hcfVal = x
        let newNumerator = numerator/hcfVal
        let newDenominator = denominator/hcfVal
        
        var finalNumerator = numerator;
        var finalDenominator = denominator;
        
        let wholeNumbers:Int = newNumerator / newDenominator
        let remainder:Int = newNumerator % newDenominator
        
        if(remainder > 0)
        {
            // see if we can simply the ftion part as well
            if(newDenominator % remainder == 0) // no remainder means remainder can be simplified further
            {
                finalDenominator = newDenominator / remainder;
                finalNumerator = remainder / remainder;
            }
            else
            {
                finalNumerator = remainder;
                finalDenominator = newDenominator;
            }
        }
        
        if(wholeNumbers > 0 && remainder > 0)
        {
            // prints out whole number and ftion parts
            return("\(wholeNumbers) \(finalNumerator)/\(finalDenominator)")
        }
        else if (wholeNumbers > 0 && remainder == 0)
        {
            // prints out whole number only
            return("\(wholeNumbers)")
        }
        else
        {
            // prints out ftion part only
            return("\(finalNumerator)/\(finalDenominator)")
        }
    }
    
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
        
        cell.RowNumber.text = String(indexPath.row * 2 + 1)
        cell.numberOneLabel.text = String(describing: questionArray[indexPath.row][0])
        cell.numberAnswerLabel.text = String(describing: questionArray[indexPath.row][4])
        
        cell.numberAnswerLabel.sizeToFit()
        
        cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
        cell.numberThreeLabel.text = String(describing: questionArray[indexPath.row][1])
        cell.numberAnswerTwoLabel.text = String(describing: questionArray[indexPath.row][5])
        cell.numberAnswerTwoLabel.sizeToFit()
        return cell
    }
    
    // SIMPLE PDF
    func loadSimplePDF() {
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        pdf.setContentAlignment(.center)
        
        var tableDef = TableDefinition (
            alignments: [.center],
            columnWidths: [220, 220, 70, 20, 20, 20],
            fonts: [UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 35),
                    UIFont.systemFont(ofSize: 35),
                    UIFont.systemFont(ofSize: 7),
                    UIFont.systemFont(ofSize: 7)],
            textColors: [UIColor.black, UIColor.black, UIColor.lightGray, UIColor.lightGray, UIColor.darkGray, UIColor.darkGray])
        
        
        if numberOperation == "Fraction" {
        tableDef = TableDefinition (
                alignments: [.center],
                columnWidths: [220, 220, 70, 20, 20, 20],
                fonts: [UIFont.systemFont(ofSize: 12),
                        UIFont.systemFont(ofSize: 12),
                        UIFont.systemFont(ofSize: 35),
                        UIFont.systemFont(ofSize: 35),
                        UIFont.systemFont(ofSize: 4),
                        UIFont.systemFont(ofSize: 4)],
                textColors: [UIColor.black, UIColor.black, UIColor.lightGray, UIColor.lightGray, UIColor.darkGray, UIColor.darkGray])
        }
        
    
        // Create Table
        while currentPageArrayStart + 19 < cellNumber {
            pdf.addText("\(numberOperation) Worksheet", font: UIFont(name: "Baskerville", size: 35)!, textColor: UIColor.black)
            pdf.addLineSpace(10)
            let currentPageArray = questionArray[currentPageArrayStart...currentPageArrayStart + 19]
            pdf.addTable(currentPageArray.count, columnCount: 6, rowHeight: 36.0, tableLineWidth: 0, tableDefinition: tableDef, dataArray: Array(currentPageArray))
            currentPageArrayStart = currentPageArrayStart + 20
            pdf.addLineSpace(10)
            pdf.addText("Created by WORKSHEET MAKER, download free on Apple AppStore", font: UIFont.systemFont(ofSize: 10), textColor: UIColor.black)
            
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
