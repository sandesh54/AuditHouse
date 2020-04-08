//
//  CheckBox.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    enum State {
        case checked
        case unchecked
        
        mutating func toggle() {
            switch  self {
            case .checked: self = .unchecked
            case .unchecked: self = .checked
            }
        }
    }
    
    var status: State = .unchecked {
        didSet { updateState() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateState()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentMode = .scaleAspectFit
    }
    
    func updateState() {
        switch status {
        case .checked:
            setImage(UIImage(named: "checkedBox"), for: .normal)
            layer.borderColor = UIColor.clear.cgColor
        case .unchecked:
            setImage(nil, for: .normal)
            layer.borderColor = UIColor.black.cgColor
        }
        layer.borderWidth = 1
    }
}
