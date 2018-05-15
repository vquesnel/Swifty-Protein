//
//  LigandController.swift
//  Swifty-Protein
//
//  Created by Kiefer Wiessler on 13/05/2018.
//  Copyright © 2018 Kiefer Wiessler. All rights reserved.
//

import UIKit
import SceneKit

class LigandController: UIViewController {
    
    private var ligandNode: SCNNode?
    
    
    
    var ligand : Ligand? {
        didSet {
            guard let ligand = self.ligand else { return }
            guard let infos = ligand.infos else { return }
            self.loadingWheel.stopAnimating()
            self.formula.text = infos.results[0].formula
            self.generateModel(with: ligand)
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(0, 0, 0)
            sphere.color = .blue
            ligandNode?.addChildNode(node)
            
            
            let light = SCNLight()
            light.type = .directional
            light.spotInnerAngle = -45
            light.spotOuterAngle = -45
            light.color = UIColor(white: 1, alpha: 0.2)
            
            let light2 = SCNLight()
            light2.type = .directional
            light2.spotInnerAngle = 45
            light2.spotOuterAngle = 45
            light2.color = UIColor(white: 1, alpha: 0.2)
            let first = ligandNode?.childNodes.first
            let focus = first
            focus?.position = SCNVector3(x: (first?.position.x)!, y: (first?.position.y)!, z: (first?.position.z)! + 10)
            sceneView.pointOfView = focus
            
            ligandNode?.addChildNode(light)
        }
    }
    
    private let camera: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.automaticallyAdjustsZRange = true
        node.position = SCNVector3(0, 0, 20)
        return node
    }()
    

    
    private lazy var scene: SCNScene = {
        let scene = SCNScene()
        scene.rootNode.addChildNode(camera)
//        scene.background =
        return scene
    }()
    
    private lazy var sceneView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
//        view.autoenablesDefaultLighting = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = C_DarkBackground
        return view
    }()
    
    let modeButton : UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sticks & balls", "Sticks", "Balls"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .none
        control.tintColor = UIColor(red:0.23, green:0.67, blue:0.93, alpha:1.0)
        control.layer.cornerRadius = 5
        control.selectedSegmentIndex = 1
        return control
    }()
    
    let loadingWheel : UIActivityIndicatorView = {
        let wheel = UIActivityIndicatorView()
        wheel.startAnimating()
        wheel.translatesAutoresizingMaskIntoConstraints = false
        return wheel
    }()
    
    let formula : UITextField = {
        let field = UITextField()
        field.textColor = C_TextLight
        field.font = UIFont.systemFont(ofSize: 25)
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = C_DarkBackground
        
        view.addSubview(sceneView)
        view.addSubview(loadingWheel)
        view.addSubview(modeButton)
        view.addSubview(formula)
  
        loadingWheel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        loadingWheel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true


        modeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        modeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        modeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        formula.heightAnchor.constraint(equalToConstant: 30).isActive = true
        formula.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        formula.topAnchor.constraint(equalTo: modeButton.bottomAnchor, constant: 30).isActive = true
        
       
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    private func generateModel(with atoms: [Atom]) {
        atoms.forEach { atom in
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            let material = SCNMaterial()
   
            node.position = SCNVector3(atom.posX, atom.posY, atom.posZ)
            material.diffuse.contents = UIColor.CPK[atom.type]
            sphere.materials = [material]
            ligandNode?.addChildNode(node)
        }
    }
    
    private func generateModel(with ligand: Ligand) {

        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()

        generateModel(with: ligand.atoms)
        ligandNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(ligandNode!)
    }
    
}
extension SCNGeometry {
    var color: UIColor? {
        set { firstMaterial?.diffuse.contents = newValue }
        get { return firstMaterial?.diffuse.contents as? UIColor }
    }
}




