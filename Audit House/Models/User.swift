//
//  User.swift
//  Audit House
//
//  Created by Sandesh on 14/04/20.
//  Copyright © 2020 S Solutions Pvt Ltd. All rights reserved.
//

import Foundation

/*{\"device_id\":\"128\",
 \      "device_imei\":\"E9971E20-02E7-4800-B616-06A35F0661B0\",
 \"device_msg_key\":\"1221\",
 \"device_model\":\"Iphone 11\",
 \"customer_name\":\"Sandesh Naik\",
 \"customer_contact\":\"8788891245\",
 \"firm_name\":\"DSPL\",
 \"is_active\":\"N\",
 \"register_date\":\"2020-04-13\",
 \"approved_by\":null,
 \"deleted\":\"N\",
 \"customer_id\":null}}
*/
struct User: Codable {
    var device_id: String
    var device_imei: String
    var device_msg_key: String?
    var device_model: String
    var customer_id: String
    var customer_name: String
    var customer_contact: String
    var firm_name: String
    var is_active: String
    var register_date: String
    var approved_by: String?
    var deleted: String
}
