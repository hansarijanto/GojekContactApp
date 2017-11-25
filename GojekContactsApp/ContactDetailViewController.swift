//
//  ContactDetailViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit
import RealmSwift

enum ContactDetailViewControllerMode {
    case view
    case edit
}

class ContactDetailIconButton: UIButton {
    
    public  let iconImageView : UIImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.size.width / 2.0
        
        self.addSubview(self.iconImageView)
        self.iconImageView.isUserInteractionEnabled = false
        let inset = self.bounds.size.width / 3.7
        self.iconImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
}

class ContactDetailEditableLabel: UIView {
    
}

class ContactDetailViewController: UIViewController {
    // defining params
    private(set) var mode    : ContactDetailViewControllerMode = .view
    private(set) var contact : Contact
    
    // header elments
    private let headerView            : UIView          = UIView()
    private let gradient              : CAGradientLayer = CAGradientLayer()
    private let profileImageContainer : UIView          = UIView()
    private let profileImageView      : UIImageView     = UIImageView()
    private let nameLabel             : UILabel         = UILabel()
    
    // TODO: Create custom button UIView
    private let messageButton    : ContactDetailIconButton    = ContactDetailIconButton()
    private let callButton       : ContactDetailIconButton    = ContactDetailIconButton()
    private let emailButton      : ContactDetailIconButton    = ContactDetailIconButton()
    private let favoriteButton   : ContactDetailIconButton    = ContactDetailIconButton()
    private let messageLabel     : UILabel     = UILabel()
    private let callLabel        : UILabel     = UILabel()
    private let emailLabel       : UILabel     = UILabel()
    private let favoriteLabel    : UILabel     = UILabel()
    
    // TODO: Create custome for fields UIView
    private let firstNameEditableLabel : ContactDetailEditableLabel = ContactDetailEditableLabel()
    private let lastNameEditableLabel  : ContactDetailEditableLabel = ContactDetailEditableLabel()
    private let emailEditableLabel     : ContactDetailEditableLabel = ContactDetailEditableLabel()
    private let mobileEditableLabel    : ContactDetailEditableLabel = ContactDetailEditableLabel()
    
    // UI Params
    private let lightGreen : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusNavBarHeight: CGFloat = self.navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarFrame.size.height
        
        self.view.backgroundColor = .clear
        // remove nav bar separator
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.addSubview(self.headerView)
        self.headerView.autoPinEdge(toSuperviewEdge: .left)
        self.headerView.autoPinEdge(toSuperviewEdge: .right)
        self.headerView.autoPinEdge(toSuperviewEdge: .top)
        self.headerView.autoSetDimension(.height, toSize: 335.0 - statusNavBarHeight)
        
        self.headerView.backgroundColor = .white
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.gradient.colors = [UIColor.white.cgColor, lightGreen.cgColor]
        self.gradient.locations = [0.06, 1.0]
        self.gradient.opacity = 0.55
        self.headerView.layer.insertSublayer(self.gradient, at: 0)
        
        self.view.addSubview(self.profileImageContainer)
        self.profileImageContainer.backgroundColor = .white
        self.profileImageContainer.autoPinEdge(.top, to: .top, of: self.headerView, withOffset: 81.0 - statusNavBarHeight)
        self.profileImageContainer.autoAlignAxis(toSuperviewAxis: .vertical)
        let imageContainerWidth: CGFloat = 126.0
        self.profileImageContainer.autoSetDimensions(to: CGSize(width: imageContainerWidth, height: imageContainerWidth))
        self.profileImageContainer.clipsToBounds = true
        self.profileImageContainer.layer.cornerRadius = imageContainerWidth / 2.0
        
        self.profileImageContainer.addSubview(self.profileImageView)
        if let profImage = ContactManager.shared.loadContactImage(contact: self.contact) {
            self.profileImageView.image = profImage
        } else {
            self.profileImageView.image = UIImage(named: "missingContact")
        }
        self.profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.profileImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        let imageWidth = imageContainerWidth - 6.0
        self.profileImageView.autoSetDimensions(to: CGSize(width: imageWidth, height: imageWidth))
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = imageWidth / 2.0
        
