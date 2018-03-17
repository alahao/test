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

//START HERE

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var worksheetTableView: UITableView!
    
    let answerSeed = GKMersenneTwisterRandomSource()
    var answerSeedNumber : UInt64 = UInt64(Int.random(min: 10000, max: 99999))
    
    var randomOperationSign = 0
    
    // 0: EASY, 1: MEDIUM, 2: HARD
    var difficulty = 0
    var showAnswer = true
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswer = 0
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
    var questionSetL = ""
    var questionSetR = ""
    
    var finalNumerator = 0
    var finalDenominator = 0
    
    var wholeNumberCount = 0
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
    let questionAnswerDivider = "┊  "
    
    var questionNumber = 0
    var questionArray = [["Space", "Question 1", "Question 2", "Space", "divider", "Answers1", "Answers2"]]
    
    var currentPageArrayStart = 0
    
   
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
        removeAllArray()
        generatingPage()
        self.worksheetTableView.reloadData()
    }
    
    @IBAction func PDFExport(_ sender: Any) {
        print("# Button Pressed")
        loadSimplePDF()
        loadPDFAndShare()

    }
   
    
    
    @IBAction func switchShowAnswer(_ sender: UISwitch) {
        if sender.isOn {
            showAnswer = true
            worksheetTableView.reloadData()
        } else{
            showAnswer = false
            worksheetTableView.reloadData()
        }
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
            startAssignOpeartion()
        }
    }
    
    // + - X / and Mixed
    func CalculateSetArrayPMTD() {
        
        func calculate() {
            var operation = 0
            
            if numberOperation == "Plus" {
                operation = 0
            } else if numberOperation == "Minus" {
                operation = 1
            } else if numberOperation == "Times" {
                operation = 2
            } else if numberOperation == "Division" {
                operation = 3
            } else if numberOperation == "Mixed" {
                operation = Int.random(min: 0, max: 3)
            }
            
            
        if operation == 0 {
            numberOpertaionSign = "+"
            OperationDifficultyPlus()
            numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: aMin, highestValue: aMax).nextInt()
            numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: bMin, highestValue: bMax).nextInt()
            numberAnswer = numberOne + numberTwo
        } else if operation == 1 {
            numberOpertaionSign = "-"
            OperationDifficultyMinus()
            numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: aMin, highestValue: aMax).nextInt()
            numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: bMin, highestValue: bMax).nextInt()
            if difficulty < 2 {
            numberAnswer = numberOne
            numberOne = numberAnswer + numberTwo
            } else if difficulty == 2 {
                numberAnswer = numberOne - numberTwo
            }
        } else if operation == 2 {
            numberOpertaionSign = "×"
            OperationDifficultyTimes()
            numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: aMin, highestValue: aMax).nextInt()
            numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: bMin, highestValue: bMax).nextInt()
            numberAnswer = numberOne * numberTwo
        } else if operation == 3 {
            numberOpertaionSign = "÷"
            OperationDifficultyDivision()
            numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: aMin, highestValue: aMax).nextInt()
            numberAnswer = GKRandomDistribution(randomSource: answerSeed, lowestValue: bMin, highestValue: bMax).nextInt()
            numberOne = numberAnswer * numberTwo
        }
        }
        
        calculate()
        questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        numberAnswerOne = numberAnswer
        calculate()
        questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        numberAnswerTwo = numberAnswer
        
        
        questionArray.append(["", questionSetOne, questionSetTwo, "", questionAnswerDivider, " \(numberAnswerOne) "," \(numberAnswerTwo)"])
    }
    
    // Fraction
    func generatingRandomFraction(nLMin: Int, nLMax: Int, dLMin: Int, dLMax: Int, nRMin: Int, nRMax: Int, dRMin: Int, dRMax: Int) {
        // Calculation
        func randomFractionOperation() {
        randomOperationSign = GKRandomDistribution(randomSource: answerSeed, lowestValue: 0, highestValue: 5).nextInt()
            if difficulty == 0 {
                    numberOpertaionSign = "+"
                    fOneAnswerN = fLN * fRD + fRN * fLD
                    fOneAnswerD = fLD * fRD
            }
            else if difficulty == 1 {
                if randomOperationSign < 4 {
                    numberOpertaionSign = "+"
                    fOneAnswerN = fLN * fRD + fRN * fLD
                    fOneAnswerD = fLD * fRD
                } else if randomOperationSign > 3 {
                    numberOpertaionSign = "-"
                    fOneAnswerN = fLN
                    fOneAnswerD = fLD
                    fLN = fOneAnswerN * fRD + fRN * fOneAnswerD
                    fLD = fOneAnswerD * fRD
                }
            }
            else if difficulty == 2 {
                if randomOperationSign < 2 {
                    numberOpertaionSign = "+"
                    fOneAnswerN = fLN * fRD + fRN * fLD
                    fOneAnswerD = fLD * fRD
                } else if randomOperationSign == 2 || randomOperationSign == 3 {
                    numberOpertaionSign = "-"
                    fOneAnswerN = fLN
                    fOneAnswerD = fLD
                    fLN = fOneAnswerN * fRD + fRN * fOneAnswerD
                    fLD = fOneAnswerD * fRD
                } else if randomOperationSign == 4 {
                    numberOpertaionSign = "×"
                    fOneAnswerN = fLN * fRN
                    fOneAnswerD = fLD * fRD
                } else if randomOperationSign == 5 {
                    numberOpertaionSign = "÷"
                    fOneAnswerN = fLN * fRD
                    fOneAnswerD = fLD * fRN
                }
            }
        }
        
        // Function to Generate question set
        func generateQuestionSet() {
            fLN = GKRandomDistribution(randomSource: answerSeed, lowestValue: nLMin, highestValue: nLMax).nextInt()
            fLD = GKRandomDistribution(randomSource: answerSeed, lowestValue: dLMin, highestValue: dLMax).nextInt()
            fRN = GKRandomDistribution(randomSource: answerSeed, lowestValue: nRMin, highestValue: nRMax).nextInt()
        if difficulty == 0 {
            fRD = fLD
        } else {
            fRD = GKRandomDistribution(randomSource: answerSeed, lowestValue: dRMin, highestValue: dRMax).nextInt()
        }
            // Calculating Fraction One
            randomFractionOperation()
            // Simplifying Answer
            wholeNumberCount = 0
            questionSetL = simplifiedFractionStepOne(numerator: fLN, denominator: fLD)
            questionSetR = simplifiedFractionStepOne(numerator: fRN, denominator: fRD)
            
            if wholeNumberCount > 1 || fLN == fLD || fRN == fRD {
                generateQuestionSet()
                print("regenerate fraction because of 2 whole numbers")
            } else if finalDenominator.digitCount > 2 || finalNumerator > 2 {
                generateQuestionSet()
                print("regenerate fraction because numerator or denominator > 2 digits for non Hard Level")
            }
            
        }
        
        generateQuestionSet()
        questionSetOne = questionSetL + " \(numberOpertaionSign) " + questionSetR + " = "
        let simplifiedfAnswerOne = simplifiedFraction(numerator: fOneAnswerN, denominator: fOneAnswerD)
        
        // Generate question set two
        generateQuestionSet()
       
        questionSetTwo = questionSetL + " \(numberOpertaionSign) " + questionSetR + " = "
        let simplifiedfTwoAnswerTwo = simplifiedFraction(numerator: fOneAnswerN, denominator: fOneAnswerD)

        // Write the two questions for a row
        questionArray.append(["", questionSetOne, questionSetTwo, "", questionAnswerDivider, simplifiedfAnswerOne, simplifiedfTwoAnswerTwo])
    }
    
    // Decimal
    func generatingRandomDecimal(numberAMin: Int, numberAMax: Int, numberBMin: Int, numberBMax: Int, dPMin : Int, dPMax : Int, dPMulMin: Int, dPMulMax: Int) {
        var decNumberAnswer = 0.00
        func randomDecimalOperation() {
        let decNumberOneInt = GKRandomDistribution(randomSource: answerSeed, lowestValue: numberAMin * 10000, highestValue: numberAMax * 10000).nextInt()
        
        decNumberOne = Double(decNumberOneInt) / 10000
        decNumberOne = decNumberOne.rounded(toPlaces: GKRandomDistribution(randomSource: answerSeed, lowestValue: dPMin, highestValue: dPMax).nextInt())
        let decNumberTwoInt = GKRandomDistribution(randomSource: answerSeed, lowestValue: numberBMin * 10000, highestValue: numberBMax * 10000).nextInt()
        decNumberTwo = Double(decNumberTwoInt) / 1000
        decNumberTwo = decNumberTwo.rounded(toPlaces: GKRandomDistribution(randomSource: answerSeed, lowestValue: dPMin, highestValue: dPMax).nextInt())
            
            randomOperationSign = GKRandomDistribution(randomSource: answerSeed, lowestValue: 0, highestValue: 4).nextInt()
            if randomOperationSign == 0 || randomOperationSign == 1 {
                numberOpertaionSign = "+"
                decNumberAnswer = decNumberOne + decNumberTwo
            } else if randomOperationSign == 2 || randomOperationSign == 3 {
                numberOpertaionSign = "-"
                decNumberAnswer = decNumberOne
                decNumberOne = decNumberAnswer + decNumberTwo
                
            } else if randomOperationSign == 4 {
                numberOpertaionSign = "×"
                decNumberTwo = decNumberTwo.rounded(toPlaces: GKRandomDistribution(randomSource: answerSeed, lowestValue: dPMulMin, highestValue: dPMulMax).nextInt())
                decNumberAnswer = decNumberOne * decNumberTwo
            }
            
            if decNumberOne.truncatingRemainder(dividingBy: 1) == 0 && decNumberTwo.truncatingRemainder(dividingBy: 1) == 0 {
                randomDecimalOperation()
            }
        }

        randomDecimalOperation()
        questionSetOne = decNumberOne.cleanValue + " \(numberOpertaionSign) " + decNumberTwo.cleanValue + " ="
        decNumberAnswerOne = decNumberAnswer
        
        randomDecimalOperation()
        questionSetTwo = decNumberOne.cleanValue + " \(numberOpertaionSign) " + decNumberTwo.cleanValue + " ="
        decNumberAnswerTwo = decNumberAnswer
        
        questionArray.append(["", questionSetOne, questionSetTwo, "", questionAnswerDivider, " \(decNumberAnswerOne.cleanValue)", decNumberAnswerTwo.cleanValue])
    }
    
    
    // MARK: Begin Difficulty Setting
    var aMin = 0
    var aMax = 0
    var bMin = 0
    var bMax = 0
    
    func OperationDifficultyPlus() {
        if difficulty == 0 {
            aMin = 1
            aMax = 9
            bMin = 1
            bMax = 9
        } else if difficulty == 1 {
            aMin = 1
            aMax = 999
            bMin = 1
            bMax = 99
        } else if difficulty == 2 {
            aMin = 1
            aMax = 9999
            bMin = 1
            bMax = 9999
        }
    }
    
    func OperationDifficultyMinus() {
        if difficulty == 0 {
            aMin = 1
            aMax = 9
            bMin = 1
            bMax = 9
        } else if difficulty == 1 {
            aMin = 1
            aMax = 99
            bMin = 1
            bMax = 999
        } else if difficulty == 2 {
            aMin = 1
            aMax = 999
            bMin = 1
            bMax = 9999
        }
    }
    
    func OperationDifficultyTimes() {
        if difficulty == 0 {
            aMin = 1
            aMax = 9
            bMin = 1
            bMax = 9
        } else if difficulty == 1 {
            aMin = 11
            aMax = 99
            bMin = 11
            bMax = 99
        } else if difficulty == 2 {
            aMin = 11
            aMax = 9999
            bMin = 11
            bMax = 99
        }
    }
    
    func OperationDifficultyDivision() {
        if difficulty == 0 {
            aMin = 1
            aMax = 9
            bMin = 1
            bMax = 9
        } else if difficulty == 1 {
            aMin = 2
            aMax = 19
            bMin = 2
            bMax = 19
        } else if difficulty == 2 {
            aMin = 11
            aMax = 49
            bMin = 11
            bMax = 49
        }
    }
    
    // End Difficulty Setting
    
    func startAssignOpeartion() {
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
    
    func OperationPlus() { // Plus A+B=C
        CalculateSetArrayPMTD()
    }
    
    func OperationMinus() { // Minus A-B=C
        CalculateSetArrayPMTD()
    }
    
    func OperationMul() { // Multiplication A*B=C
        CalculateSetArrayPMTD()
    }
    
    func OperationMixed() { // Mixed 1/4 + 2/4 = 3/4
        CalculateSetArrayPMTD()
    }
    
    func OperationDivision() { // Division C/A=B
        CalculateSetArrayPMTD()
    }
    
    func OperationFraction() { // Fraction 1/4 + 2/4 = 3/4
        var nLMin = 2
        var nLMax = 9
        var dLMin = 2
        var dLMax = 9
        var nRMin = 2
        var nRMax = 9
        var dRMin = 2
        var dRMax = 9
        if difficulty == 0 {
            nLMin = 2
            nLMax = 9
            dLMin = 2
            dLMax = 9
            nRMin = 2
            nRMax = 9
            dRMin = 2
            dRMax = 9
        } else if difficulty == 1 {
            nLMin = 2
            nLMax = 9
            dLMin = 2
            dLMax = 9
            nRMin = 2
            nRMax = 9
            dRMin = 2
            dRMax = 9
        } else if difficulty == 2 {
            nLMin = 2
            nLMax = 9
            dLMin = 2
            dLMax = 19
            nRMin = 2
            nRMax = 9
            dRMin = 2
            dRMax = 19
        }
        generatingRandomFraction(nLMin: nLMin, nLMax: nLMax, dLMin: dLMin, dLMax: dLMax, nRMin: nRMin, nRMax: nRMax, dRMin: dRMin, dRMax: dRMax)}
    
    func OperationDecimal() { // Decimal 1.3 + 2.3 = 3.6  Mixed Operation
        var dPMin = 0
        var dPMax = 0
        var dPMulMin = 0
        var dPMulMax = 0
        var numberAMin = 0
        var numberAMax = 0
        var numberBMin = 0
        var numberBMax = 0
        
        if difficulty == 0 {
            dPMin = 1
            dPMax = 1
            dPMulMin = 0
            dPMulMax = 1
            numberAMin = 2
            numberAMax = 9
            numberBMin = 2
            numberBMax = 9
        } else if difficulty == 1 {
            dPMin = 1
            dPMax = 2
            dPMulMin = 0
            dPMulMax = 1
            numberAMin = 2
            numberAMax = 19
            numberBMin = 2
            numberBMax = 19
        } else if difficulty == 2 {
            dPMin = 1
            dPMax = 3
            dPMulMin = 0
            dPMulMax = 2
            numberAMin = 2
            numberAMax = 99
            numberBMin = 2
            numberBMax = 99
        }
        generatingRandomDecimal(numberAMin: numberAMin, numberAMax: numberAMax, numberBMin: numberBMin, numberBMax: numberBMax, dPMin: dPMin, dPMax: dPMax, dPMulMin: dPMulMin, dPMulMax: dPMulMax)}

    
    func simplifiedFractionStepOne(numerator: Int, denominator: Int) -> (String)   {
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
        
        finalNumerator = numerator
        finalDenominator = denominator
        
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
            return("\(wholeNumbers * finalDenominator + finalNumerator)/\(finalDenominator)")
        }
        if (wholeNumbers > 0 && remainder == 0)
        {
            // prints out whole number only
            wholeNumberCount = wholeNumberCount + 1
            print("whole number count = \(wholeNumberCount)")
            return("\(wholeNumbers)")
        }
        else
        {
            // prints out ftion part only
            return("\(finalNumerator)/\(finalDenominator)")
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
        
        var finalNumerator = numerator
        var finalDenominator = denominator
        
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
//        setRightNavButton()
        answerSeed.seed = answerSeedNumber
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
        cell.numberOneLabel.text = String(describing: questionArray[indexPath.row][1])
        
        cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
        cell.numberThreeLabel.text = String(describing: questionArray[indexPath.row][2])
        
        if showAnswer == true {
        cell.numberAnswerLabel.text = String(describing: questionArray[indexPath.row][5])
        cell.numberAnswerTwoLabel.text = String(describing: questionArray[indexPath.row][6])
        } else {
            cell.numberAnswerLabel.text = ""
            cell.numberAnswerTwoLabel.text = ""
        }
        return cell
    }
    
    // SIMPLE PDF
    func loadSimplePDF() {
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        var tableDef = TableDefinition (
            alignments: [.center],
            columnWidths: [0, 220, 220, 10, 20, 20, 20],
            fonts: [UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 12),
                    UIFont.systemFont(ofSize: 35),
                    UIFont.systemFont(ofSize: 35),
                    UIFont.systemFont(ofSize: 5),
                    UIFont.systemFont(ofSize: 5)],
            textColors: [UIColor.black, UIColor.black, UIColor.black, UIColor.lightGray, UIColor.lightGray, UIColor.darkGray, UIColor.darkGray])
        
        
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
        
    
        // Create Table
        
        while currentPageArrayStart + 19 < cellNumber {
            pdf.setContentAlignment(.center)
            pdf.addText("PaperMath - \(numberOperation) Worksheet", font: UIFont(name: "Baskerville", size: 35)!, textColor: UIColor.black)
            pdf.addLineSpace(10)
            
            pdf.setContentAlignment(.left)
            pdf.addHorizontalSpace(50)
            
            var columnCount = 7
            if showAnswer == true {
                columnCount = 7
            } else {
                columnCount = 4
            }
            
            let currentPageArray = questionArray[currentPageArrayStart...currentPageArrayStart + 19]
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
}
