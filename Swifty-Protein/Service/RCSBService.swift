//
//  Parser.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 12/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import Foundation

 class RCSBService {
    
    static let shared = RCSBService()
    
    func parseFile() -> [String] {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        return text.components(separatedBy: "\n").filter { $0 != "" }
    }
    
    func getLigand(name: String, completion: @escaping(String?) -> Void) {
        guard let url = URL(string: "https://files.rcsb.org/ligands/view/\(name)_model.sdf") else { return }
        URLSession.shared.dataTask(with: url) { data, res, error in
            guard error == nil, let data = data else {
                print("Request to rcsb.org failed.");
                DispatchQueue.main.async { completion(nil) }
                return
            }
            guard let file = String(data: data, encoding: .utf8) else {
                print("Data encoding failed.");
                DispatchQueue.main.async { completion(nil) }
                return
                
            }
            print(self.parseData(file: file))
            DispatchQueue.main.async {completion(file) }
        }.resume()
    }
    
    
    
    
    func parseData(file: String) -> Ligand? {
        let lines = file.components(separatedBy: "\n")
        let header = lines[3].components(separatedBy: " ").filter { $0 != "" }
        let lastAtom = Int(header[0])! + 3
        let lastBond = Int(header[1])! + lastAtom

        var atoms = [Atom]()
        var bonds = [Bond]()

        for i in 4...lastBond {
            let infos = lines[i].components(separatedBy: " ").filter { $0 != "" }
            if i <= lastAtom {
                guard let x =  Double(infos[0]), let y = Double(infos[1]), let z = Double(infos[2]) else { return nil }
                let atom = Atom(id: i - 3, type: infos[3], posX: x, posY: y, posZ: z)
                atoms.append(atom)
            } else {
                guard let left = Int(infos[0]), let right = Int(infos[1]), let links = Int(infos[2]) else { return nil }
                let bond = Bond(left: left, right: right, link: links)
                bonds.append(bond)
            }
        }
        return Ligand(name: lines[0], atoms: atoms, bonds: bonds)
    }
    
}
