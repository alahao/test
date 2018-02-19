//
//  ViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import SwiftyStoreKit


var sharedSeret = "d7ab595b24b94295918edfcf10c176eb"
let inAppPurchaseID = "com.nanwang.paperworksheet.geniuslevel"
var IAPstatus = false
var currentSwitch = 0


@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageQuestionLabel: UILabel!
    @IBAction func stepperAction(_ sender: UIStepper) {
        selectedPageNumber = Int(sender.value)
        pageLabel.text = "\(Int(sender.value)) PAGES"
        pageQuestionLabel.text = "\(Int(sender.value) * 20) Questions"
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentDifficulty(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedDifficulty = 0
            currentSwitch = 0
        case 1:
            selectedDifficulty = 1
            currentSwitch = 1
        case 2:
            if IAPstatus == false {
                performSegue(withIdentifier: "segueIAP", sender: self)
                segmentControl.selectedSegmentIndex = currentSwitch
            } else {
            selectedDifficulty = 2
            currentSwitch = 2
            }
        default:
            break
        }
    }
    
    var selectedOperation = "+"
    var selectedPageNumber = 1
    var selectedOperationLabel = "Plus"
    var selectedDifficulty = 0
    
    @IBAction func buttonPlus(_ sender: Any) {
        selectedOperation = "Plus"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMinus(_ sender: Any) {
        selectedOperation = "Minus"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMul(_ sender: Any) {
        selectedOperation = "Times"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    @IBAction func buttonDiv(_ sender: Any) {
        selectedOperation = "Division"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonFraction(_ sender: Any) {
        selectedOperation = "Fraction"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonDec(_ sender: Any) {
        selectedOperation = "Decimal"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    @IBAction func buttonMix(_ sender: Any) {
        selectedOperation = "Mixed"
        performSegue(withIdentifier: "segueCreateWorkSheet", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCreateWorkSheet" {
        let destinationVC =  segue.destination as! WorksheetVC
        destinationVC.numberOperation = selectedOperation
        destinationVC.pageNumber = selectedPageNumber
        destinationVC.difficulty = selectedDifficulty
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Storekit
        SwiftyStoreKit.retrieveProductsInfo([inAppPurchaseID]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
        
        verifyPurchase()
//        purchaseProduct(with: inAppPurchaseID)
    }
    
    
    func verifyPurchase() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSeret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = inAppPurchaseID
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    IAPstatus = true
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    IAPstatus = false
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

