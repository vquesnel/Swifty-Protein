//
//  AtomLauncher.swift
//  Swifty-Protein
//
//  Created by Kiefer WIESSLER on 5/21/18.
//  Copyright © 2018 Kiefer WIESSLER. All rights reserved.
//

import UIKit


class AtomLauncher {
    

    var atom : Atom? {
        didSet {
            if let atom = self.atom {
                name.text = atomName[atom.type]
            }
        }
    }
    
    
    
    var isActive = false
    
    let shadowView = UIView()
    
    let name : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 40)
        label.layer.cornerRadius = 20
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.backgroundColor = C_Foreground
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    

    
    
    func show() -> Void {
        guard let window = UIApplication.shared.keyWindow else { return }
        isActive = true
        shadowView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        shadowView.frame = window.frame
        shadowView.alpha = 0
        name.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 50)
        
        window.addSubview(shadowView)
        window.addSubview(name)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.shadowView.alpha = 1
            self.name.frame = CGRect(x: 0, y: window.frame.height - 100, width: window.frame.width, height: 100)
        }, completion: nil)
    }
    
    @objc func hide() -> Void {
        UIView.animate(withDuration: 0.5) {
            guard let window = UIApplication.shared.keyWindow else { return }
            
            self.shadowView.alpha = 0
            self.name.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 100)
        }
    }
    
}
