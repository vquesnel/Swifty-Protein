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
    let infosLabelCellId = "infosLabelCellId"
    var infos : Infos?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.tableView.frame = CGRect(x: 5, y: 0, width: view.frame.width - 100, height: view.frame.height)
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.register(InfoCell.self, forCellReuseIdentifier: infosCellId)
        self.tableView.register(InfoLabelCell.self, forCellReuseIdentifier: infosLabelCellId)
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
        return i * 2
    }
    
    // CELLS TYPE
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var i = 0
        var datas = [String]()
        let cell = UITableViewCell()
        guard let infos = self.infos else { return cell }
        let mirror = Mirror(reflecting: infos.results[0])
        for child in mirror.children {
            if i == indexPath.item / 2 {
                let value: Any = child.value
                let subMirror = Mirror(reflecting: value)
                if subMirror.displayStyle == .optional {
                    datas = [resultsKeys[child.label!]!, String(describing: subMirror.children.first?.value ?? "N/A")]
                }
            }
            i += 1
        }
        if (indexPath.item % 2 == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: infosCellId, for: indexPath) as! InfoCell
            cell.value.text = datas[1]
            cell.backgroundColor =  C_DarkBackground
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: infosLabelCellId, for: indexPath) as! InfoLabelCell
            cell.label.text = "   \(datas[0])"
            cell.backgroundColor = UIColor(white: 1, alpha: 0.07)
            return cell
        }
    }
    
    // CELLS HEIGHT
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item % 2 {
            case 1 :
                return CGFloat(60)
            default :
                return CGFloat(30)
        }
    }
}
