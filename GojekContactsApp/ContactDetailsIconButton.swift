//
//  ContactDetailsIconButton.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/26/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

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
