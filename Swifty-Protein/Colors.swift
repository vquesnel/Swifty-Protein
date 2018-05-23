//
//  Colors.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 11/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit


let C_Background : UIColor = {
    return UIColor(red: 199/255, green: 109/255, blue: 38/255, alpha: 1)
}()

let C_Foreground : UIColor = {
    return UIColor(red: 249/255, green: 136/255, blue: 48/255, alpha: 1)
}()

let C_DarkBackground : UIColor = {
    return UIColor(white: 0.07, alpha: 1)
}()

let C_TextLight : UIColor = {
    return UIColor(white: 0.8, alpha: 1)
}()

let C_Blue : UIColor =  {
    return UIColor(red:0.36, green:0.71, blue:0.96, alpha:0.3)
}()

let C_Error : UIColor = {
    return UIColor(red:0.96, green:0.13, blue:0.08, alpha:0.3)
}()


func C_addBackground(image: String) -> UIImageView {
    let view = UIImageView(frame: UIScreen.main.bounds)
    view.image = UIImage(named: image)
    view.contentMode = UIViewContentMode.scaleAspectFill
    
    return view
}






extension UIColor {
    static let CPK: [String: UIColor] = [
        
        "B" : UIColor(red: 253/255, green: 189/255, blue: 184/255, alpha: 1),
        "BR" : UIColor(red: 166/255, green: 37/255, blue: 40/255, alpha: 1),
        "C" : UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1),
        "CA" : UIColor(red: 72/255, green: 253/255, blue: 47/255, alpha: 1),
        "CL" : UIColor(red: 47/255, green: 238/255, blue: 51/255, alpha: 1),
        "CO" : UIColor(red: 239/255, green: 145/255, blue: 163/255, alpha: 1),
        "CR" : UIColor(red: 140/255, green: 155/255, blue: 199/255, alpha: 1),
        "F" : UIColor(red: 131/255, green: 182/255, blue: 252/255, alpha: 1),
        "FE" : UIColor(red: 224/255, green: 102/255, blue: 56/255, alpha: 1),
        "H" : UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1),
        "I" : UIColor(red: 148/255, green: 19/255, blue: 147/255, alpha: 1),
        "MG" : UIColor(red: 143/255, green: 253/255, blue: 49/255, alpha: 1),
        "MN" : UIColor(red: 157/255, green: 125/255, blue: 198/255, alpha: 1),
        "MO" : UIColor(red: 88/255, green: 182/255, blue: 182/255, alpha: 1),
        "N" : UIColor(red: 14/255, green: 37/255, blue: 251/255, alpha: 1),
        "O" : UIColor(red: 252/255, green: 16/255, blue: 29/255, alpha: 1),
        "P" : UIColor(red: 253/255, green: 129/255, blue: 35/255, alpha: 1),
        "PT" : UIColor(red: 245/255,green: 238/255, blue: 211/255, alpha: 1),
        "RH" : UIColor(red: 19/255, green: 126/255, blue: 140/255, alpha: 1),
        "RU" : UIColor(red: 38/255, green: 144/255, blue: 144/255, alpha: 1),
        "S" : UIColor(red: 180/255, green: 179/255, blue: 36/255, alpha: 1),
        "SE" : UIColor(red: 253/255, green: 162/255, blue: 40/255, alpha: 1),
        "V" : UIColor(red: 168/255, green: 168/255, blue: 172/255, alpha: 1),
        "W" : UIColor(red: 39/255, green: 151/255, blue: 213/255, alpha: 1)
    ]
    
}
