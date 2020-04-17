//
//  GetNotificationApiCall.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct GetNotificationApiCall {
    enum Result {
        case sucess
        case error
    }
    
    static func async(_ completionHandler:@escaping (Result, [Notifications]) -> ()) {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        Network().request(.getNotifications, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
                // delete existing data
                CoreData.deleteResponseData(predicate: Predicate.notificationPredicate)
                let result = data!.jsonSerialized()
                if let message = result[ApiResponseKeys.MESSAGE] as? String {
                    switch  message {
                    case APIResponseMessage.NO_RESULT_FOUND_MESSAGE:
                        completionHandler(.sucess, [])
                    case APIResponseMessage.SUCCESS_MESSAGE:
                        if let responseArray = result[ApiResponseKeys.RESULT] as? [[String:Any]] {
                            do {
                                let userData  = try JSONSerialization.data(withJSONObject: responseArray, options: .fragmentsAllowed)
                                let jsonDecoder = JSONDecoder()
                                if let notification  = try? jsonDecoder.decode([Notifications].self, from: userData) {
                                    // save new data
                                    let notificationRespose = ResponseData(context: CoreData.context)
                                    notificationRespose.rawData = String(data: userData, encoding: .utf8)
                                    notificationRespose.type = APIResponseTypes.NOTIFICATION
                                    do { try CoreData.context.save() }
                                    catch {print("CORE DATA SAVE FAILED \(error.localizedDescription)")}
                                    
                                    completionHandler(.sucess, notification)
                                }
                                completionHandler(.sucess,[])
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    default:
                        completionHandler(.sucess, [])
                    }
                }
            }
            else {
                completionHandler(.error, [])
            }
        }
    }
}
