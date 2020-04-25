//
//  UIDevice+Extension.swift
//  Audit House
//
//  Created by Sandesh on 13/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import KeychainSwift

extension UIDevice {
    static var UDID: String {
        #warning("Temporary")
        return "E9971E20-02E7-4800-B616-06A35F0661B0"
        guard let udid = KeychainSwift().get(UserDefaultsKeys.DEVICE_UDID_KEY) else {
            let key = UIDevice.current.identifierForVendor!.uuidString
            KeychainSwift().set(key, forKey: UserDefaultsKeys.DEVICE_UDID_KEY)
            return key
        }
        return udid
    }
}
