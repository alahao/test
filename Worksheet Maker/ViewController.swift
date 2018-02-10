//
//  ViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

var sharedSeret = "d7ab595b24b94295918edfcf10c176eb"

enum RegisteredPurchase: String {
    case unlock = "geniuslevel"
}

class NetworkActivityIndicatorManager : NSObject {
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    class func networkOperationFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

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
    
    let bundleID =  "com.nanwang.paperworksheet"
    
    var unlock = RegisteredPurchase.unlock
    
    
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
        case 1:
            selectedDifficulty = 1
        case 2:
            selectedDifficulty = 2
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
    
    func getInfo(purchase : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
        })
    }
    
    func purchase(purchase : RegisteredPurchase) {
         NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
        })
    }
    
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, applicationUsername: String, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
        })
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSeret, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
        })
    }
    
    func verifyPurchase() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: <#T##ReceiptValidator#>, completion: <#T##(VerifyReceiptResult) -> Void#>)
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

