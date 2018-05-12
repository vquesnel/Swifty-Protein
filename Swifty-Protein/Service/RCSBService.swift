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
            DispatchQueue.main.async { completion(file) }
        }.resume()
    }
    
}
