//
//  ViewController.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 11/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit
import LocalAuthentication


class LoginController: UIViewController {
    
    lazy var searchController : SearchController = SearchController()
    
    let logo : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "appLogo")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let loginButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "fingerprint")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        return button
    }()
    
    let background = C_addBackground(image: "background")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(background)
        view.sendSubview(toBack: background)
        view.addSubview(loginButton)
        view.addSubview(logo)
        
        setConstraints()
    }
    
    @objc func authenticate(){
        let context = LAContext()
        let reason = "Please authenticate for login."
        
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // User did not authenticate successfully
                }
            }
        } else {
            // Handle Error
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.background.frame = UIScreen.main.bounds
        }, completion: { _ in })
    }
    
    func setConstraints() {
        
        
        logo.widthAnchor.constraint(equalToConstant: 230).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 80).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
}







