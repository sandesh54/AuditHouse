//
//  ReadCountsApiCall.swift
//  Audit House
//
//  Created by Sandesh on 15/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation

struct ReadCountsApiCall {
    
    enum Result {
        case sucess
        case error
    }
    
    static func async(completionHandler: @escaping (_ result: Result, _ info: String,_ reminder: String,_ notification: String) -> ()) {
        let parameters = [
            "user_id": "1"
        ]
        Network().request(.readCount, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
               let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String, message == APIResponseMessage.SUCCESS_MESSAGE {
                    if let userData = result[ApiResponseKeys.DATA] as? Data {
                        let jsonDecoder = JSONDecoder()
                        if let counts  = try? jsonDecoder.decode(Count.self, from: userData){
                            completionHandler(.sucess,counts.impInfo, "\(counts.reminder)",counts.notification)
                        }
                    }
                }
                completionHandler(.sucess,"0","0","0")
            } else {
                completionHandler(.error,"0","0","0")
            }
        }
    }
}
