//
//  File.swift
//  Audit House
//
//  Created by Sandesh on 25/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import NotificationCenter

struct PushNotification {
    var message: String
    
    init(notification: [String: AnyObject]) {
        if let message = notification["alert"] as? String {
            self.message = message
        } else {
            self.message = ""
        }
        
        NotificationCenter.default.post(name: .NewNotification, object: nil, userInfo: ["Notfication": self])
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.SHOW_NOTIFICATION_TAB)
    }
}
