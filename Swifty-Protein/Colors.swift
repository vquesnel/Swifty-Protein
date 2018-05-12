//
//  Colors.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 11/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit


let C_Background : UIColor = {
    return UIColor(red: 240/255, green: 25/255, blue: 1/255, alpha: 1)
}()


let C_Foreground : UIColor = {
    return UIColor(red: 249/255, green: 136/255, blue: 48/255, alpha: 1)
}()


let C_DarkBackground : UIColor = {
    return UIColor(white: 0.1, alpha: 1)
}()

let C_TextLight : UIColor = {
    return UIColor(white: 0.8, alpha: 1)
}()


func C_addBackground(image: String) -> UIImageView {
    let view = UIImageView(frame: UIScreen.main.bounds)
    view.image = UIImage(named: image)
    view.contentMode = UIViewContentMode.scaleAspectFill
    
    return view
}
