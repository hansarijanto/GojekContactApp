//
//  ContactDetailsTableCellView.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/26/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

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
