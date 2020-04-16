//
//  UserRegistrationApiCall.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct UserRegistrationApiCall {
    enum Result {
        case sucess
        case failed
        case error
    }
    
    static func async(name: String, contactNumber: String, firm: String,_ completionHandler:@escaping (Result) -> ()) {
       let parametes = [
            "imei": UIDevice.UDID,
            "fcmId": UserDefaults.standard.string(forKey: UserDefaultsKeys.DEVICE_TOKEN_KEY) ?? "",
            "model":UIDevice.current.model,
            "name": name,
            "contact": contactNumber,
            "firm": firm
        ]
        
        
        Network().request(.addDevice, parameters: [parametes]) { data, response, error in
            if error == nil, data != nil {
                let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String {
                    switch message {
                    case APIResponseMessage.SUCCESS_MESSAGE:
                        completionHandler(.sucess)
                    case APIResponseMessage.FAILED_MESSAGE:
                        completionHandler(.failed)
                    default: break
                    }
                }
            } else {
                completionHandler(.error)
            }
        }
    }
}
