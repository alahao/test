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
import Flurry_iOS_SDK

var numberOperation = ""
var questionNumber = 0
var seedOperation = [0,0,0,0,0,0]
let answerSeed : GKMersenneTwisterRandomSource? = GKMersenneTwisterRandomSource()
var answerSeedNumber : UInt64 = 0
var worksheetAnswerCode = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var answerButton: UIBarButtonItem!
    let question = questionArray()
    let operation = Operation()
    
    @IBOutlet weak var worksheetTableView: UITableView!
    
    // VARIBLES
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
    var cellNumber = 10
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 50
    var currentPageArrayStart = 0
    
    // START
    
    // 1. VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        generatingPage()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
    }
    
    // 2. GENERATE 10 lines of questions per page
    func generatingPage() {
        question.questionArray.removeAll()
        questionNumber = 0
        cellNumber = 10 * pageNumber
        answerSeedNumber = UInt64(Int.random(min: 10000, max: 99999))
        answerSeed?.seed = answerSeedNumber
        print("removed Array, new Array is \(question.questionArray)")
        for _ in 1...cellNumber {
            var resultArray = operation.runOperation()
            if question.questionArray.contains(resultArray) {
                print("$caught duplicated questions")
                resultArray = operation.runOperation()
            } else {
            question.questionArray.append(resultArray)
            }
        }
        let stringSeedOperation = seedOperation.map{String($0)}.joined()
        let stringWorksheetAnswerCode = stringSeedOperation + String(difficulty!) + String(format: "%02d", pageNumber) + "\(Int(answerSeedNumber))"
        worksheetAnswerCode = stringWorksheetAnswerCode.compactMap{Int(String($0))}
        print("$worksheetAnswerCode is \(worksheetAnswerCode.map{String($0)}.joined())")
        
        
        
        // FLURRY
        Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Worksheet Generated"])
        Flurry.logEvent("Worksheet Generated", withParameters: getLogOperations())
        print(getLogOperations())

    }
    
    // Prepare Event for Flurry
    func getLogOperations() -> [String : String] {
    
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
        
        let params = ["Difficulty": String(difficulty!), "Page Number": String(pageNumber), "Seed": String(answerSeedNumber), "Operation": logOperation.map{String($0)}.joined(separator: " ")]
        
        return params
    }
    
    
    // GENERATE BAR CODE
    func generateBarCode() {
    let imageView = UIImageView()
    let codeGenerator = FCBBarCodeGenerator()
    let size = CGSize(width: 100, height: 100)
    let code = worksheetAnswerCode.map{String($0)}.joined()
    let type = FCBBarcodeType.qrcode
    
    if let image = codeGenerator.barcode(code: code, type: type, size: size) {
        imageView.image = image
    } else {
        imageView.image = nil
    }
    }
    
    // 4. CREATE TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 10 * pageNumber
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
        var currentPageNumber = 1
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        let tableDef = TableDefinition (
            alignments: [.center],
            columnWidths: [20, 220, 20, 220],
            fonts: [UIFont.systemFont(ofSize: 8),
                    UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 8),
                    UIFont.systemFont(ofSize: 12),],
            textColors: [UIColor.gray, UIColor.black, UIColor.gray, UIColor.black])

        
        
        // Create PDF Table
        while currentPageArrayStart + 9 < cellNumber {

            pdf.setContentAlignment(.center)
            pdf.addText("PaperMath Worksheet", font: UIFont(name: "Baskerville", size: 20)!, textColor: UIColor.black)

            
            pdf.setContentAlignment(.left)

            let columnCount = 4
            let currentPageArray = question.questionArray[currentPageArrayStart...currentPageArrayStart + 9]
            pdf.addTable(currentPageArray.count, columnCount: columnCount, rowHeight: 70.0, tableLineWidth: 0, tableDefinition: tableDef, dataArray: Array(currentPageArray))
            currentPageArrayStart = currentPageArrayStart + 10
            
            
            pdf.addLineSpace(40)
            pdf.addLineSeparator(height: 0.1)
            pdf.addLineSpace(4)

          pdf.beginHorizontalArrangement()
            pdf.setContentAlignment(.left)
            // page number
            pdf.addText("Page \(currentPageNumber)/\(pageNumber)", font: UIFont.systemFont(ofSize: 10), textColor: UIColor.black)
            
            pdf.setContentAlignment(.center)
            pdf.addText("For answer keys, scan barcode using the PaperMath app.", font: UIFont.systemFont(ofSize: 8), textColor: UIColor.black)

            pdf.endHorizontalArrangement()
            pdf.addLineSpace(4)
            
            func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
                let size = image.size
                let widthRatio  = targetSize.width  / size.width
                let heightRatio = targetSize.height / size.height
                
                // Figure out what our orientation is, and use that to form the rectangle
                var newSize: CGSize
                if(widthRatio > heightRatio) {
                    newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
                } else {
                    newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
                }
                
                // This is the rect that we've calculated out and this is what is actually used below
                let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
                
                // Actually do the resizing to the rect using the ImageContext stuff
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                image.draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return newImage!
            }

            let codeGenerator = FCBBarCodeGenerator()
            let size = CGSize(width: 180, height: 20)
            let code = worksheetAnswerCode.map{String($0)}.joined()
            let type = FCBBarcodeType.pdf417
            
            pdf.beginHorizontalArrangement()
            
  
            
            pdf.setContentAlignment(.center)
            // bar code
            if let image = codeGenerator.barcode(code: code, type: type, size: size) {
                pdf.addImage(image)
            }
           
            
            pdf.setContentAlignment(.right)
            // app store icon
            let appStoreIcon = UIImage(named:"appStoreIcon@4x")!
            pdf.addImage(appStoreIcon)
            
            pdf.endHorizontalArrangement()
            
            currentPageNumber = currentPageNumber + 1
            
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
        Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Worksheet Printed"])
        Flurry.logEvent("Worksheet Printed", withParameters: getLogOperations())
        print(getLogOperations())

        
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
        Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Worksheet Refreshed"])
        answerSeedNumber = UInt64(Int.random(min: 10000, max: 99999))
        question.questionArray.removeAll()
        generatingPage()
        self.worksheetTableView.reloadData()
    }
    
    @IBAction func PDFExport(_ sender: Any) {
        Flurry.logEvent("Event", withParameters: ["Button Pressed" : "Worksheet Exported"])
        Flurry.logEvent("Worksheet Exported", withParameters: getLogOperations())
        print(getLogOperations())

        
        loadSimplePDF()
        loadPDFAndShare()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowAnswer" {
            let destinationVC = segue.destination as! AnswersVC
            
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



