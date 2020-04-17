//
//  Constants.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

struct Color {
    static let appTheme     = UIColor(red: 0.0, green: 0.85, blue: 1.0, alpha: 1.0)
    static let lightText    = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.0)
    static let darkText     = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.0)
}


struct APIResponseMessage {
    static let DEVICE_NOT_REGISTERED_MESSAGE = "Not Registered"
    static let DEVICE_NOT_ACTIVATED_MESSAGE = "Not Activated"
    static let SUCCESS_MESSAGE = "success"
    static let FAILED_MESSAGE = "fail"
    static let NO_RESULT_FOUND_MESSAGE = "No results found"
}

struct UserDefaultsKeys {
    static let DEVICE_TOKEN_KEY = "deviceToken"
    static let DEVICE_UDID_KEY = "deviceUDID"
    static let USER_INFO_KEY = "userInfo"
}


struct ApiResponseKeys {
    static let STATUS = "status"
    static let MESSAGE = "msg"
    static let RESULT = "result"
    static let DATA = "data"
}

struct APIResponseTypes {
    static let INFO = "home"
    static let REMINDERS = "reminder"
    static let NOTIFICATION = "notification"
}

struct DataReadTypes {
    static let HOME_INFO_READ = "impInfo"
    static let NOTIFICATION_INFO_READ = "notification"
    static let REMINDER_COUNT = "reminder"
}

struct Predicate {
    static let importantInfoPredicate = NSPredicate(format: "type == %@", APIResponseTypes.INFO)
    static let reminderPredicate = NSPredicate(format: "type == %@", APIResponseTypes.REMINDERS)
    static let notificationPredicate = NSPredicate(format: "type == %@", APIResponseTypes.NOTIFICATION)
}


enum CurrentInfoType {
      case important
      case reminder
      case notificaton
  }
  
