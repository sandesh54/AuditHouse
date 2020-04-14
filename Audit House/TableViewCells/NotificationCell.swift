//
//  NotificationCell.swift
//  Audit House
//
//  Created by Sandesh on 09/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
         addShadowLayer()
    }
    
    static let identifier = "NotoficationCell"
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
        label.textColor = Color.darkText
        label.numberOfLines = 0
        return label
    }()
    
    private let seenButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private let viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("View More...", for: .normal)
        button.setImage(nil, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    private let quickInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.lightText
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
    }
    
    func loadCell() {
        headerView.backgroundColor = .orange
        headerLable.text = "Notification Header"
        messageLabel.text = "A UITableViewCell object is a specialized type of view that manages the content of a single table row. You use cells primarily to organize and present your app’s custom content, but UITableViewCell provides some specific customizations to support table-related behaviors, including"
        quickInfoLabel.text = "Expiring on: 20/12/2020"
        viewMoreButton.setTitle("View More...", for: .normal)
        viewMoreButton.setTitleColor(Color.darkText, for: .normal)
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
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        
        let shadowView = UIView(frame: cardView.bounds)
        shadowView.layer.cornerRadius = 8
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
            viewMoreButton.widthAnchor.constraint(equalToConstant: 80)
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
