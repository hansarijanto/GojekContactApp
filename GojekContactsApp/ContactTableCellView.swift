//
//  ContactTableCellView.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

class ContactTableCellView: UITableViewCell {
    
    public let contactImageView   : UIImageView = UIImageView()
    public let nameTitleLabel     : UILabel     = UILabel()
    public let favoriteImageView  : UIImageView = UIImageView()
    
    private let contactImageWidth   : CGFloat = 40.0
    private let contactDefaultImage : UIImage = #imageLiteral(resourceName: "missingContact")
    private let favoriteImageWidth  : CGFloat = 18.0
    private let favoriteImage       : UIImage = #imageLiteral(resourceName: "star")
    private let favoriteImageTint   : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contactImageView.contentMode = .scaleAspectFit
        self.contactImageView.image = self.contactDefaultImage
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.cornerRadius = self.contactImageWidth / 2.0
        
        self.favoriteImageView.contentMode = .scaleAspectFit
        self.favoriteImageView.image       = self.favoriteImage.withRenderingMode(.alwaysTemplate)
        self.favoriteImageView.tintColor   = self.favoriteImageTint
        self.favoriteImageView.isHidden    = true
        
        self.contentView.addSubview(self.contactImageView)
        self.contentView.addSubview(self.nameTitleLabel)
        self.contentView.addSubview(self.favoriteImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contactImageView.autoSetDimensions(to: CGSize(width: self.contactImageWidth, height: self.contactImageWidth))
        self.contactImageView.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: 12.0)
        self.contactImageView.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: 16.0)
        
        self.nameTitleLabel.autoPinEdge(.left, to: .right, of: self.contactImageView, withOffset: 16.0)
        self.nameTitleLabel.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: 0.0)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .top)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .bottom)
        self.nameTitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
        
        self.favoriteImageView.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -32.0)
        self.favoriteImageView.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: 23.0)
        self.favoriteImageView.autoSetDimensions(to: CGSize(width: self.favoriteImageWidth, height: self.favoriteImageWidth))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.favoriteImageView.isHidden = true
        self.contactImageView.image     = self.contactDefaultImage
        self.nameTitleLabel.text        = nil
    }
}
