//
//  StoreObserver.swift
//  purchasetest
//
//  Created by 江东 on 2019/11/30.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
import StoreKit
import Alamofire

class StoreObserver: NSObject, SKPaymentTransactionObserver {
            
    static let shared = StoreObserver()
    
    //Initialize the store observer.
    override init() {
        super.init()
        //Other initialization here.
    }

    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
        for transaction in transactions {
         switch transaction.transactionState {
              // Call the appropriate custom method for the transaction state.
         case .purchasing: break
         case .deferred: print("延迟")
         case .failed: // Finish the failed transaction.
            SKPaymentQueue.default().finishTransaction(transaction)
         case .purchased: // Finishes the restored transaction.
            let userInfo = UserDefaults()
            let userID = userInfo.string(forKey: "userID")
            let parameters: Parameters = ["productid": transaction.payment.productIdentifier,"userid":userID!]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=IOSAddviptime&m=socialchat", method: .post, parameters: parameters).response { response in
                        print("Request: \(String(describing: response.request))")
                        print("Response: \(String(describing: response.response))")
                        print("Error: \(String(describing: response.error))")
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                        }
                    }
            
            SKPaymentQueue.default().finishTransaction(transaction)
         case .restored: // Finishes the restored transaction.
            SKPaymentQueue.default().finishTransaction(transaction)
              // For debugging purposes.
         @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
        }
         }
    }
                
}
