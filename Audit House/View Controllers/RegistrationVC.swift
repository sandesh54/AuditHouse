//
//  RegistrationVC.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal           = false
        scrollView.alwaysBounceVertical             = false
        scrollView.showsHorizontalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator   = false
        return scrollView
    }()
    
    private var userNameField: TextFieldView = {
        let field            = TextFieldView()
        field.header        = "Name"
        field.placeHolder   = "Enter your name"
        field.isUserInteractionEnabled = true
        return field
    }()
    
    private var contactNumberField: TextFieldView = {
        let field           = TextFieldView()
        field.header        = "Contact Number"
        field.placeHolder   = "Enter Contact"
        field.keybordType   = .phonePad
        return field
    }()
    
    private var firmNameField: TextFieldView = {
        let field           = TextFieldView()
        field.header        = "Firm Name"
        field.placeHolder   = "Enter Firm Name"
        return field
    }()
    
    private var checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkBox.status = .unchecked
        return checkBox
    }()
    
    private var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.addTarget(self, action: #selector(signup(_:)), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = Color.lightText
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addKeyBoardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeKeyboardObserver()
    }
    
    //MARK:- PRIVATE FUNCS
    private func setupViews() {
        // SCROLL VIEW
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        let scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        scrollViewBottomConstraint.priority = UILayoutPriority.defaultLow
        view.addConstraint(scrollViewBottomConstraint)
        //scrollView.contentSize = view.bounds.size
        
        // BASE VIEW
        let baseView                                        = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints  = false
        baseView.clipsToBounds = true
        scrollView.addSubview(baseView)
        print(view.bounds.width)
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            baseView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            baseView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            baseView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            baseView.widthAnchor.constraint(equalToConstant: view.bounds.width),
        ])
        
        let imageView                                       = UIImageView()
        imageView.contentMode                               = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image                                     = UIImage(named: "logo")
        baseView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180),
        ])
        
        //STACK VIEW
        let stackView                                           = UIStackView()
        stackView.axis                                          = .vertical
        stackView.alignment                                     = .fill
        stackView.distribution                                  = .fill
        stackView.spacing                                       = 16
        stackView.translatesAutoresizingMaskIntoConstraints     = false
        baseView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
        ])
        
        
        stackView.addArrangedSubview(userNameField)
        stackView.addArrangedSubview(contactNumberField)
        stackView.addArrangedSubview(firmNameField)
        
        userNameField.translatesAutoresizingMaskIntoConstraints     = false
        contactNumberField.translatesAutoresizingMaskIntoConstraints     = false
        firmNameField.translatesAutoresizingMaskIntoConstraints          = false
        
        NSLayoutConstraint.activate([
            userNameField.heightAnchor.constraint(equalToConstant: 70),
            contactNumberField.heightAnchor.constraint(equalToConstant: 70),
            firmNameField.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        //ACKNOWLEDGE VIEW
        let ackView                                                 = setupAcknowledgeView()
        ackView.translatesAutoresizingMaskIntoConstraints           = false
        baseView.addSubview(ackView)
        
        NSLayoutConstraint.activate([
            ackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            ackView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            ackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
        ])
        
        baseView.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: ackView.bottomAnchor, constant: 24),
            signupButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            signupButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
            signupButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupAcknowledgeView() -> UIView {
        let acknowledgementView                             = UIView()
        let button                                          = checkBox
        button.translatesAutoresizingMaskIntoConstraints    = false
        acknowledgementView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: acknowledgementView.topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: acknowledgementView.leadingAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        let acknowledgeTextLabel                                        = UILabel()
        acknowledgeTextLabel.translatesAutoresizingMaskIntoConstraints  = false
        acknowledgeTextLabel.text                                       = " You can legally use this application only if you are associated with Audit House, Belgaum, Karnataka. By checking the box, you confirm the above statement."
        acknowledgeTextLabel.numberOfLines                              = 0
        acknowledgeTextLabel.textColor                                  = Color.darkText
        
        acknowledgementView.addSubview(acknowledgeTextLabel)
        
        NSLayoutConstraint.activate([
            acknowledgeTextLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -4),
            acknowledgeTextLabel.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            acknowledgeTextLabel.bottomAnchor.constraint(equalTo: acknowledgementView.bottomAnchor, constant: 8),
            acknowledgeTextLabel.trailingAnchor.constraint(equalTo: acknowledgementView.trailingAnchor, constant: 0)
        ])
        
        return acknowledgementView
    }
    
    
    @objc private func checkBoxTapped(_ sender: CheckBox) {
        sender.status.toggle()
         
        switch sender.status {
        case .checked:
            signupButton.isEnabled = true
            signupButton.backgroundColor = Color.appTheme
        case .unchecked:
            signupButton.isEnabled = false
            signupButton.backgroundColor = Color.lightText

        }
    }
    
    @objc private func signup(_ sender: UIButton) {
        userNameField.hideKeyboard()
        contactNumberField.hideKeyboard()
        firmNameField.hideKeyboard()
        
        validateAndRegisterUser()
        
    }
    
    private func validateAndRegisterUser(){
        
        guard  let userName = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), userName.count > 0 else {
            showAlert(title: "Error!", message: "Please Enter User Name")
            return
        }
        
        guard let contactNumber = contactNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines), contactNumber.count > 0 else {
            showAlert(title: "Error!", message: "Please Enter Contact Number")
            return
        }
        
        guard contactNumber.isValidContactNumber() else {
            showAlert(title: "Error!", message: "Invalid Contact Number")
            return
        }
        
        guard  let firmName = firmNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), firmName.count > 0 else {
            showAlert(title: "Error!", message: "Please Enter Firm Name")
            return
        }
        
        if Reachabiility.shared.isConnectedToNetWork {
            UserRegistrationApiCall.async(name: userName, contactNumber: contactNumber, firm: firmName) { status in
                switch status {
                case .sucess:
                    let reviewMessagVC = ReviewMessageVC()
                    reviewMessagVC.modalPresentationStyle = .overFullScreen
                    self.present(reviewMessagVC, animated: true)
                case .failed:
                    self.showAlert(title: "Error!", message: "Something went wrong, Unable to registere the user.")
                case .error:
                    self.showNetworkError()
                }
            }
            
        } else {
            showNetworkError()
        }
    }
  
    
    override func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
    }
}

