//
//  BadgeButton.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class BadgeButton: UIButton {
    
    @IBInspectable
    var badgeText: String = "89232" {
        didSet { setupViews() }
    }
    
    @IBInspectable
    var badgeColor: UIColor = .systemRed {
        didSet  { setupViews() }
    }
    
    @IBInspectable
    var badgeTextColor: UIColor = .white {
        didSet { setupViews() }
    }
    
    @IBInspectable
    var isBadgeHidden:Bool = true {
        didSet {
            if isBadgeHidden {
                badgeLabel.isHidden = true
                
            } else {
                badgeLabel.isHidden = false
                setupViews()
            }
        }
    }
    
    private var badgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 1
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        var insets: UIEdgeInsets!
        if imageView?.image != nil {
            insets = imageEdgeInsets
        } else if titleLabel?.text != nil {
            insets = titleEdgeInsets
        } else {
            insets = .zero
        }
        
        badgeLabel.backgroundColor  = badgeColor
        badgeLabel.textColor        = badgeTextColor
        badgeLabel.text             = badgeText
        addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rightAnchorSpacing = insets.right - 20
        let topAnchorSpacing = insets.top
        
        NSLayoutConstraint.activate([
            badgeLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: rightAnchorSpacing),
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -topAnchorSpacing),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            badgeLabel.widthAnchor.constraint(equalToConstant: badgeLabel.intrinsicContentSize.width + 8)
        ])
        
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
