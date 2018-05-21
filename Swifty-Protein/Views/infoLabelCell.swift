//
//  infoLabelCell.swift
//  Swifty-Protein
//
//  Created by Victor QUESNEL on 5/21/18.
//  Copyright © 2018 Kiefer WIESSLER. All rights reserved.
//

import UIKit

class InfoLabelCell: UITableViewCell {
    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = C_TextLight
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(label)
        addSubview(separator)
        
        label.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

