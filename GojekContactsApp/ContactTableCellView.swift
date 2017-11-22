//
//  ContactTableCellView.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

class ContactTableCellView: UITableViewCell {
    
    public let contactImage   : UIImageView = UIImageView()
    public let nameTitleLabel : UILabel     = UILabel()
    
    private let contactImageWidth : CGFloat   = 40.0
    private let contactDefaultImage : UIImage = #imageLiteral(resourceName: "missingContact")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contactImage.contentMode = .scaleAspectFit
        self.contactImage.image = self.contactDefaultImage
        self.contactImage.clipsToBounds = true
        self.contactImage.layer.cornerRadius = self.contactImageWidth / 2.0
        
        self.contentView.addSubview(self.contactImage)
        self.contentView.addSubview(self.nameTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contactImage.autoSetDimensions(to: CGSize(width: self.contactImageWidth, height: self.contactImageWidth))
        self.contactImage.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: 12.0)
        self.contactImage.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: 16.0)
        
        self.nameTitleLabel.autoPinEdge(.left, to: .right, of: self.contactImage, withOffset: 16.0)
        self.nameTitleLabel.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: 0.0)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .top)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .bottom)
        self.nameTitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
    }
}
