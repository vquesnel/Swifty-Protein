//
//  SearchController+Extension.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 13/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit

extension SearchController {
    
    static var clickedIndex = false
    
    // NUMBER OF CELLS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredLigands.count }
        else { return ligands.count }
    }
    
    // CELLS TYPE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCellID", for: indexPath) as! LigandCell
        
        if isSearching { cell.name.text = filteredLigands[indexPath.item] }
        else { cell.name.text = ligands[indexPath.item] }
        cell.backgroundColor = indexPath.item % 2 == 1 ? C_DarkBackground: UIColor(white: 0.8, alpha: 0.03)
        return cell
    }
    
    // CELLS HEIGHT
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }

    // CELLS SELECTION
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ligandController = LigandController()
        if (SearchController.clickedIndex) { return }
        SearchController.clickedIndex = true
        var name = String()
        let cell = tableView.cellForRow(at: indexPath) as! LigandCell
        cell.loadingWheel.startAnimating()
        cell.selectedBackgroundView = cell.selectedView
        if isSearching { name = filteredLigands[indexPath.item] }
        else { name = ligands[indexPath.item] }
        ligandController.title = name
        RCSBService.shared.getLigand(name: name) { data in
            if let ligand = data {
                ligandController.ligand = ligand
                SearchController.clickedIndex = false
                self.navigationController?.pushViewController(ligandController, animated: true)
                cell.loadingWheel.stopAnimating()
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else {
                SearchController.clickedIndex = false
                let alert = UIAlertController(title: "Error", message: "This Protein doesn't exists", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                cell.loadingWheel.stopAnimating()
                cell.backgroundColor = C_Error
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // SEARCHBAR FILTERING
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty { isSearching = false }
        else {
            filteredLigands = []
            isSearching = true
            for ligand in ligands {
                if (ligand.range(of: searchText.uppercased()) != nil) { filteredLigands.append(ligand) }
            }
        }
        tableView.reloadData()
    }
    
    
    // KEYBOARD DIMISS
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

