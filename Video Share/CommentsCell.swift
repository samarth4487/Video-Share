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
    
    func setupUI() {
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = ""
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
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
