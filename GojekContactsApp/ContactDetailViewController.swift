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

class ContactDetailViewController: UIViewController {
    // defining params
    private(set) var mode    : ContactDetailViewControllerMode = .view
    private(set) var contact : Contact
    
    // header elments
    private let headerView       : UIView      = UIView()
    private let profileImageView : UIImageView = UIImageView()
    private let nameLabel        : UILabel     = UILabel()
    
    // TODO: Create custom button UIView
    private let messageButton    : UIButton    = UIButton()
    private let callButton       : UIButton    = UIButton()
    private let emailButton      : UIButton    = UIButton()
    private let favoriteButton   : UIButton    = UIButton()
    private let messageLabel     : UILabel     = UILabel()
    private let callLabel        : UILabel     = UILabel()
    private let emailLabel       : UILabel     = UILabel()
    private let favoriteLabel    : UILabel     = UILabel()
    
    // TODO: Create custome for fields UIView
    private let firstNameEditableLabel : UITextField = UITextField()
    private let lastNameEditableLabel  : UITextField = UITextField()
    private let emailEditableLabel     : UITextField = UITextField()
    private let mobileEditableLabel    : UITextField = UITextField()
    
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
