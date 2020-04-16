//
//  GetInfoApiCall.swift
//  Audit House
//
//  Created by Sandesh on 15/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

struct GetInfoApiCall {
    enum Result {
        case sucess
        case error
    }
    
    static func async(_ completionHandler:@escaping (Result, [ImportantInfo]) -> ()) {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        Network().request(.getInfo, parameters: [parameters]) { data, response, error in
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
                                if let info  = try? jsonDecoder.decode([ImportantInfo].self, from: userData){
                                    // delete existing data
                                    CoreData.deleteResponseData(predicate: Predicate.importantInfoPredicate)
                                    // save new data
                                    let impInfo = ResponseData(context: CoreData.context)
                                    impInfo.rawData = String(data: userData, encoding: .utf8)
                                    impInfo.type = APIResponseTypes.INFO
                                    do { try CoreData.context.save() }
                                    catch {print("CORE DATA SAVE FAILED \(error.localizedDescription)")}
                                    
                                    completionHandler(.sucess, info)
                                }
                                completionHandler(.sucess,[])
                            }
                            catch {
                                print("THIS IS NOT WORKING")
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
