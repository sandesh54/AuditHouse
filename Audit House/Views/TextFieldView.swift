//
//  TextFieldView.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class TextFieldView: UIView {

    var header: String = "" {
        didSet { textLabel.text = header }
    }
    
    var placeHolder: String = "" {
        didSet { textField.placeholder = placeHolder }
    }
    
    var keybordType: UIKeyboardType = .default {
        didSet { textField.keyboardType = keybordType }
    }
    
    // PRIVATE VARS
    private var textLabel: UILabel = {
        let lable           = UILabel()
        lable.font          = UIFont.systemFont(ofSize: 18)
        lable.textColor     = .darkText
        return lable
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        textField.leftView = paddingView
        return textField
    }()
    
    private var seperator: UIView = {
        let view            = UIView()
        view.backgroundColor = .darkText
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        //TEXT LABEL
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text                                      = header
        
        addConstraints([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // TEXT FIELD
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder                               = placeHolder
        textField.delegate                                  = self
        
        addConstraints([
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        
        //SEPERATOR VIEW
        addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            seperator.topAnchor.constraint(equalTo: textField.bottomAnchor),
            seperator.leftAnchor.constraint(equalTo: self.leftAnchor),
            seperator.rightAnchor.constraint(equalTo: self.rightAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textLabel.textColor         = Color.appTheme
        textField.textColor         = Color.darkText
        seperator.backgroundColor   = Color.appTheme
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textLabel.textColor         = Color.darkText
        textField.textColor         = Color.darkText
        seperator.backgroundColor   = Color.darkText
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

}


