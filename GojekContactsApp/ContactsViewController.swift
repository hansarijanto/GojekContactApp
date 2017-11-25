//
//  ContactsViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/22/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, ContactManagerDelegate {
    
    // contacts/table data
    // the table view data assumes the following, contactsDict is pre sorted
    // contact section represent the title of the tbale sections
    // the contactsDict are keyed by it's prespective elements of contactsSection (alphabets in this instance)
    private(set) var contactsDict     : [String: [Contact]]  = [String: [Contact]]() // key is alphabet, value are contacts associated to tht alphabet
    private(set) var contactsSections : [String]             = [String]()
    
    // ui elements
    private let tableView      : UITableView             = UITableView()
    private let alphabetsLabel : UILabel                 = UILabel()
    
    private let fadeViewLabel  : UILabel                 = UILabel()
    private let activityView   : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private let fadeView       : UIView                  = UIView()
    
    private let downloadFailureAlert : UIAlertController = UIAlertController(title: "Failed to Download Contacts", message: nil, preferredStyle: .alert)
    
    // ui params
    private let navBarTitle            : String  = "Contacts"     // bar title (Contacts)
    private let backgroundColor        : UIColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0) // background color (light gray)
    public  let rowHeight              : CGFloat = 64.0
    private let fadeViewLabelFont      : UIFont  = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
    private let fadeViewLabelText      : String  = "Downloading Contacts"
    private let fadeViewLabelTextColor : UIColor = .white
    
    private let lightGreen : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    private let alphabetLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set navbar tint color
        self.navigationController?.navigationBar.tintColor = self.lightGreen
        
        // setup contacts data
        self.contactsDict     = ContactManager.shared.contactsSorted()
        self.contactsSections = ContactManager.alphabet
        
        // set initialized params
        self.title = self.navBarTitle
        self.view.backgroundColor = self.backgroundColor
        
        // setup table view
        self.tableView.contentInsetAdjustmentBehavior = .never // prevent odd animation of table view cells when pushing VC
        self.tableView.register(ContactTableCellView.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.backgroundColor
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdgesToSuperviewEdges()
        self.tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.alphabetLabel)
        self.alphabetLabel.autoPinEdge(toSuperviewEdge: .top)
        self.alphabetLabel.autoPinEdge(toSuperviewEdge: .bottom)
        self.alphabetLabel.autoPinEdge(toSuperviewEdge: .right)
        self.alphabetLabel.autoSetDimension(.width, toSize: 16.0)
        self.alphabetLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.alphabetLabel.textColor = .lightGray
        self.alphabetLabel.numberOfLines = -1
        self.alphabetLabel.text = "A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL\nM\nN\nO\nP\nQ\nR\nS\nT\nU\nV\nW\nX\nY\nZ"
        self.alphabetLabel.textAlignment = .center
        
        // setup loading view
        self.fadeView.frame = self.view.frame
        self.fadeView.backgroundColor = UIColor.black
        self.fadeView.alpha = 0.3
        self.fadeView.isHidden = true
        self.view.addSubview(fadeView)
        
        self.fadeView.addSubview(self.activityView)
        self.activityView.hidesWhenStopped = true
        self.activityView.autoAlignAxis(toSuperviewAxis: .vertical)
        self.activityView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        self.fadeView.addSubview(self.fadeViewLabel)
        self.fadeViewLabel.autoSetDimension(.height, toSize: 20.0)
        self.fadeViewLabel.autoPinEdge(toSuperviewEdge: .left)
        self.fadeViewLabel.autoPinEdge(toSuperviewEdge: .right)
        self.fadeViewLabel.autoPinEdge(.bottom, to: .top, of: self.activityView, withOffset: -30.0)
        self.fadeViewLabel.text = self.fadeViewLabelText
        self.fadeViewLabel.font = self.fadeViewLabelFont
        self.fadeViewLabel.textColor = self.fadeViewLabelTextColor
        self.fadeViewLabel.textAlignment = .center
        
        // setup failure alert
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            ContactManager.shared.fetchContacts()
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        self.downloadFailureAlert.addAction(okAction)
        self.downloadFailureAlert.addAction(cancelAction)
        
        // subscribe to contact manager
        ContactManager.shared.delegate = self
        // try to fetch contacts from Gojek
        ContactManager.shared.fetchContacts()
        
    }
    
    public func reloadData() {
        DispatchQueue.main.async {
            self.contactsDict = ContactManager.shared.contactsSorted()
            self.tableView.reloadData()
        }
    }
    
    // MARK: Loading view functions
    private func showLoadingUI() {
        DispatchQueue.main.async {
            self.fadeView.isHidden = false
            self.activityView.startAnimating()
        }
    }
    
    private func hideLoadingUI() {
        DispatchQueue.main.async {
            self.fadeView.isHidden = true
            self.activityView.stopAnimating()
        }
    }
    
    //MARK: Contact Manager Delegate
    func didDownloadContacts() {
        self.reloadData()
        self.hideLoadingUI()
    }
    
    func didFailToDownloadContactsNoResponse() {
        self.hideLoadingUI()
        DispatchQueue.main.async {
            self.downloadFailureAlert.message = "Please check your internet connection. Would you like to try again?"
            self.present(self.downloadFailureAlert, animated: true, completion: nil)
        }
    }
    
    func didFailToDownloadContactsEmptyResponse() {
        self.hideLoadingUI()
        DispatchQueue.main.async {
            self.downloadFailureAlert.message = "We found 0 contacts. Would you like to try again?"
            self.present(self.downloadFailureAlert, animated: true, completion: nil)
        }
    }
    
    func didStartDownload() {
        self.showLoadingUI()
    }
    
    func didDownloadContactsProgress(progress: Float) {
        DispatchQueue.main.async {
            self.fadeViewLabel.text = "\(self.fadeViewLabelText) (\(round(progress*1000.0)/10.0)%)"
        }
    }
}

// MARK: Table View Extension
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Table View Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableCellView
        let alphabet = self.contactsSections[indexPath.section]
        

        if let contacts = self.contactsDict[alphabet] {
            let contact = contacts[indexPath.row]
            
            // load product image
            if let contactImage = ContactManager.shared.loadContactImage(contact: contact) {
                DispatchQueue.main.async {
                    cell.contactImageView.image = contactImage
                }
            }
            DispatchQueue.main.async {
                cell.favoriteImageView.isHidden = !contact.isFavorite
                cell.nameTitleLabel.text = "\(contact.firstName!) \(contact.lastName!)"
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let alphabet = self.contactsSections[section]
        if let contacts = self.contactsDict[alphabet] {
            return contacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactsSections[section]
    }

    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let alphabet = self.contactsSections[indexPath.section]
        
        // display contact detail VC of selected contact
        if let contacts = self.contactsDict[alphabet] {
            let contact = contacts[indexPath.row]
            let contactDetailVC = ContactDetailViewController(contact: contact)
            contactDetailVC.listVC = self
            self.navigationController?.pushViewController(contactDetailVC, animated: true)
        }
    }
}

