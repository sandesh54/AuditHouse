//
//  NotificationCell.swift
//  Audit House
//
//  Created by Sandesh on 09/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

protocol ResponseCellDelegate {
    func didChangedView()
    func readOneMessage(type: CurrentInfoType)
}


class ResponseCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadowLayer()
    }
    private var info: ImportantInfo?
    private var reminder: Reminder?
    private var notification: Notifications?
    private var type: CurrentInfoType?
    
    static let identifier = "NotoficationCell"
    
    var delegate: ResponseCellDelegate?
    
    private var headerLable: UILabel = {
        let label                       = UILabel()
        label.textColor                 = .white
        label.font                      = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment             = .center
        label.numberOfLines             = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        return view
    }()
    
    private let headerView: UIView = {
        return UIView()
    }()
    
    private let messageLabel: UILabel  = {
        let label = UILabel()
        label.textColor = .darkText
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let seenButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("View More...", for: .normal)
        button.setImage(nil, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private let quickInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
        viewMoreButton.addTarget(self, action: #selector(markAsRead(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        headerView.backgroundColor = Color.lightText
    }
    
    func loadCell(notification: Notifications) {
        
        type = .notificaton
        self.notification = notification
        self.reminder = nil
        self.info = nil
        messageLabel.numberOfLines = 3
        
        viewMoreButton.setTitleColor(.black, for: .normal)
        if notification.msg_view_sts == "N" {
            headerView.backgroundColor = .orange
            seenButton.setImage(UIImage(named: "unread"), for: .normal)
        } else {
            headerView.backgroundColor = Color.lightText
            seenButton.setImage(UIImage(named: "read"), for: .normal)
        }
        headerLable.text = notification.nofification_date
        headerLable.textAlignment = .right
        messageLabel.text = notification.nofication_msg
        quickInfoLabel.text = ""
    }
    
    func loadCell(reminder: Reminder){
        
        type = .reminder
        self.notification = nil
        self.reminder = reminder
        self.info = nil
        messageLabel.numberOfLines = 3
        
        viewMoreButton.setTitleColor(.black, for: .normal)
        if reminder.msg_view_sts == "N" {
            headerView.backgroundColor = .orange
            seenButton.setImage(UIImage(named: "unread"), for: .normal)
        } else {
            headerView.backgroundColor = Color.lightText
            seenButton.setImage(UIImage(named: "read"), for: .normal)
        }
        headerLable.textAlignment = .center
        headerLable.text = reminder.reminder_name
        messageLabel.text = reminder.reminder_desc
        quickInfoLabel.text = "Expire On: \(reminder.reminder_end_date)"
    }
    
    func loadCell(informantion: ImportantInfo) {
        
        type = .important
        self.notification = nil
        self.reminder = nil
        self.info = informantion
        messageLabel.numberOfLines = 3
        
        viewMoreButton.setTitleColor(.black, for: .normal)
        if informantion.readStat == "N" {
            headerView.backgroundColor = .orange
            seenButton.setImage(UIImage(named: "unread"), for: .normal)
        } else {
            headerView.backgroundColor = Color.lightText
            seenButton.setImage(UIImage(named: "read"), for: .normal)
       }
        headerLable.textAlignment = .center
        headerLable.text = informantion.info_title
        messageLabel.text = informantion.info_description
        quickInfoLabel.text = ""
        
        
    }
    
    @objc private func markAsRead(_ sender: UIButton) {
        
        if messageLabel.numberOfLines == 0 {
            messageLabel.numberOfLines = 3
            viewMoreButton.setTitle("View More...", for: .normal)
            delegate?.didChangedView()
            return
        }
        
        self.messageLabel.numberOfLines = 0
        self.viewMoreButton.setTitle("View Less", for: .normal)
        self.seenButton.setImage(UIImage(named: "read"), for: .normal)
        self.headerView.backgroundColor = Color.lightText
        delegate?.didChangedView()
 
        var id = ""
        var readType = ""
        let readInfo = ReadStatus(context: CoreData.context)
        
        switch type! {

        case .important:
            guard let information = info, information.readStat == "N" else { return }
            
            id = information.line_id
            readType = DataReadTypes.HOME_INFO_READ
            readInfo.id = information.line_id
            readInfo.type = DataReadTypes.HOME_INFO_READ
            
        case .reminder:
            
            guard let remind = reminder, remind.msg_view_sts == "N" else { return }
            
            id =  remind.reminder_id
            readType = DataReadTypes.REMINDER_COUNT
            readInfo.id = reminder?.reminder_id
            readInfo.type =  DataReadTypes.REMINDER_COUNT
            
        case .notificaton:
            
            guard let noti = notification, noti.msg_view_sts == "N" else { return }
            
            id = noti.notification_id
            readType = DataReadTypes.NOTIFICATION_INFO_READ
            readInfo.id = notification?.notification_id
            readInfo.type = DataReadTypes.NOTIFICATION_INFO_READ
        }
        
        if Reachabiility.shared.isConnectedToNetWork {
            ReadInfoApiCall.async(id: id, type: readType) { status in
                switch status {
                    
                case .sucess:
                    self.delegate?.readOneMessage(type: self.type!)
                case .error:
                    try? CoreData.context.save()
                case .fail:
                    try? CoreData.context.save()
                }
            }
        } else {
            try? CoreData.context.save()
        }
    }
    
    private func setupViews() {
        setupCardView()
        setHeaderView()
        
        cardView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        cardView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
        ])
        
        let footerView = setupAndGetFooterView()
        cardView.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            footerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            footerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
            footerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func addShadowLayer() {
        cardView.layer.cornerRadius = 4
        cardView.clipsToBounds = true
        
        subviews.first?.removeFromSuperview()
        
        let shadowView = UIView(frame: cardView.bounds)
        shadowView.layer.cornerRadius = 4
        insertSubview(shadowView, at: 0)
        shadowView.center = cardView.center
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: shadowView.bounds.maxX, y: shadowView.bounds.minY))
        path.addLine(to: CGPoint(x: shadowView.bounds.maxX, y: shadowView.bounds.maxY))
        path.addLine(to: CGPoint(x: shadowView.bounds.minX, y: shadowView.bounds.maxY))
        path.close()
        
        shadowView.layer.shadowPath =  path.cgPath //UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowColor = Color.darkText.cgColor
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowView.layer.shadowOpacity = 0.33
        
    }
    
    private func setupCardView() {
        addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cardView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            cardView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func setHeaderView() {
        headerView.addSubview(headerLable)
        headerLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLable.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            headerLable.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
    
    private func setupAndGetFooterView() -> UIView {
        let footerView = UIView()
        footerView.isUserInteractionEnabled = true
        
        footerView.addSubview(seenButton)
        seenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seenButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            seenButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            seenButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            seenButton.heightAnchor.constraint(equalToConstant: 40),
            seenButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        footerView.addSubview(viewMoreButton)
        viewMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewMoreButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            viewMoreButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            viewMoreButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            viewMoreButton.heightAnchor.constraint(equalToConstant: 40),
            viewMoreButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        footerView.addSubview(quickInfoLabel)
        quickInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            quickInfoLabel.topAnchor.constraint(equalTo: footerView.topAnchor),
            quickInfoLabel.leadingAnchor.constraint(equalTo: seenButton.trailingAnchor),
            quickInfoLabel.trailingAnchor.constraint(equalTo: viewMoreButton.leadingAnchor),
            quickInfoLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
        ])
        
        return footerView
    }
}
