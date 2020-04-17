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
    
    
    func underLine() {
        let view = UIView(frame: CGRect(x: 0, y: CGFloat(self.bounds.height-2), width: self.bounds.width, height: 2))
        view.backgroundColor = .orange
        view.tag = 989
        addSubview(view)
    }
    
    func hideUnderLine() {
        for view in subviews {
            if view.tag == 989 { view.removeFromSuperview() }
        }
    }
}
