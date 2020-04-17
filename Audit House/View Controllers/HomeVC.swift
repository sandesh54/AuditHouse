//
//  HomeVC.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    private var currentInfoType: CurrentInfoType?
    private var responseData: ResponseData? {
        didSet {
            if responseData != nil {
                generateUnderLyingData()
            }
        }
    }
    
    private var notifications: [Notifications]? { didSet { tableView.reloadData() } }
    private var reminders: [Reminder]? { didSet { tableView.reloadData() } }
    private var information: [ImportantInfo]? { didSet { tableView.reloadData() } }
    
    private var importantInfoButton: BadgeButton = {
        let button = BadgeButton()
        button.setTitle(nil, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "home"), for: .normal)
        button.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    private var remindersButton: BadgeButton = {
        let button = BadgeButton()
        button.setTitle(nil, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        button.isBadgeHidden = true
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
        tableView.register(ResponseCell.self, forCellReuseIdentifier: ResponseCell.identifier)
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
        getInfo()
        syncData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        importantInfoButton.superview?.underLine()
        remindersButton.superview?.hideUnderLine()
        notificationButton.superview?.hideUnderLine()
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
        
        
        stackView.addArrangedSubview(embedInView(importantInfoButton))
        stackView.addArrangedSubview(embedInView(remindersButton))
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
    private func generateUnderLyingData() {
         let jsonDecoder = JSONDecoder()
        if responseData!.type == APIResponseTypes.INFO {
            let data = Data(responseData!.rawData!.utf8)
            if let info = try? jsonDecoder.decode([ImportantInfo].self, from: data) {
                information = info
            }
        } else if responseData!.type == APIResponseTypes.REMINDERS {
            let data = Data(responseData!.rawData!.utf8)
            if let info = try? jsonDecoder.decode([Reminder].self, from: data) {
                reminders = info
            }
        } else if responseData!.type == APIResponseTypes.NOTIFICATION {
            let data = Data(responseData!.rawData!.utf8)
            if let info = try? jsonDecoder.decode([Notifications].self, from: data) {
                notifications = info
            }
        }
    }
    
    
    private func readCounts() {
        if Reachabiility.shared.isConnectedToNetWork {
        ReadCountsApiCall.async { staus, info, reminder, notification in
            switch staus {
            case .error: self.showNetworkError()
            case .sucess:
                self.importantInfoButton.badgeText = info
                self.notificationButton.badgeText = notification
            }
        }
        } else {
            self.importantInfoButton.badgeText = "0"
            self.notificationButton.badgeText = "0"
        }
    }
    
    private func getInfo() {
        
      
        
        currentInfoType = .important
        if Reachabiility.shared.isConnectedToNetWork {
            GetInfoApiCall.async { status, info in
                switch status {
                case .sucess:
                    self.responseData = CoreData.getResponseData(predicate: Predicate.importantInfoPredicate)
                case .error:
                    self.showNetworkError()
                }
            }
        } else {
            self.responseData = CoreData.getResponseData(predicate: Predicate.importantInfoPredicate)
        }
        
    }
    
    private func syncData() {
        if Reachabiility.shared.isConnectedToNetWork {
            SyncOfflineDataApiCall.async { status in
                switch status {
                case .sucess:
                    self.view.makeToast("Data Synced Sucessfully")
                case .error:
                    self.view.makeToast("Unable.syncData")
                case .fail:
                    self.view.makeToast("Unable.syncData")
                }
            }
        } else {
            // offline data is not synced
        }
        
    }
    
    @objc private func homeButtonTapped(_ sender: UIButton) {
        getInfo()
    }
    
    @objc private func infoButtonTapped(_ sender: UIButton) {
        
        importantInfoButton.superview?.hideUnderLine()
        remindersButton.superview?.underLine()
        notificationButton.superview?.hideUnderLine()
        
        currentInfoType = .reminder
        if Reachabiility.shared.isConnectedToNetWork {
            GetRemindersApiCall.async { status, reminders in
                switch status {
                case .sucess:
                    self.responseData = CoreData.getResponseData(predicate: Predicate.reminderPredicate)
                case .error:
                    self.showNetworkError()
                }
            }
        } else {
            self.responseData = CoreData.getResponseData(predicate: Predicate.reminderPredicate)
        }
    }
    
    @objc private func notificationButtonTapped(_ sender: UIButton) {
        
        importantInfoButton.superview?.hideUnderLine()
        remindersButton.superview?.hideUnderLine()
        notificationButton.superview?.underLine()
        
        currentInfoType = .notificaton
        if Reachabiility.shared.isConnectedToNetWork {
            GetNotificationApiCall.async { status, notifications in
                switch status {
                case .sucess:
                    self.responseData = CoreData.getResponseData(predicate: Predicate.notificationPredicate)
                case .error:
                    self.showNetworkError()
                }
            }
        } else {
            self.responseData = CoreData.getResponseData(predicate: Predicate.notificationPredicate)
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
        switch currentInfoType! {
        case .important:
            return information?.count ?? 0
        case .reminder:
            return reminders?.count ?? 0
        case .notificaton:
            return notifications?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: ResponseCell.identifier, for: indexPath) as? ResponseCell else {
            return UITableViewCell()
        }
        
        switch currentInfoType! {
        case .important:
            cell.loadCell(informantion: information![indexPath.row])
        case .reminder:
            cell.loadCell(reminder: reminders![indexPath.row])
        case .notificaton:
            cell.loadCell(notification: notifications![indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeVC: UITableViewDelegate {
    
}

extension HomeVC: ResponseCellDelegate {
    
    func readOneMessage(type: CurrentInfoType) {
        switch type {
        
        case .important:
            guard let count = Int(importantInfoButton.badgeText) else { return }
            importantInfoButton.badgeText = "\(count - 1)"
        case .reminder: break
        case .notificaton:
            guard let count = Int(notificationButton.badgeText) else { return }
            notificationButton.badgeText = "\(count - 1)"
        }
    }
    
    func didChangedView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
}
