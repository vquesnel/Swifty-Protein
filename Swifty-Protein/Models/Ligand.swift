//
//  Ligand.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 12/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit
import SceneKit

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
    var centroid: SCNVector3?
}


let atomName : [String : String] = [
    "B"  : "Boron",
    "BR" : "Bromine",
    "C"  : "Carbon",
    "CA" : "Calcium",
    "CL" : "Chlorine",
    "CO" : "Cobalt",
    "CR" : "Chromium",
    "F"  : "Fluorine",
    "FE" : "Iron",
    "H"  : "Hydrogen",
    "I"  : "Iodine",
    "MG" : "Magnesium",
    "MN" : "Manganese",
    "MO" : "Molybdenum",
    "N"  : "Nitrogen",
    "O"  : "Oxygen",
    "P"  : "Phosphorus",
    "PT" : "Platinium",
    "RH" : "Rhodium",
    "RU" : "Ruthenium",
    "S"  : "Sulfur",
    "SE" : "Selenium",
    "V"  : "Vanadium",
    "W"  : "Tungsten"
]


let atomValence : [String : String] = [
    "B"  : "3",
    "BR" : "1, 3, 5 or 7",
    "C"  : "4",
    "CA" : "2",
    "CL" : "1, 3, 5 or 7",
    "CO" : "3",
    "CR" : "3 or 6",
    "F"  : "1",
    "FE" : "3",
    "H"  : "1",
    "I"  : "1, 3, 5 or 7",
    "MG" : "2",
    "MN" : "3, 4, 6 or 7",
    "MO" : "1",
    "N"  : "3",
    "O"  : "2",
    "P"  : "3 or 5",
    "PT" : "2 or 4",
    "RH" : "---",
    "RU" : "---",
    "S"  : "4 or 6",
    "SE" : "2, 4 or 6",
    "V"  : "---",
    "W"  : "---"
]
