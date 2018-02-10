//
//  IAPService.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 2/10/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    private override init() {}
    static let shared = IAPService()
    
    func getProduct() {
        let products: Set = [IAPProduct.consumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    
    }
    
    
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print(product.localizedTitle)
        }
    }
    
    
}
