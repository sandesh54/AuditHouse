//
//  AboutUsVC.swift
//  Audit House
//
//  Created by Sandesh on 14/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {
    
    private let baseScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal           = false
        scrollView.alwaysBounceVertical             = false
        scrollView.showsHorizontalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator   = false
        return scrollView
    }()
    
    private let baseInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let headerLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.appTheme
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "ABOUT US"
        return label
    }()
    
    private let infoLable: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.numberOfLines = 0
        label.lineBreakMode  = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Color.appTheme, for: .normal)
        button.backgroundColor = .white
        button.setTitle("CLOSE", for: .normal)
        button.addTarget(self, action: #selector(hideInfo(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        setupView()
        
        infoLable.text = "Sanjay Kulkarni" + "\n\n" + "Mobile: 9845229205" + "\n\n" + "LandLine: 0831-4209201" + "\n\n" + "Email: sanjay.dbk@gmail.com" + "\n\n" + "Opp. Congress Well, Congress Road, Tilakwadi, Belguam - 590006"
        
        baseScrollView.contentSize.width = baseInfoView.bounds.width
    }
    
    private func setupView() {
        setupBaseViews()
        view.addSubview(baseInfoView)
        baseInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            baseInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            baseInfoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32),
            baseInfoView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            baseInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
        ])
    }
    
    private func setupBaseViews() {
        baseInfoView.addSubview(headerLable)
        headerLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLable.topAnchor.constraint(equalTo: baseInfoView.topAnchor),
            headerLable.leadingAnchor.constraint(equalTo: baseInfoView.leadingAnchor),
            headerLable.trailingAnchor.constraint(equalTo: baseInfoView.trailingAnchor),
            headerLable.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        baseInfoView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: baseInfoView.bottomAnchor, constant: -8),
            closeButton.trailingAnchor.constraint(equalTo: baseInfoView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        setupScrollView()
        
        baseInfoView.addSubview(baseScrollView)
        baseScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            baseScrollView.topAnchor.constraint(equalTo: headerLable.bottomAnchor),
            baseScrollView.leftAnchor.constraint(equalTo: baseInfoView.leftAnchor),
            baseScrollView.rightAnchor.constraint(equalTo: baseInfoView.rightAnchor),
            baseScrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor)
        ])
    }
    
    private func setupScrollView() {
        let imageView = UIImageView(image: UIImage(named: "LogoCircle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        baseScrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: baseScrollView.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: baseScrollView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
        ])
        
        baseScrollView.addSubview(infoLable)
        infoLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            infoLable.leadingAnchor.constraint(equalTo: baseScrollView.leadingAnchor),
            infoLable.trailingAnchor.constraint(equalTo: baseScrollView.trailingAnchor),
            infoLable.bottomAnchor.constraint(equalTo: baseScrollView.bottomAnchor),
            infoLable.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            //infoLable.heightAnchor.constraint(equalToConstant: 566)
        ])
    }
    
    @objc private func hideInfo(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
