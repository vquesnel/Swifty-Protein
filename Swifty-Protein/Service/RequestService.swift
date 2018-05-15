//
//  RequestService.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 13/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit



final class RequestService {
    
    static let shared = RequestService()
    
    func get<T: Decodable>(req: URLRequest, for type: T.Type, completion: @escaping(T?) -> Void) {
        URLSession.shared.dataTask(with: req) { data, res, err in
            guard err == nil else {
                DispatchQueue.main.async { completion(nil) }
                print("DataService : \(String(describing: err))")
                return
            }
            guard let getData = data else {
                DispatchQueue.main.async { completion(nil) }
                print("DataService : Data Not Recieved")
                return
            }
            guard let JSONData = try? JSONDecoder().decode(T.self, from: getData) else {
                DispatchQueue.main.async { completion(nil) }
                print("DataService : Fetching From Data to Model failed")
                return
            }
            DispatchQueue.main.async { completion(JSONData) }
            }.resume()
    }
    
    
}
