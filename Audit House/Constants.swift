//
//  Constants.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

struct Color {
    static let appTheme     = UIColor(red: 0.0, green: 0.85, blue: 1.0, alpha: 1.0)
    static let lightText    = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.0)
    static let darkText     = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.0)
}


struct Constants {
    static let DEVICE_UDID_KEY = "deviceUDID"
    static let DEVICE_NOT_REGISTERED_MESSAGE = "Not Registered"
    static let DEVICE_NOT_ACTIVATED_MESSAGE = "Not Activated"
    static let DEVICE_TOKEN_KEY = "deviceToken"
    
    static let REGISTRATION_SUCCESS_MESSAGE = "success"
    static let REGISTRATION_FAILED_MESSAGE = "fail"
}


/*
 
 1: No of duplicate response not formatted
 Warning: PDOStatement::execute(): SQLSTATE[23000]: Integrity constraint violation: 1062 Duplicate entry
 'E9971E20-02E7-4800-B616-06A35F0661B0' for key 'device_imei_UNIQUE' in
 /var/sentora/hostdata/support/public_html/audithouse/application/model/rest.php on line 25
 
 2: FcmID cannot be null
 This scenarion cannot be garunteed
 
 3: No method is provided to update the fcm token which is possible scenario
*/
