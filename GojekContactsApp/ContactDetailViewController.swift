//
//  ContactDetailViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

enum ContactDetailTextFieldType {
    case firstname
    case lastname
    case mobile
    case email
    case unknown
}

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

class ContactDetailTableCellView: UITableViewCell, UITextFieldDelegate {
    
    public let mainLabel: UILabel = UILabel()
    public let contentField: UITextField = UITextField()
    private let cancelButton: UIButton = UIButton()
    private let cancelImage: UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.mainLabel.textAlignment = .right
        self.contentField.textAlignment = .left
        
        let mainFont: UIFont = UIFont.systemFont(ofSize: 16.0)
        self.mainLabel.font = mainFont
        self.mainLabel.textColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        
        let contentFont: UIFont = UIFont.systemFont(ofSize: 16.0)
        self.contentField.font = contentFont
        
        self.cancelImage.image = UIImage(named: "x")
        self.cancelButton.addTarget(self, action: #selector(ContactDetailTableCellView.didTapCancelButton), for: .touchUpInside)
        
        self.hideCancelButton(hide: true)
        
        self.contentView.addSubview(self.mainLabel)
        self.contentView.addSubview(self.contentField)
        self.contentView.addSubview(self.cancelImage)
        self.contentView.addSubview(self.cancelButton)
        
        self.contentField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mainLabel.autoPinEdge(toSuperviewEdge: .top)
        self.mainLabel.autoPinEdge(toSuperviewEdge: .bottom)
        self.mainLabel.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: 0.0)
        self.mainLabel.autoPinEdge(.right, to: .left, of: self.contentView, withOffset: 100.0)
        
        self.cancelImage.autoSetDimensions(to: CGSize(width: 15.0, height: 15.0))
        self.cancelImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.cancelImage.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -15.0)
        
        self.cancelButton.autoPinEdge(toSuperviewEdge: .top)
        self.cancelButton.autoPinEdge(toSuperviewEdge: .bottom)
        self.cancelButton.autoPinEdge(toSuperviewEdge: .right)
        self.cancelButton.autoSetDimension(.width, toSize: 45.0)
        
        self.contentField.autoPinEdge(toSuperviewEdge: .top)
        self.contentField.autoPinEdge(toSuperviewEdge: .bottom)
        self.contentField.autoPinEdge(.left, to: .right, of: self.mainLabel, withOffset: 32.0)
        self.contentField.autoPinEdge(.right, to: .left, of: self.cancelButton, withOffset: 0.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.hideCancelButton(hide: true)
    }
    
    @objc public func didTapCancelButton() {
        self.contentField.text = ""
    }
    
    public func hideCancelButton(hide: Bool) {
        self.cancelImage.isHidden = hide
        self.cancelButton.isHidden = hide
    }
    
    // MARK: UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideCancelButton(hide: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideCancelButton(hide: true)
    }
}

class ContactDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    // defining params
    private(set) var mode    : ContactDetailViewControllerMode = .view {
        didSet {
            self.updateUIForMode()
        }
    }
    private(set) var contact : Contact
    
    // header elments
    private let headerView            : UIView          = UIView()
    private let gradient              : CAGradientLayer = CAGradientLayer()
    private let profileImageContainer : UIView          = UIView()
    private let profileImageView      : UIImageView     = UIImageView()
    private let nameLabel             : UILabel         = UILabel()
    
    private let messageButton    : ContactDetailIconButton    = ContactDetailIconButton()
    private let callButton       : ContactDetailIconButton    = ContactDetailIconButton()
    private let emailButton      : ContactDetailIconButton    = ContactDetailIconButton()
    private let favoriteButton   : ContactDetailIconButton    = ContactDetailIconButton()
    private let messageLabel     : UILabel     = UILabel()
    private let callLabel        : UILabel     = UILabel()
    private let emailLabel       : UILabel     = UILabel()
    private let favoriteLabel    : UILabel     = UILabel()
    
    // UI Params
    private let lightGreen : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    private var headerConstraint : NSLayoutConstraint? = nil
    private let headerLabelOffset: CGFloat = 12.0
    
    //table view
    private let tableView: UITableView = UITableView()
    private var activeTextField: UITextField? = nil
    private var doneButton: UIBarButtonItem? = nil
    private var editButton: UIBarButtonItem? = nil
    private var backButton: UIBarButtonItem? = nil
    private var cancelButton: UIBarButtonItem? = nil
    
    private(set) var didUpdateContact: Bool = false
    
    public weak var listVC: ContactsViewController? = nil
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        
        // set nav bar item
        self.doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ContactDetailViewController.didTapDoneButton))
        
        self.editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(ContactDetailViewController.didTapEditButton))
        
        self.cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(ContactDetailViewController.didTapCancelButton))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navbar tint color
        self.navigationController?.navigationBar.tintColor = self.lightGreen
        
        self.view.backgroundColor = .clear
        // remove nav bar separator
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.addSubview(self.headerView)
        self.headerView.autoPinEdge(toSuperviewEdge: .left)
        self.headerView.autoPinEdge(toSuperviewEdge: .right)
        self.headerView.autoPinEdge(toSuperviewEdge: .top)
        
        self.headerView.backgroundColor = .white
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.gradient.colors = [UIColor.white.cgColor, lightGreen.cgColor]
        self.gradient.locations = [0.06, 1.0]
        self.gradient.opacity = 0.55
        self.headerView.layer.insertSublayer(self.gradient, at: 0)
        
        self.view.addSubview(self.profileImageContainer)
        self.profileImageContainer.backgroundColor = .white
        self.profileImageContainer.autoPinEdge(.top, to: .top, of: self.headerView, withOffset: 17.0)
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
        self.nameLabel.autoSetDimension(.height, toSize: 24.0)
        self.nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        self.nameLabel.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        // icon params
        let iconWidth: CGFloat        = 44.0
        let iconSpacing: CGFloat      = 36.0
        let iconSideMargin: CGFloat   = (UIScreen.main.bounds.width - (3.0 * iconSpacing) - (4.0 * iconWidth)) / 2.0
        
        // constraint icons
        self.headerView.addSubview(self.messageButton)
        self.messageButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.messageButton.autoPinEdge(.left, to: .left, of: self.headerView, withOffset: iconSideMargin)
        self.messageButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.messageButton.iconImageView.image = UIImage(named: "speechBubble")?.withRenderingMode(.alwaysTemplate)
        self.messageButton.iconImageView.tintColor = .white
        self.messageButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.callButton)
        self.callButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.callButton.autoPinEdge(.left, to: .right, of: self.messageButton, withOffset: iconSpacing)
        self.callButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.callButton.iconImageView.image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
        self.callButton.iconImageView.tintColor = .white
        self.callButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.emailButton)
        self.emailButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.emailButton.autoPinEdge(.left, to: .right, of: self.callButton, withOffset: iconSpacing)
        self.emailButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.emailButton.iconImageView.image = UIImage(named: "mail")?.withRenderingMode(.alwaysTemplate)
        self.emailButton.iconImageView.tintColor = .white
        self.emailButton.backgroundColor = self.lightGreen
        
        self.headerView.addSubview(self.favoriteButton)
        self.favoriteButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.favoriteButton.autoPinEdge(.left, to: .right, of: self.emailButton, withOffset: iconSpacing)
        self.favoriteButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.updateFavoriteButton()
        
        // register touch for icons
        self.messageButton.addTarget(self, action: #selector(ContactDetailViewController.didTapMessageIcon), for: .touchUpInside)
        self.callButton.addTarget(self, action: #selector(ContactDetailViewController.didTapCallIcon), for: .touchUpInside)
        self.emailButton.addTarget(self, action: #selector(ContactDetailViewController.didTapEmailIcon), for: .touchUpInside)
        self.favoriteButton.addTarget(self, action: #selector(ContactDetailViewController.didTapFavoriteIcon), for: .touchUpInside)
        
        self.headerView.addSubview(self.messageLabel)
        self.headerView.addSubview(self.callLabel)
        self.headerView.addSubview(self.emailLabel)
        self.headerView.addSubview(self.favoriteLabel)
        
        let iconFont = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        let iconFontColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        
        let iconButtonOffset: CGFloat = 10.0
        
        self.messageLabel.text = "message"
        self.messageLabel.font = iconFont
        self.messageLabel.textColor = iconFontColor
        self.messageLabel.textAlignment = .center
        self.messageLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.messageLabel.autoAlignAxis(.vertical, toSameAxisOf: self.messageButton)
        self.messageLabel.autoPinEdge(.top, to: .bottom, of: self.messageButton, withOffset: iconButtonOffset)
        
        self.callLabel.text = "call"
        self.callLabel.font = iconFont
        self.callLabel.textColor = iconFontColor
        self.callLabel.textAlignment = .center
        self.callLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.callLabel.autoAlignAxis(.vertical, toSameAxisOf: self.callButton)
        self.callLabel.autoPinEdge(.top, to: .bottom, of: self.callButton, withOffset: iconButtonOffset)
        
        self.emailLabel.text = "email"
        self.emailLabel.font = iconFont
        self.emailLabel.textColor = iconFontColor
        self.emailLabel.textAlignment = .center
        self.emailLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.emailLabel.autoAlignAxis(.vertical, toSameAxisOf: self.emailButton)
        self.emailLabel.autoPinEdge(.top, to: .bottom, of: self.emailButton, withOffset: iconButtonOffset)
        
        self.favoriteLabel.text = "favorite"
        self.favoriteLabel.font = iconFont
        self.favoriteLabel.textColor = iconFontColor
        self.favoriteLabel.textAlignment = .center
        self.favoriteLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.favoriteLabel.autoAlignAxis(.vertical, toSameAxisOf: self.favoriteButton)
        self.favoriteLabel.autoPinEdge(.top, to: .bottom, of: self.favoriteButton, withOffset: iconButtonOffset)
        
        self.headerConstraint = self.headerView.autoPinEdge(.bottom, to: .bottom, of: self.callLabel, withOffset: self.headerLabelOffset)
        
        self.nameLabel.text = self.contact.name()
        
        // table view setup
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.headerView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView() // remove extra table view cells
        self.tableView.register(ContactDetailTableCellView.self, forCellReuseIdentifier: "ContactDetailCell")
        self.tableView.isScrollEnabled = false
        
        self.backButton = self.navigationItem.leftBarButtonItem
        self.updateUIForMode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set gradient frame
        self.gradient.frame = self.headerView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // tell listVC to update data only if contact has been updated
        if self.didUpdateContact {
            self.listVC?.reloadData()
        }
    }
    
    private func updateUIForMode() {
        DispatchQueue.main.async {
            if self.mode == .edit {
                self.navigationItem.rightBarButtonItem = self.doneButton
                self.navigationItem.leftBarButtonItem = self.cancelButton
                self.tableView.isUserInteractionEnabled = true
                
                self.messageButton.isUserInteractionEnabled = false
                self.callButton.isUserInteractionEnabled = false
                self.emailButton.isUserInteractionEnabled = false
                self.favoriteButton.isUserInteractionEnabled = false
                
                self.headerConstraint?.constant = self.headerLabelOffset - 110.0
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageButton.alpha = 0.0
                    self.callButton.alpha = 0.0
                    self.emailButton.alpha = 0.0
                    self.favoriteButton.alpha = 0.0
                    self.nameLabel.alpha = 0.0
                    self.messageLabel.alpha = 0.0
                    self.callLabel.alpha = 0.0
                    self.emailLabel.alpha = 0.0
                    self.favoriteLabel.alpha = 0.0
                    self.view.layoutIfNeeded()
                })
                
            } else if self.mode == .view {
                self.navigationItem.rightBarButtonItem = self.editButton
                self.navigationItem.leftBarButtonItem = self.backButton
                self.tableView.isUserInteractionEnabled = false
                
                self.headerConstraint?.constant = self.headerLabelOffset
                UIView.animate(withDuration: 0.2, animations: {
                    if self.contact.mobile != nil {
                        self.callButton.backgroundColor = self.lightGreen
                        self.messageButton.backgroundColor = self.lightGreen
                    } else {
                        self.callButton.backgroundColor = .lightGray
                        self.messageButton.backgroundColor = .lightGray
                    }
                    if self.contact.email != nil {
                        self.emailButton.backgroundColor = self.lightGreen
                    } else {
                        self.emailButton.backgroundColor = .lightGray
                    }
                    self.callButton.alpha = 1.0
                    self.messageButton.alpha = 1.0
                    self.emailButton.alpha = 1.0
                    self.nameLabel.alpha = 1.0
                    self.favoriteButton.alpha = 1.0
                    self.messageLabel.alpha = 1.0
                    self.callLabel.alpha = 1.0
                    self.emailLabel.alpha = 1.0
                    self.favoriteLabel.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    if finished {
                        self.messageButton.isUserInteractionEnabled = self.contact.mobile != nil
                        self.callButton.isUserInteractionEnabled = self.contact.mobile != nil
                        self.emailButton.isUserInteractionEnabled = self.contact.email != nil
                        self.favoriteButton.isUserInteractionEnabled = true
                    }
                })
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Icon Touch Callbacks
    @objc public func didTapMessageIcon() {
        if let mobile = self.contact.mobile, MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.recipients = [mobile]
            composeVC.messageComposeDelegate = self
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc public func didTapCallIcon() {
        if let mobile = self.contact.mobile, let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc public func didTapEmailIcon() {
        if let email = self.contact.email, MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            self.present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func updateFavoriteButton() {
        DispatchQueue.main.async {
            if self.contact.isFavorite {
                self.favoriteButton.iconImageView.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
                self.favoriteButton.iconImageView.tintColor = .white
                self.favoriteButton.backgroundColor = self.lightGreen
            } else {
                self.favoriteButton.iconImageView.image = UIImage(named: "starBorder")
                self.favoriteButton.tintColor = .lightGray
                self.favoriteButton.backgroundColor = .white
            }
            self.favoriteButton.setNeedsDisplay()
        }
    }
    
    @objc public func didTapFavoriteIcon() {
        let realm: Realm = try! Realm()
        try! realm.write {
            self.contact.isFavorite = !self.contact.isFavorite
            self.didUpdateContact = true
        }
        self.updateFavoriteButton()
    }
    
    // MARK: Navigation Bar Item Callback
    @objc public func didTapCancelButton() {
        self.activeTextField?.resignFirstResponder()
        
        let firstNameTF = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ContactDetailTableCellView).contentField
        let lastNameTF = (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ContactDetailTableCellView).contentField
        let mobileTF = (self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ContactDetailTableCellView).contentField
        let emailTF = (self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! ContactDetailTableCellView).contentField
        
        DispatchQueue.main.async {
            firstNameTF.text = self.contact.firstName
            lastNameTF.text = self.contact.lastName
            mobileTF.text = self.contact.mobile
            emailTF.text = self.contact.email
        }
        
        self.activeTextField = nil
        self.mode = .view
    }
    
    @objc public func didTapDoneButton() {
        self.activeTextField?.resignFirstResponder()
        
        // update contact
        let realm: Realm = try! Realm()
        try! realm.write {
            let firstNameTF = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ContactDetailTableCellView).contentField
            let lastNameTF = (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ContactDetailTableCellView).contentField
            let mobileTF = (self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ContactDetailTableCellView).contentField
            let emailTF = (self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! ContactDetailTableCellView).contentField
            
            if let fn = firstNameTF.text {
                if fn == "" {
                    contact.firstName = nil
                } else if contact.firstName == nil || contact.firstName! != fn {
                    contact.firstName = fn
                }
                self.didUpdateContact = true
            }
            
            if let ln = lastNameTF.text {
                if ln == "" {
                    contact.lastName = nil
                } else if contact.lastName == nil || contact.lastName! != ln {
                    contact.lastName = ln
                }
                self.didUpdateContact = true
            }
            
            if let mobile = mobileTF.text {
                if mobile == "" {
                    contact.mobile = nil
                } else if contact.mobile == nil || contact.mobile! != mobile {
                    contact.mobile = mobile
                }
                self.didUpdateContact = true
            }
            
            if let email = emailTF.text {
                if email == "" {
                    contact.email = nil
                } else if contact.email == nil || contact.email! != email {
                    contact.email = email
                }
                self.didUpdateContact = true
            }
        }
        
        self.activeTextField = nil
        self.mode = .view
    }
    
    // MARK: Navigation Bar Item Callback
    @objc public func didTapEditButton() {
        self.mode = .edit
    }
    
    // MARK: Table View Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 58.0
        
        
        if self.mode == .view {
            // only return height if the contact info on the row is not nil, otherwise hide it by having 0.00 height
            if indexPath.row == 0 && self.contact.firstName != nil {
                return height
            }
            
            if indexPath.row == 1 && self.contact.lastName != nil {
                return height
            }
            
            if indexPath.row == 2 && self.contact.mobile != nil {
                return height
            }
            
            if indexPath.row == 3 && self.contact.email != nil {
                return height
            }
            
            return 0.0
        } else {
            // if editing show all
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell") as! ContactDetailTableCellView
        
        if indexPath.row == 0 {
            cell.mainLabel.text = "First Name"
            cell.contentField.text = self.contact.firstName
            cell.contentField.keyboardType = .namePhonePad
        } else if indexPath.row == 1 {
            cell.mainLabel.text = "Last Name"
            cell.contentField.text = self.contact.lastName
            cell.contentField.keyboardType = .namePhonePad
        } else if indexPath.row == 2 {
            cell.mainLabel.text = "mobile"
            cell.contentField.text = self.contact.mobile
            cell.contentField.keyboardType = .phonePad
        } else if indexPath.row == 3 {
            cell.mainLabel.text = "email"
            cell.contentField.text = self.contact.email
            cell.contentField.keyboardType = .emailAddress
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // MARK: Table View Delegate
    private func textFieldOfType(tf: UITextField) -> ContactDetailTextFieldType {
        
        let firstNameTF = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ContactDetailTableCellView).contentField
        if firstNameTF == tf {
            return .firstname
        }
        
        let lastNameTF = (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ContactDetailTableCellView).contentField
        if lastNameTF == tf {
            return .lastname
        }
        
        let mobileTF = (self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ContactDetailTableCellView).contentField
        if mobileTF == tf {
            return .mobile
        }
        
        let emailTF = (self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! ContactDetailTableCellView).contentField
        if emailTF == tf {
            return .email
        }
        
        return .unknown
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
