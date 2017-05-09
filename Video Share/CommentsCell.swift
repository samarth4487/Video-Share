//
//  CommentsCell.swift
//  Video Share
//
//  Created by Samarth Paboowal on 09/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    let textLabel = UILabel()
    let line = UIView()
    let profileImageView = UIImageView()
    
    func setupUI() {
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 15
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = ""
        textLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.gray
        line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
