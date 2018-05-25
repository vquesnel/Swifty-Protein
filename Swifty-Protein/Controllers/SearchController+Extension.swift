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

    // ALAPHABETIC SCROLL
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearching {
            return nil
        }
        return sections
    }

    // SET HEADERS
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            return 1
        }
        return sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UIView()
        return cell
    }

    // CELL IN EACH HEADER
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredLigands.count }
        else {
            if sections[section] == "#" {
                return ligands.filter { Int(String($0.first!)) != nil }.count
            }
            return ligands.filter { $0.first == sections[section].first }.count
        }
    }


    // CELLS TYPE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCellID", for: indexPath) as! LigandCell
        if isSearching { cell.name.text = filteredLigands[indexPath.item] }
        else {
            if sections[indexPath.section] == "#" {
                cell.name.text = ligands.filter { Int(String($0.first!)) != nil }[indexPath.item]
            } else {
                cell.name.text = ligands.filter { $0.first == sections[indexPath.section].first }[indexPath.item]
            }
        }
        cell.backgroundColor = indexPath.item % 2 == 1 ? C_DarkBackground: UIColor(white: 0.8, alpha: 0.03)
        return cell
    }

    // CELLS HEIGHT
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if isSearching { return }
        view.backgroundColor = C_Background
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        separator.backgroundColor = UIColor(white:0, alpha: 0.15)
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 10, height: view.frame.height))
        label.text = sections[section]
        label.textColor = UIColor(white: 0, alpha: 0.6)
        view.addSubview(label)
        view.addSubview(separator)
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
        if isSearching {
            name = filteredLigands[indexPath.item]
            
        } else if sections[indexPath.section] == "#" {
            name = ligands.filter { Int(String($0.first!)) != nil }[indexPath.item]
        } else {
            name = ligands.filter { $0.first == sections[indexPath.section].first }[indexPath.item]
        }
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
            tableView.tableHeaderView = nil
            filteredLigands = []
            isSearching = true
            for ligand in ligands {
                if (ligand.range(of: searchText, options: .caseInsensitive) != nil) { filteredLigands.append(ligand) }
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
