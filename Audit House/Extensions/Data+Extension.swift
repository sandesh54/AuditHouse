//
//  Data+Extension.swift
//  Audit House
//
//  Created by Sandesh on 13/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation

extension Data {
    var tokenString: String {
        let token = self.map { String(format: "%02.2hhx", $0) }.joined()
        return token
    }
}
