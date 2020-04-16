//
//  CheckDeviceApiCall.swift
//  Audit House
//
//  Created by Sandesh on 15/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct CheckDeviceApiCall {
    enum DeviceStatus {
        case notRegistered
        case notActivated
        case success
        case error
    }
    
    static func async( _ completionHandler: @escaping (DeviceStatus) -> ()) {
        let parameters = [
            "imei": UIDevice.UDID,
            "fcmId": UserDefaults.standard.string(forKey: UserDefaultsKeys.DEVICE_TOKEN_KEY) ?? ""
        ]
        
        Network().request(.checkDevice, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
                let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String {
                    if message == APIResponseMessage.DEVICE_NOT_REGISTERED_MESSAGE {
                        completionHandler(.notRegistered)
                    } else if message == APIResponseMessage.DEVICE_NOT_ACTIVATED_MESSAGE {
                        completionHandler(.notActivated)
                    }else if message == APIResponseMessage.SUCCESS_MESSAGE {
                        if let userData = result[ApiResponseKeys.DATA] as? Data {
                            let jsonDecoder = JSONDecoder()
                            if let _ = try? jsonDecoder.decode(User.self, from: userData){
                                UserDefaults.standard.set(userData, forKey: UserDefaultsKeys.USER_INFO_KEY)
                            }
                        }
                        completionHandler(.success)
                    }
                }
                
            } else {
                completionHandler(.error)
            }
        }
    }
    
    
}
