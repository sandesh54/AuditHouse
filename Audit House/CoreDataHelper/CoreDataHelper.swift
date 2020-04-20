//
//  Constant.swift
//  Messenger
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import CoreData

struct CoreData {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var container: NSPersistentContainer {
        return appDelegate.persistentContainer
    }
    
    static var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    
    static func deleteResponseData(predicate: NSPredicate) {
        let fetchRequest: NSFetchRequest<ResponseData> = ResponseData.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let data = try context.fetch(fetchRequest)
            for response in data {
                context.delete(response)
            }
        } catch {
            print("FAILED TO RETRIVE DATA FOR DELETION \n \(error.localizedDescription)")
        }
    }
    
    static func getResponseData(predicate: NSPredicate) -> ResponseData? {
        let fetchRequest: NSFetchRequest<ResponseData> = ResponseData.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let data = try context.fetch(fetchRequest)
            return data.first ?? nil
        } catch {
            print("FAILED TO RETRIVE DATA \n \(error.localizedDescription)")
        }
        return nil
    }
    
}
