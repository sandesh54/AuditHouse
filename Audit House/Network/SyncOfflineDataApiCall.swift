//
//  SyncOfflineDataApiCall.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

struct SyncOfflineDataApiCall {
    
    enum Result {
        case sucess
        case error
        case fail
    }
    
    static func async(_ completionHandler: @escaping (Result) -> ()) {
        let fetchRequest: NSFetchRequest<ReadStatus> = ReadStatus.fetchRequest()
        
        do {
            let readInfo = try CoreData.context.fetch(fetchRequest)
            guard readInfo.count > 0 else { return }
            
            var parameters = [[String:String]]()
            for info in readInfo {
                var infoDetails = [String: String]()
                infoDetails["userId"] = UIDevice.UDID
                infoDetails["id"] = info.id
                infoDetails["type"] = info.type
                parameters.append(infoDetails)
            }
            
            Network().request(.offlineData, parameters: parameters) { data, response, error in
                if error == nil, data != nil {
                    let result = data!.jsonSerialized()
                    if let message = result[ApiResponseKeys.MESSAGE] as? String {
                        switch message {
                        case APIResponseMessage.NO_RESULT_FOUND_MESSAGE:
                            completionHandler(.fail)
                        case APIResponseMessage.SUCCESS_MESSAGE:
                            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ReadStatus.fetchRequest()
                            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            do { try CoreData.context.execute(batchDeleteRequest) }
                            catch { print("READ STATUS DELETION FAILED \(error.localizedDescription)")}
                            completionHandler(.sucess)
                        default: break
                        }
                    }
                } else {
                    completionHandler(.error)
                }
            }
        } catch {
            print(error)
        }
    }
}
