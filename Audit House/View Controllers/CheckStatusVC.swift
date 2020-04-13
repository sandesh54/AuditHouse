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
        
        let parameters = [
            "imei": UIDevice.UDID
        ]
        
        Network.request(.checkDevice, parameters: parameters) { data, response, error in
            if error == nil, data != nil {
                let decoder = JSONDecoder()
                guard let apiResponse = try? decoder.decode(APIResponse.self, from: data!) else {
                    //handle response failure
                    return
                }
                print(apiResponse)
                if apiResponse.msg == Constants.DEVICE_NOT_REGISTERED_MESSAGE {
                    self.performSegue(withIdentifier: self.registrationSegueway, sender: self)
                } else if apiResponse.msg == Constants.DEVICE_NOT_ACTIVATED_MESSAGE {
//                    let message = ReviewMessageVC()
//                    message.modalPresentationStyle = .fullScreen
//                    present(message, animated:  true)
                    self.performSegue(withIdentifier: self.homeScreenSegueway, sender: self)
                }
            } else {
                #warning("handle error")
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
