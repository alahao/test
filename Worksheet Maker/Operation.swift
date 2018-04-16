//
//  Operation.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/17/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import Foundation
import GameKit

class Operation {
    var randomOperationSign = 0
    
    let answerSeed = GKMersenneTwisterRandomSource()
    let question = questionArray()
    let difficultySetting = Difficulty()
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswer = 0
    var answerOne = 0
    var answerTwo = 0
    
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
    
    
    // ***** Calculate ***** + - X / and Mixed
    func CalculatePMTD() -> [String] {
    
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
                difficultySetting.OperationDifficultyPlus()
                numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.aMin, highestValue: difficultySetting.aMax).nextInt()
                numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.bMin, highestValue: difficultySetting.bMax).nextInt()
                numberAnswer = numberOne + numberTwo
            } else if operation == 1 {
                numberOpertaionSign = "-"
                difficultySetting.OperationDifficultyMinus()
                numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.aMin, highestValue: difficultySetting.aMax).nextInt()
                numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.bMin, highestValue: difficultySetting.bMax).nextInt()
                if difficultySetting.difficulty < 2 {
                    numberAnswer = numberOne
                    numberOne = numberAnswer + numberTwo
                } else if difficultySetting.difficulty == 2 {
                    numberAnswer = numberOne - numberTwo
                }
            } else if operation == 2 {
                numberOpertaionSign = "×"
                difficultySetting.OperationDifficultyTimes()
                numberOne = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.aMin, highestValue: difficultySetting.aMax).nextInt()
                numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.bMin, highestValue: difficultySetting.bMax).nextInt()
                numberAnswer = numberOne * numberTwo
            } else if operation == 3 {
                numberOpertaionSign = "÷"
                difficultySetting.OperationDifficultyDivision()
                numberTwo = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.aMin, highestValue: difficultySetting.aMax).nextInt()
                numberAnswer = GKRandomDistribution(randomSource: answerSeed, lowestValue: difficultySetting.bMin, highestValue: difficultySetting.bMax).nextInt()
                numberOne = numberAnswer * numberTwo
            }
        }
        
        calculate()
        questionNumber = questionNumber + 1
        let questionNumberL = questionNumber
        questionSetOne = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        answerOne = numberAnswer
        calculate()
        questionNumber = questionNumber + 1
        let questionNumberR = questionNumber
        questionSetTwo = "\(numberOne) \(numberOpertaionSign) \(numberTwo) = "
        answerTwo = numberAnswer
       
        
        let array = ["\(questionNumberL)", questionSetOne, "\(questionNumberR)", questionSetTwo, " \(answerOne) "," \(answerTwo)"]
       
        return array
    }
    
    // ***** Calculate ***** Fraction
    func OperationFraction() -> [[String]] { // Fraction 1/4 + 2/4 = 3/4
    
        let nLMin = difficultySetting.nLMin
        let nLMax = difficultySetting.nLMax
        let dLMin = difficultySetting.dLMin
        let dLMax = difficultySetting.dLMax
        let nRMin = difficultySetting.nRMin
        let nRMax = difficultySetting.dRMax
        let dRMin = difficultySetting.dRMin
        let dRMax = difficultySetting.dRMax
        
        func randomFractionOperation() {
            randomOperationSign = GKRandomDistribution(randomSource: answerSeed, lowestValue: 0, highestValue: 5).nextInt()
            if difficultySetting.difficulty == 0 {
                numberOpertaionSign = "+"
                fOneAnswerN = fLN * fRD + fRN * fLD
                fOneAnswerD = fLD * fRD
            }
            else if difficultySetting.difficulty == 1 {
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
            else if difficultySetting.difficulty == 2 {
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
            if difficultySetting.difficulty == 0 {
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
        
        generateQuestionSet()
        questionSetTwo = questionSetL + " \(numberOpertaionSign) " + questionSetR + " = "
        let simplifiedfTwoAnswerTwo = simplifiedFraction(numerator: fOneAnswerN, denominator: fOneAnswerD)
        
        // Write the two questions for a row
        question.questionArray.append(["", questionSetOne, questionSetTwo, "", simplifiedfAnswerOne, simplifiedfTwoAnswerTwo])
        return question.questionArray
    }
    
        // ***** Calculate ***** Decimal
    func OperationDecimal() -> [[String]] { // Decimal 1.3 + 2.3 = 3.6  Mixed Operation
    
        let numberAMin = difficultySetting.numberAMin
        let numberAMax = difficultySetting.numberAMax
        let numberBMin = difficultySetting.numberBMin
        let numberBMax = difficultySetting.numberBMax
        let dPMin = difficultySetting.dPMin
        let dPMax = difficultySetting.dPMax
        let dPMulMin = difficultySetting.dPMulMin
        let dPMulMax = difficultySetting.dPMulMax
        
        
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
        
        randomDecimalOperation()
        questionSetOne = decNumberOne.cleanValue + " \(numberOpertaionSign) " + decNumberTwo.cleanValue + " ="
        decNumberAnswerOne = decNumberAnswer
        
        randomDecimalOperation()
        questionSetTwo = decNumberOne.cleanValue + " \(numberOpertaionSign) " + decNumberTwo.cleanValue + " ="
        decNumberAnswerTwo = decNumberAnswer
        
        question.questionArray.append(["", questionSetOne, questionSetTwo, "", " \(decNumberAnswerOne.cleanValue)", decNumberAnswerTwo.cleanValue])
        }
        return question.questionArray
       }
    
    

 
    

    
    // Simplifying Fraction
    
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
    
}
