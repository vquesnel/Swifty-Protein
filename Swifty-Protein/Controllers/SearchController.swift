//
//  SearchController.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 11/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit

class SearchController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let loginController = LoginController()
    let ligandController = LigandController()
    
    let ligands : [String] = {
        return RCSBService.shared.getRessource()
    }()
    
    var filteredLigands = [String]()
    var isSearching = false
    
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(LigandCell.self, forCellReuseIdentifier: "ligandCellID")
        view.separatorColor = UIColor(white: 0, alpha: 0)
        view.backgroundColor = C_DarkBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var searchBar : UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage()
        bar.backgroundColor = C_Foreground
        bar.layer.cornerRadius = 10
        bar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        bar.clipsToBounds = true
        bar.barTintColor = .black
        bar.placeholder = "Search"
        bar.keyboardAppearance = .dark
        return bar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = C_DarkBackground
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        setupNavBar()
        authenticate()
    }
    
    
    
    func setupNavBar() {
        let navigationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 140, height: 22))
        
        navigationTitle.textColor = UIColor(white: 0, alpha: 0.6)
        navigationTitle.textAlignment = .center
        navigationTitle.text = "Ligands"
        navigationTitle.font = UIFont.boldSystemFont(ofSize: 22)
        
        navigationController?.navigationBar.barTintColor = C_Foreground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView = navigationTitle
    }
    
    
    func authenticate() {
        navigationController?.present(loginController, animated: false, completion: nil)
    }
    
    
}


