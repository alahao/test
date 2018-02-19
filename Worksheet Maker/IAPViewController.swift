//
//  IAPViewController.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 2/18/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class IAPViewController: UIViewController {
    var sharedSeret = "d7ab595b24b94295918edfcf10c176eb"
    let inAppPurchaseID = "com.nanwang.paperworksheet.geniuslevel"
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iapPurchaseButton(_ sender: Any) {
        purchaseProduct(with: inAppPurchaseID)
        
    }
    
    @IBAction func iapRestoreButton(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func purchaseProduct(with id: String) {
        SwiftyStoreKit.retrieveProductsInfo([id]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        print("Purchase Success: \(product.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        }
                    }
                }
            }
        }
    }
    


}
