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
    private let headerView       : UIView      = UIView()
    private let profileImageView : UIImageView = UIImageView()
    private let nameLabel        : UILabel     = UILabel()
    
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
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
