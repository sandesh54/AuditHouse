//
//  UIView+Extension.swift
//  Audit House
//
//  Created by Sandesh on 16/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {
    func showToast(_ message: String) {
        var style = ToastStyle()
        style.messageNumberOfLines = 0
        style.titleAlignment = .center
        style.titleColor = Color.appTheme
        style.backgroundColor = .black
        
        self.makeToast("Message", duration: TimeInterval(1.5), style: style)
    }
    
}
