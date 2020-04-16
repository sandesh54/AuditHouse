//
//  Reminder.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import Foundation

struct Reminder: Codable {
    var reminder_id: String
    var reminder_name: String
    var reminder_desc: String
    var reminder_created_date: String
    var reminder_end_date: String
    var msg_view_sts: String
}
