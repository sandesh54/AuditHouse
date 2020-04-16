//
//  GetRemindersApiCall.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct GetRemindersApiCall {
    enum Result {
        case sucess
        case error
    }
    
    static func async(_ completionHandler:@escaping (Result, [Reminder]) -> ()) {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        Network().request(.getReminders, parameters: [parameters]) { data, response, error in
            if error == nil, data != nil {
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
                                if let reminder  = try? jsonDecoder.decode([Reminder].self, from: userData){
                                    // delete existing data
                                    CoreData.deleteResponseData(predicate: Predicate.reminderPredicate)
                                    // save new data
                                    let reminderRespose = ResponseData(context: CoreData.context)
                                    reminderRespose.rawData = String(data: userData, encoding: .utf8)
                                    reminderRespose.type = APIResponseTypes.REMINDERS
                                    do { try CoreData.context.save() }
                                    catch {print("CORE DATA SAVE FAILED \(error.localizedDescription)")}
                                    
                                    completionHandler(.sucess, reminder)
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
            } else {
                completionHandler(.error, [])
            }
        }
    }
}
