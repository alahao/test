//
//  Difficulty.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/17/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import Foundation

class Difficulty {
    
    var difficulty = 0
    
    // MARK: Begin Difficulty Setting
    var aMin = 0
    var aMax = 0
    var bMin = 0
    var bMax = 0
    
    // Fraction
    var nLMin = 2
    var nLMax = 9
    var dLMin = 2
    var dLMax = 9
    var nRMin = 2
    var nRMax = 9
    var dRMin = 2
    var dRMax = 9
    
    // Decimal
    var dPMin = 0
    var dPMax = 0
    var dPMulMin = 0
    var dPMulMax = 0
    var numberAMin = 0
    var numberAMax = 0
    var numberBMin = 0
    var numberBMax = 0
    
    
    
    
    
    // FUNC
    
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
    
    
    func OperationDifficultyFraction() {
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
    }
    
    func OperationDifficultyDecimal() {
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
    }
    
    
}
