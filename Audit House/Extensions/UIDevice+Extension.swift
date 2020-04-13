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
        guard let udid = KeychainSwift().get("") else {
            let key = UIDevice.current.identifierForVendor!.uuidString
            KeychainSwift().set(key, forKey: Constants.DEVICE_UDID_KEY)
            return key
        }
        return udid
    }
}
