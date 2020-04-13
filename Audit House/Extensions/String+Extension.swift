//
//  String+Extension.swift
//  Audit House
//
//  Created by Sandesh on 13/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation

extension String {
    
    func isValidContactNumber() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[0-9]{10}")
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
