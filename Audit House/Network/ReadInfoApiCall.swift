//
//  ReadInfoApiCall.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct ReadInfoApiCall {
    
    enum Result {
        case sucess
        case error
        case fail
    }
    
    static func async( id: String, type: String,_ completionHandler: @escaping (Result) -> ()) {
        let  parameters = [
            "userId": UIDevice.UDID,
            "infoId":id,
            "type": type
        ]
        
        Network().request(.readInfo, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
                let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String {
                    switch message {
                    case APIResponseMessage.SUCCESS_MESSAGE:
                        completionHandler(.sucess)
                    default:
                        completionHandler(.fail)
                    }
                }
            } else {
                completionHandler(.error)
            }
        }
    }
}
