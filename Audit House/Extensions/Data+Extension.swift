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
    
    func jsonSerialized() -> [String: Any]{
        let values: [String: Any]?
        do {
            values = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            fatalError("JSON conversion failed")
        }
        
        return values == nil ? [:] : values!
    }
}