        self.headerView.addSubview(self.nameLabel)
        self.nameLabel.autoPinEdge(.top, to: .bottom, of: self.profileImageContainer, withOffset: 8.0)
        self.nameLabel.autoPinEdge(toSuperviewMargin: .left)
        self.nameLabel.autoPinEdge(toSuperviewMargin: .right)
        self.nameLabel.textAlignment = .center
        self.nameLabel.autoSetDimension(.height, toSize: 20.0)
        self.nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        self.nameLabel.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        // icon params
        let iconWidth: CGFloat        = 44.0
        let iconSpacing: CGFloat      = 36.0
        let iconBottomMargin: CGFloat = 32.0
        let iconSideMargin: CGFloat   = (UIScreen.main.bounds.width - (3.0 * iconSpacing) - (4.0 * iconWidth)) / 2.0
        
        // constraint icons
        self.headerView.addSubview(self.messageButton)
        self.messageButton.autoPinEdge(.bottom, to: .bottom, of: self.headerView, withOffset: iconBottomMargin * -1.0)
        self.messageButton.autoPinEdge(.left, to: .left, of: self.headerView, withOffset: iconSideMargin)
        self.messageButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.messageButton.iconImageView.image = UIImage(named: "speechBubble")?.withRenderingMode(.alwaysTemplate)
        self.messageButton.iconImageView.tintColor = .white
        self.messageButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.callButton)
        self.callButton.autoPinEdge(.bottom, to: .bottom, of: self.headerView, withOffset: iconBottomMargin * -1.0)
        self.callButton.autoPinEdge(.left, to: .right, of: self.messageButton, withOffset: iconSpacing)
        self.callButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.callButton.iconImageView.image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
        self.callButton.iconImageView.tintColor = .white
        self.callButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.emailButton)
        self.emailButton.autoPinEdge(.bottom, to: .bottom, of: self.headerView, withOffset: iconBottomMargin * -1.0)
        self.emailButton.autoPinEdge(.left, to: .right, of: self.callButton, withOffset: iconSpacing)
        self.emailButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.emailButton.iconImageView.image = UIImage(named: "mail")?.withRenderingMode(.alwaysTemplate)
        self.emailButton.iconImageView.tintColor = .white
        self.emailButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.favoriteButton)
        self.favoriteButton.autoPinEdge(.bottom, to: .bottom, of: self.headerView, withOffset: iconBottomMargin * -1.0)
        self.favoriteButton.autoPinEdge(.left, to: .right, of: self.emailButton, withOffset: iconSpacing)
        self.favoriteButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.updateFavoriteButton()
        
        // register touch for icons
        self.messageButton.addTarget(self, action: #selector(ContactDetailViewController.didTapMessageIcon), for: .touchUpInside)
        self.callButton.addTarget(self, action: #selector(ContactDetailViewController.didTapCallIcon), for: .touchUpInside)
        self.emailButton.addTarget(self, action: #selector(ContactDetailViewController.didTapEmailIcon), for: .touchUpInside)
        self.favoriteButton.addTarget(self, action: #selector(ContactDetailViewController.didTapFavoriteIcon), for: .touchUpInside)
        
        var name = ""
        if let fn = self.contact.firstName {
            name = fn + " "
        }
        if let ln = self.contact.lastName {
            name = name + ln
        }
        self.nameLabel.text = name
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = self.headerView.bounds
    }
    
    // MARK: Icon Touch Callbacks
    @objc public func didTapMessageIcon() {
        print("tap message icon")
    }
    
    @objc public func didTapCallIcon() {
        print("tap call icon")
    }
    
    @objc public func didTapEmailIcon() {
        print("tap email icon")
    }
    
    private func updateFavoriteButton() {
        DispatchQueue.main.async {
            if self.contact.isFavorite {
                self.favoriteButton.iconImageView.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
                self.favoriteButton.iconImageView.tintColor = .white
                self.favoriteButton.backgroundColor = self.lightGreen
            } else {
                self.favoriteButton.iconImageView.image = UIImage(named: "starBorder")
                self.favoriteButton.backgroundColor = .white
            }
            self.favoriteButton.setNeedsDisplay()
        }
    }
    
    @objc public func didTapFavoriteIcon() {
        let realm: Realm = try! Realm()
        try! realm.write {
            self.contact.isFavorite = !self.contact.isFavorite
        }
        self.updateFavoriteButton()
    }
}
