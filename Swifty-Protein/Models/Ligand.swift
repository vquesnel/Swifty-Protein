//
//  Ligand.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 12/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit


struct Results : Decodable {
    let formula : String
    let type : String
}

struct Infos : Decodable {
    let results : [Results]
}


struct Atom {
    let id : Int
    let type : String
    let posX : Double
    let posY : Double
    let posZ : Double
}

struct Bond {
    let left : Int
    let right : Int
    let link : Int
}

struct Ligand {
    let name : String
    let atoms : [Atom]
    let bonds : [Bond]
    var infos : Infos?
}

