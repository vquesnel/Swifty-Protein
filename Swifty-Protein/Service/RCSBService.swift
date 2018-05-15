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
    


    
    /* Creating an array of Ligands from ressource file  */
    
    func getRessource() -> [String] {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        return text.components(separatedBy: "\n").filter { $0 != "" }
    }
    
    
    
    
    
    /* Fetching 3D coordinates about a given Ligand */
    
    func getScenery(name: String, completion: @escaping(Ligand?) -> Void) {
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
            DispatchQueue.main.async {completion(self.parseData(file: file)) }
        }.resume()
    }
    
    
    
    
    
    /* Fetching informations about a given Ligand */
    
    func getInfos(name: String, completion: @escaping(Infos?) -> Void) {
        guard let url = URL(string: "https://rest.rcsb.org/rest/ligands/\(name)") else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        RequestService.shared.get(req: request, for: Infos.self) { data in
            guard let data = data else { completion(nil); return }
            completion(data)
        }
    }
    
    
    
    
    
    /* Return a complete Ligand */
    
    func getLigand(name: String, completion: @escaping(Ligand?) -> Void) {
        self.getScenery(name: name) { data in
            guard var ligand = data else { completion(nil); return }
            self.getInfos(name: name, completion: { data in
                guard let infos = data else { completion(nil); return }
                ligand.infos = infos
                completion(ligand)
            })
        }
    }
    
    
    
    
    /* Parsing SDF file */
    
    func parseData(file: String) -> Ligand? {
        let lines = file.components(separatedBy: "\n")
        let header = lines[3].components(separatedBy: " ").filter { $0 != "" }
        let totalAtom = Int(header[0])!
        let lastAtom = totalAtom + 3
        let lastBond = Int(header[1])! + lastAtom

        var atoms = [Atom]()
        var bonds = [Bond]()

        for i in 4...lastBond {
            let infos = lines[i].components(separatedBy: " ").filter { $0 != "" }
            if i <= lastAtom {
                guard var x = Double(infos[0]) else { return nil }
//                x = x / Double(totalAtom) + 2
                guard var y = Double(infos[1]) else { return nil }
//                y = y / Double(totalAtom) + 2
                guard var z = Double(infos[2]) else { return nil }
//                z = z / Double(totalAtom) + 2
        
                let atom = Atom(id: i - 3, type: infos[3], posX: x, posY: y, posZ: z)
                atoms.append(atom)
            } else {
                guard let left = Int(infos[0]), let right = Int(infos[1]), let links = Int(infos[2]) else { return nil }
                let bond = Bond(left: left, right: right, link: links)
                bonds.append(bond)
            }
        }
        return Ligand(name: lines[0], atoms: atoms, bonds: bonds, infos: nil)
    }
    
}
