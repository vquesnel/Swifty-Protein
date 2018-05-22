//
//  Parser.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 12/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import Foundation
import SceneKit

class RCSBService {

    static let shared = RCSBService()

    enum fileType : String {
        case ideal = "ideal"
        case model = "model"
    }

    /* Creating an array of Ligands from ressource file  */

    func getRessource() -> [String] {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        return text.components(separatedBy: "\n").filter { $0 != "" }.sorted()
    }

    /* Fetching 3D coordinates about a given Ligand */
    func getScenery(name: String, type: fileType, completion: @escaping(Ligand?) -> Void) {
        guard let url = URL(string: "https://files.rcsb.org/ligands/view/\(name)_\(type).sdf") else { return }
        URLSession.shared.dataTask(with: url) { data, res, error in
            guard let response = res as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            if (response.statusCode < 200 || response.statusCode > 299) {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            else {
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
                guard let ligands = self.parseData(file: file) else {
                    self.getScenery(name: name, type: .model, completion: { ligands in
                        DispatchQueue.main.async { completion(ligands) }
                    })
                    return
                }
                DispatchQueue.main.async { completion(ligands) }
            }
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
        self.getScenery(name: name, type: .ideal) { data in
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
        guard lines.first != "" else { return nil }
        let totalAtom = Int(lines[3][(0 ..< 3)].trim())!
        let lastAtom = totalAtom + 3
        let lastBond = Int(lines[3][(3 ..< 6)].trim())! + lastAtom
        var totalX = Double(0)
        var totalY = Double(0)
        var totalZ = Double(0)
        var atoms = [Atom]()
        var bonds = [Bond]()

        for i in 4...lastBond {
            let infos = lines[i].components(separatedBy: " ").filter { $0 != "" }
            if i <= lastAtom {
                guard let x = Double(infos[0]) else { return nil }
                guard let y = Double(infos[1]) else { return nil }
                guard let z = Double(infos[2]) else { return nil }
                totalX += x
                totalY += y
                totalZ += z
                let atom = Atom(id: i - 3, type: infos[3], posX: x, posY: y, posZ: z)
                atoms.append(atom)
            } else {
                guard let left = Int(lines[i][(0 ..< 3)].trim()), let right = Int(lines[i][(3 ..< 6)].trim()), let links = Int(infos[2]) else { return nil }
                let bond = Bond(left: left, right: right, link: links)
                bonds.append(bond)
            }
        }
        return Ligand(name: lines[0], atoms: atoms, bonds: bonds, infos: nil, centroid: SCNVector3(totalX / Double(totalAtom), totalY / Double(totalAtom),totalZ / Double(totalAtom)))
    }
}

extension String {

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return  String(self[start...end])
    }
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
