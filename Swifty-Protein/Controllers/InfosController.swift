//
//  InfosController.swift
//  Swifty-Protein
//
//  Created by Victor QUESNEL on 5/21/18.
//  Copyright © 2018 Kiefer WIESSLER. All rights reserved.
//

import UIKit

class InfosController: UITableViewController {
    
    let infosCellId = "infosCellId"
    
    var infos : Infos?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(InfoCell.self, forCellReuseIdentifier: infosCellId)
        self.tableView.backgroundColor = C_DarkBackground
        self.tableView.separatorColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let infos = self.infos else { return 0 }
        let mirror = Mirror(reflecting: infos.results[0])
        var i  = 0
        for child in mirror.children {
            let value: Any = child.value
            let subMirror = Mirror(reflecting: value)
            if subMirror.displayStyle == .optional {
                if subMirror.children.count > 0 {
                    i += 1
                }
            }
            else {
                i += 1
            }
        }
        return i
    }
    
    // CELLS TYPE
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infosCellId, for: indexPath) as! InfoCell
        guard let infos = self.infos else { return cell }
        let mirror = Mirror(reflecting: infos.results[0])
        var i  = 0
        for child in mirror.children  {
            if i == indexPath.item {
                cell.label.text = "\(resultsKeys[child.label!]!) :"
                let value: Any = child.value
                let subMirror = Mirror(reflecting: value)
                if subMirror.displayStyle == .optional {
                    cell.value.text = "\(subMirror.children.first?.value ?? "N/A")"
                } else {
                    cell.value.text = "\(child.value)"
                }
            }
            i += 1
        }
        cell.backgroundColor = indexPath.item % 2 == 1 ? C_DarkBackground: UIColor(white: 0.8, alpha: 0.03)
        return cell
    }
    
    // CELLS HEIGHT
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
}
