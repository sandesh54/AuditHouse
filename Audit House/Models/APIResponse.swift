//
//  APIResponse.swift
//  Audit House
//
//  Created by Sandesh on 13/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    var status: String
    var msg: String
    var data: User?
    var result: Count?
}
