//
//  Infos.swift
//  Swifty-Protein
//
//  Created by Victor QUESNEL on 5/21/18.
//  Copyright © 2018 Kiefer WIESSLER. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    let value : UILabel = {
        let label = UILabel()
        label.textColor = C_TextLight
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
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
        
        addSubview(separator)
        addSubview(value)
        
        value.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -10).isActive = true
        value.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        value.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

