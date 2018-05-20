//
//  LigandCell.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 12/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit

class LigandCell: UITableViewCell {
    
    let name : UILabel = {
        let label = UILabel()
        label.textColor = C_TextLight
        label.translatesAutoresizingMaskIntoConstraints = false
        label.highlightedTextColor = .black
        return label
    }()
    
    let separator : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadingWheel : UIActivityIndicatorView = {
        let wheel = UIActivityIndicatorView()
        wheel.translatesAutoresizingMaskIntoConstraints = false
        return wheel
    }()
    
    let selectedView : UIView = {
        let view = UIView()
        view.backgroundColor = C_Blue
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .none
        
        addSubview(name)
        addSubview(separator)
        addSubview(loadingWheel)
        
        name.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        name.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        loadingWheel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        loadingWheel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

