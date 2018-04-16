//
//  WorksheetVC.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import SimplePDF
import GameKit

var numberOperation = ""
var questionNumber = 0

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var answerButton: UIBarButtonItem!
    
    let question = questionArray()
    let operation = Operation()
    
    var difficulty = 0
    
    @IBOutlet weak var worksheetTableView: UITableView!
    
    
    // VARIBLES
    let answerSeed = GKMersenneTwisterRandomSource()
    var answerSeedNumber : UInt64 = UInt64(Int.random(min: 10000, max: 99999))
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswer = 0
    var numberAnswerOne = 0
    var numberAnswerTwo = 0

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
    var questionSetL = ""
    var questionSetR = ""
    
    var finalNumerator = 0
    var finalDenominator = 0
    
    var wholeNumberCount = 0
  
    
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
    
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 40
    let questionAnswerDivider = "┊  "
    
  
    var currentPageArrayStart = 0
    
    
    
    // START
    
    
    // 1. VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        answerSeed.seed = answerSeedNumber
        print("QArray 0 is \(question.questionArray)")
        generatingPage()
       
        print("QArray 1 is \(question.questionArray)")
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
    }
    
    // 2. GENERATE 20 lines of questions per page
    func generatingPage() {
        cellNumber = 20 * pageNumber
        question.questionArray.removeAll()
        questionNumber = 0
        answerButton.title = "Answer Key \(numberOperation.characters.first!)-\(answerSeedNumber)"
        print("removed Array, new Array is \(question.questionArray)")
        for _ in 1...cellNumber {
            assignOpeartion()
            print("QArray assigned is \(question.questionArray)")
        }
    }
    
    // 3. ASSIGN OPERATION TYPE, Send to Opertaion Class to calculate
    func assignOpeartion() {
        if numberOperation == "Plus" { // Plus A+B=C
            numberOpertaionSign = "+"
            question.questionArray.append(operation.CalculatePMTD())
        } else if numberOperation == "Minus" { // Minus A-B=C
            numberOpertaionSign = "−"
            question.questionArray.append(operation.CalculatePMTD())
        } else if numberOperation == "Times" { // Multiplication A*B=C
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
        
        cell.RowNumber.text = String(describing: question.questionArray[indexPath.row][0])
        cell.numberOneLabel.text = String(describing: question.questionArray[indexPath.row][1])
        
        cell.RowNumberTwo.text = String(describing: question.questionArray[indexPath.row][2])
        cell.numberThreeLabel.text = String(describing: question.questionArray[indexPath.row][3])
        
       
        return cell
    }
    
    
    
    
// END
    
    
    
    
    
    
    
    // SIMPLE PDF
    func loadSimplePDF() {
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        var tableDef = TableDefinition (
            alignments: [.center],
            columnWidths: [20, 220, 20, 220],
            fonts: [UIFont.systemFont(ofSize: 8),
                    UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 8),
                    UIFont.systemFont(ofSize: 12)],
            textColors: [UIColor.lightGray, UIColor.black, UIColor.lightGray, UIColor.black])
        
        
        if numberOperation == "Fraction" || numberOperation == "Decimal" {
            tableDef = TableDefinition (
                alignments: [.center],
                columnWidths: [20, 200, 200, 10, 20, 30, 30],
                fonts: [UIFont.systemFont(ofSize: 12),
                        UIFont.systemFont(ofSize: 12),
                        UIFont.systemFont(ofSize: 12),
                        UIFont.systemFont(ofSize: 35),
                        UIFont.systemFont(ofSize: 35),
                        UIFont.systemFont(ofSize: 4),
                        UIFont.systemFont(ofSize: 4)],
                textColors: [UIColor.black, UIColor.black, UIColor.black, UIColor.lightGray, UIColor.lightGray, UIColor.darkGray, UIColor.darkGray])
        }
        
        
        // Create PDF Table
        
        while currentPageArrayStart + 19 < cellNumber {
            pdf.setContentAlignment(.center)
            pdf.addText("PaperMath - \(numberOperation) Worksheet", font: UIFont(name: "Baskerville", size: 35)!, textColor: UIColor.black)
            pdf.addLineSpace(10)
            
            pdf.setContentAlignment(.left)
            pdf.addHorizontalSpace(50)
            
            let columnCount = 4

            
            let currentPageArray = question.questionArray[currentPageArrayStart...currentPageArrayStart + 19]
            pdf.addTable(currentPageArray.count, columnCount: columnCount, rowHeight: 36.0, tableLineWidth: 0, tableDefinition: tableDef, dataArray: Array(currentPageArray))
            currentPageArrayStart = currentPageArrayStart + 20
            
            pdf.setContentAlignment(.center)
            pdf.addLineSpace(10)
            pdf.addText("Created by PaperMath. Get it on the iPhone App Store!", font: UIFont.systemFont(ofSize: 10), textColor: UIColor.black)
            
            if currentPageArrayStart < cellNumber {
                pdf.beginNewPage()
            }
        }
        currentPageArrayStart = 0
        let pdfData = pdf.generatePDFdata()
        
        // Save as a local file
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("PaperWorksheet.pdf")
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
    
    
    //Share Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        
        loadSimplePDF()
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary : nil)
        printInfo.duplex = .longEdge
        printInfo.outputType = .general
        printInfo.jobName = "PaperMath Worksheet"
        printController.printInfo = printInfo
        printController.printingItem = docURL
        printController.present(animated : true, completionHandler : nil)
    }
    
    @IBAction func PDFRefresh(_ sender: Any) {
        answerSeedNumber = UInt64(Int.random(min: 10000, max: 99999))
        question.questionArray.removeAll()
        generatingPage()
        self.worksheetTableView.reloadData()
    }
    
    @IBAction func PDFExport(_ sender: Any) {
        print("# Button Pressed")
        loadSimplePDF()
        loadPDFAndShare()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowAnswer" {
            let destinationVC =  segue.destination as! AnswersVC
            destinationVC.answerCodeLText = String(numberOperation.characters.first!)
            destinationVC.answerCodeRText = String(answerSeedNumber)
        }
    }
}








// EXTENSION
// START Digit Count
public extension Int {
    /// returns number of digits in Int number
    public var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }
    /// returns number of useful digits in Int number
    
    // private recursive method for counting digits
    private func numberOfDigits(in number: Int) -> Int {
        if abs(number) < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
    // returns true if digit is useful in respect to self
    private func isUseful(_ digit: Int) -> Bool {
        return (digit != 0) && (self % digit == 0)
    }
}
// END Digit Count

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
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
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



