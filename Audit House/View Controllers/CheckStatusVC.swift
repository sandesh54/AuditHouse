//
//  CheckStatusVC.swift
//  Audit House
//
//  Created by Sandesh on 13/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class CheckStatusVC: UIViewController {

    private let homeScreenSegueway = "homeScreen"
    private let registrationSegueway = "registrationScreen"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            CheckDeviceApiCall.async { status in
                switch status {
                case .notRegistered:
                    self.performSegue(withIdentifier: self.registrationSegueway, sender: self)
                case .notActivated:
                    let message = ReviewMessageVC()
                    message.modalPresentationStyle = .fullScreen
                    self.present(message, animated:  true)
                case .success:
                    self.performSegue(withIdentifier: self.homeScreenSegueway, sender: self)
                case .error:
                    self.showNetworkError()
                }
            }        
    }
    
    private func setupView() {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 240),
            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
