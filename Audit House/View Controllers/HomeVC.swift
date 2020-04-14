//
//  HomeVC.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    private var homeButton: BadgeButton = {
        let button = BadgeButton()
        button.setTitle(nil, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "home"), for: .normal)
        button.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private var infoButton: BadgeButton = {
        let button = BadgeButton()
        button.setTitle(nil, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private var notificationButton: BadgeButton = {
        let button = BadgeButton()
        button.setTitle(nil, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "bell"), for: .normal)
        button.addTarget(self, action: #selector(notificationButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var headerView: UIView = {
        return UIView()
    }()
    
    private var tableView: UITableView  = {
        let tableView               = UITableView()
        tableView.rowHeight         = UITableView.automaticDimension
        tableView.allowsSelection   = false
        tableView.tableFooterView   = UIView()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        setupView()
        
        tableView.separatorStyle    = .none
        tableView.delegate          = self
        tableView.dataSource        = self
        readCounts()
    }
    
    private func configureNavigationController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color.appTheme
        appearance.shadowColor = nil
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.text = "Audit House"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About Us", style: .plain, target: self, action: #selector(showAboutUs))
    }
    
    private func setupView() {
        setupHeaderView()
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
      
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupHeaderView() {

        headerView.backgroundColor = Color.appTheme
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            stackView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0)
        ])
        
        
        stackView.addArrangedSubview(embedInView(homeButton))
        stackView.addArrangedSubview(embedInView(infoButton))
        stackView.addArrangedSubview(embedInView(notificationButton))
        
    }
    
    func embedInView(_ button: BadgeButton) -> UIView{
        let superView = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: superView.centerXAnchor)
        ])
        
        superView.backgroundColor = .clear
        return superView
    }
    
    
    //MARK:- CLASS METHODS
    private func readCounts() {
        let parameters = [
            "user_id": "1"
        ]
        Network.request(.readCount, parameters: parameters) { data, response, error in
            if error == nil, data != nil {
                let decoder = JSONDecoder()
                guard let apiResponse = try? decoder.decode(APIResponse.self, from: data!) else {
                    return
                }
                print(apiResponse)
                if apiResponse.result != nil {
                    self.homeButton.badgeText = "\(apiResponse.result!.reminder)"
                    self.infoButton.badgeText = apiResponse.result!.impInfo
                    self.notificationButton.badgeText = apiResponse.result!.notification
                }
                self.getInfo()
            } else {
                self.showNetworkError()
            }
        }
    }
    
    private func getInfo() {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        Network.request(.getInfo, parameters: parameters) { data, response, error in
            if error == nil, data != nil {
                let decoder = JSONDecoder()
                guard let apiResponse = try? decoder.decode(APIResponse.self, from: data!) else {
                    //handle response failure
                    return
                }
                print(apiResponse)
                if apiResponse.msg == Constants.DEVICE_NOT_REGISTERED_MESSAGE {
                   
                }
            } else {
                self.showNetworkError()
            }
        }
    }
    
    
    @objc private func homeButtonTapped(_ sender: UIButton) {
       getInfo()
    }
    
    @objc private func infoButtonTapped(_ sender: UIButton) {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        
        Network.request(.getReminders, parameters: parameters) { data, response, error in
            if error == nil, data != nil {
                let decoder = JSONDecoder()
                guard let apiResponse = try? decoder.decode(APIResponse.self, from: data!) else {
                    //handle response failure
                    return
                }
                print(apiResponse)
                if apiResponse.msg == Constants.DEVICE_NOT_REGISTERED_MESSAGE {
                   
                }
            } else {
                self.showNetworkError()
            }
        }
    }
    
    @objc private func notificationButtonTapped(_ sender: UIButton) {
        let parameters = [
            "imei": UIDevice.UDID
        ]
        
        Network.request(.getNotifications, parameters: parameters) { data, response, error in
            if error == nil, data != nil {
                let decoder = JSONDecoder()
                guard let apiResponse = try? decoder.decode(APIResponse.self, from: data!) else {
                    //handle response failure
                    return
                }
                print(apiResponse)
                if apiResponse.msg == Constants.DEVICE_NOT_REGISTERED_MESSAGE {
                   
                }
            } else {
                self.showNetworkError()
            }
        }
    }
    
    @objc private func showAboutUs() {
        let abtUS = AboutUsVC()
        abtUS.modalPresentationStyle = .overFullScreen
        abtUS.modalTransitionStyle = .crossDissolve
        self.present(abtUS, animated: true)
    }
    
    
}

extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        cell.loadCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeVC: UITableViewDelegate {
    
}
