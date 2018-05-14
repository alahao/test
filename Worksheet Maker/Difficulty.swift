//
//  Difficulty.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/17/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import Foundation

var difficulty : Int? = 0

// MARK: Begin Difficulty Setting
var aMin = 0
var aMax = 0
var bMin = 0
var bMax = 0

// Fraction
var nLMin = 2
var nLMax = 10
var dLMin = 2
var dLMax = 10
var nRMin = 2
var nRMax = 10
var dRMin = 2
var dRMax = 10

// Decimal
var dPMin = 0
var dPMax = 0
var dPMulMin = 0
var dPMulMax = 0
var numberAMin = 0
var numberAMax = 0
var numberBMin = 0
var numberBMax = 0


class Difficulty {
    
    // FUNC
    
    func OperationDifficultyPlus() {
        if difficulty == 0 {
            aMin = 1
            aMax = 10
            bMin = 1
            bMax = 10
        } else if difficulty == 1 {
            aMin = 10
            aMax = 100
            bMin = 10
            bMax = 100
        } else if difficulty == 2 {
            aMin = 10
            aMax = 10000
            bMin = 10
            bMax = 1000
        }
    }
    
    func OperationDifficultyMinus() {
        if difficulty == 0 {
            aMin = 1
            aMax = 10
            bMin = 1
            bMax = 10
        } else if difficulty == 1 {
            aMin = 10
            aMax = 100
            bMin = 10
            bMax = 100
        } else if difficulty == 2 {
            aMin = 10
            aMax = 1000
            bMin = 10
            bMax = 1000
        }
    }
    
    
    func OperationDifficultyTimes() {
        if difficulty == 0 {
            aMin = 2
            aMax = 10
            bMin = 2
            bMax = 10
        } else if difficulty == 1 {
            aMin = 10
            aMax = 100
            bMin = 2
            bMax = 10
        } else if difficulty == 2 {
            aMin = 10
            aMax = 1000
            bMin = 10
            bMax = 100
        }
    }
    
    func OperationDifficultyDivision() {
        if difficulty == 0 {
            aMin = 1
            aMax = 10
            bMin = 1
            bMax = 10
        } else if difficulty == 1 {
            aMin = 8
            aMax = 20
            bMin = 2
            bMax = 20
        } else if difficulty == 2 {
            aMin = 8
            aMax = 50
            bMin = 10
            bMax = 50
        }
    }
    
    
    func OperationDifficultyFraction() {
        if difficulty == 0 {
            nLMin = 1
            nLMax = 10
            dLMin = 2
            dLMax = 10
            nRMin = 1
            nRMax = 10
            dRMin = 2
            dRMax = 10
        } else if difficulty == 1 {
            nLMin = 1
            nLMax = 10
            dLMin = 2
            dLMax = 10
            nRMin = 1
            nRMax = 10
            dRMin = 2
            dRMax = 10
        } else if difficulty == 2 {
            nLMin = 10
            nLMax = 20
            dLMin = 10
            dLMax = 20
            nRMin = 10
            nRMax = 20
            dRMin = 10
            dRMax = 20
        }
    }
    
    func OperationDifficultyDecimal() {
        if difficulty == 0 {
            dPMin = 1
            dPMax = 1
            dPMulMin = 0
            dPMulMax = 1
            numberAMin = 1
            numberAMax = 10
            numberBMin = 1
            numberBMax = 10
        } else if difficulty == 1 {
            dPMin = 1
            dPMax = 2
            dPMulMin = 0
            dPMulMax = 1
            numberAMin = 10
            numberAMax = 20
            numberBMin = 1
            numberBMax = 9
        } else if difficulty == 2 {
            dPMin = 1
            dPMax = 3
            dPMulMin = 0
            dPMulMax = 2
            numberAMin = 10
            numberAMax = 100
            numberBMin = 1
            numberBMax = 9
        }
    }
    
    
}
