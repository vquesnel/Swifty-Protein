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
    let formula : String?
    let type : String?
    let name : String?
    let identifiers : String?
    let formulaWeight : Float?
    let atomCount : Int?
    let formalCharge : Int?
    let bondCount : Int?
    let aromaticBondCount : Int?
    let chiralAtomCount : Int?
    let chiralAtomsStr : String?
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

let resultsKeys : [String : String] = [
    "formula" : "Formula",
    "type" : "Type",
    "name" : "Name",
    "identifiers" : "Identifiers",
    "formulaWeight" : "Molecular Weight",
    "atomCount" : "Atom Count",
    "formalCharge" : "Formal Charge",
    "bondCount" : "Bond Count",
    "aromaticBondCount" : "Aromatic Bond Count",
    "chiralAtomCount" : "Chiral Atom Count",
    "chiralAtomsStr" : "Chiral Atoms"
]
