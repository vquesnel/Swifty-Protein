//
//  SearchController.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 11/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit

class SearchController : UITableViewController, UISearchBarDelegate {
    
    let ligands : [String] = {
       return RCSBService.shared.parseFile()
    }()
    
    var filteredLigands = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        tableView.register(LigandCell.self, forCellReuseIdentifier: "ligandCellID")
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
        tableView.backgroundColor = C_DarkBackground
        
        setupNavBar()
        let controller = LoginController()
        navigationController?.present(controller, animated: false, completion: nil)
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

        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView = navigationTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredLigands.count }
        else { return ligands.count }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCellID", for: indexPath) as! LigandCell

        if isSearching { cell.name.text = filteredLigands[indexPath.item] }
        else { cell.name.text = ligands[indexPath.item] }
        
        cell.backgroundColor = indexPath.item % 2 == 1 ? .none : UIColor(white: 1, alpha: 0.03)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCellID", for: indexPath) as! LigandCell
        guard let name = cell.name.text else { return }
        print("Selected : \(name)")
        RCSBService.shared.getLigand(name: name) { data in
            guard let str = data else { print("zdp"); return }
            print(str)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty { isSearching = false }
        else {
            filteredLigands = []
            isSearching = true
            for ligand in ligands {
                if (ligand.range(of: searchText.uppercased()) != nil) { filteredLigands.append(ligand)}
            }
        }
        tableView.reloadData()
    }
    
}

