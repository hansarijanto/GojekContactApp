//
//  ContactDetailViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

enum ContactDetailViewControllerMode {
    case view
    case edit
}

class ContactDetailIconButton: UIButton {
    
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = self.headerView.bounds
    }
}
