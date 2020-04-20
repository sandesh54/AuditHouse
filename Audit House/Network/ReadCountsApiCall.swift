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
        guard let userData = UserDefaults.standard.data(forKey: UserDefaultsKeys.USER_INFO_KEY) else {
            fatalError("User data did not got stored in UserDefaults")
        }
        
        guard  let user = try? JSONDecoder().decode(User.self, from: userData) else {
            fatalError("Invalid user data info")
        }
        
        let parameters = [
            "user_id": user.customer_id
        ]
        
        Network().request(.readCount, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
                let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String, message == APIResponseMessage.SUCCESS_MESSAGE {
                    if let userDataDict = result[ApiResponseKeys.RESULT] as? [String: Any] {
                        if let userData = try? JSONSerialization.data(withJSONObject: userDataDict, options: .fragmentsAllowed) {
                            let jsonDecoder = JSONDecoder()
                            if let counts  = try? jsonDecoder.decode(Count.self, from: userData){
                                completionHandler(.sucess,counts.impInfo, "\(counts.reminder)",counts.notification)
                            }
                        }
                    }
                }
            } else {
                completionHandler(.error,"0","0","0")
            }
        }
    }
}
