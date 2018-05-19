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
        willSet {
            modeButton.selectedSegmentIndex = 1
        }
        didSet {
            guard let ligand = self.ligand else { return }
            guard let infos = ligand.infos else { return }
            self.formula.text = infos.results[0].formula
            self.generateModel(with: ligand, mode: modeButton.selectedSegmentIndex)
        }
    }

    private var isAnimatated = false

    private let spin : CABasicAnimation = {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float.pi * 2))
        spin.duration = 5
        spin.repeatCount = .infinity
        return spin
    }()

    private lazy var camera: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.automaticallyAdjustsZRange = true
        node.position = SCNVector3(0, 0, 50)
        return node
    }()

    private lazy var scene: SCNScene = {
        let scene = SCNScene()

        let fullLightColor = UIColor(white: 0.8, alpha: 1)
        let shadowLightColor = UIColor(white: 0.4, alpha: 1)

        let backLight = self.createLight(type: .omni, color: fullLightColor, position: SCNVector3(0, 50, -50))
        let fillLight = self.createLight(type: .omni, color: fullLightColor, position: SCNVector3(-50, -50, 50))
        let keyLight = self.createLight(type: .omni, color: shadowLightColor, position: SCNVector3(80, 0, 0))
        let ambientLight = self.createLight(type: .ambient, color: shadowLightColor, position: nil)

        scene.rootNode.addChildNode(backLight)
        scene.rootNode.addChildNode(fillLight)
        scene.rootNode.addChildNode(keyLight)
        scene.rootNode.addChildNode(ambientLight)
        scene.rootNode.addChildNode(camera)

        return scene
    }()

    private func createLight(type: SCNLight.LightType, color: UIColor, position: SCNVector3?) -> SCNNode {
        let node = SCNNode()
        let light = SCNLight()
        light.type = type
        light.color = color
        node.light = light
        guard let position = position else { return node }
        node.position = position
        return node
    }

    private lazy var sceneView : SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = C_DarkBackground
        return view
    }()

    let modeButton : UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sticks", "Sticks & balls", "Balls"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .none
        control.tintColor = UIColor(red:0.23, green:0.67, blue:0.93, alpha:1.0)
        control.layer.cornerRadius = 5
        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(handleDisplay), for: .valueChanged)
        return control
    }()

    let formula : UITextField = {
        let field = UITextField()
        field.textColor = C_TextLight
        field.font = UIFont.systemFont(ofSize: 25)
        field.textAlignment = .center
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    @objc func handleAnimation() {
        let animation = ligandNode?.animationPlayer(forKey: "spin around")
        if !isAnimatated {
            if (animation == nil) {
                ligandNode?.addAnimation(spin, forKey: "spin around")
            }
            else {
                animation?.paused = false
            }
        }
        else {
            animation?.paused = true
        }
        isAnimatated = !isAnimatated
    }
    
    @objc func handleDisplay() {
        guard let ligand = self.ligand else { return }
        generateModel(with: ligand, mode: modeButton.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(image: UIImage(named: "animation")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleAnimation))
        navigationItem.rightBarButtonItem = button
        view.backgroundColor = C_DarkBackground

        view.addSubview(sceneView)
        view.addSubview(modeButton)
        view.addSubview(formula)

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

    private func generateModel(with atoms: [Atom], centroid: SCNVector3?) {
        guard let centroid = centroid else { return }
        guard let ligandNode = ligandNode else { return }
        atoms.forEach { atom in
            let sphere = SCNSphere(radius: 0.4)
            let node = SCNNode(geometry: sphere)
            let material = SCNMaterial()
            node.position = SCNVector3(atom.posX - Double(centroid.x), atom.posY - Double(centroid.y), atom.posZ - Double(centroid.z))
            material.diffuse.contents = UIColor.CPK[atom.type]
            sphere.materials = [material]
            ligandNode.addChildNode(node)
        }
    }
    
    private func generateModel(with bonds: [Bond], atoms: [Atom], centroid: SCNVector3?, color: UIColor) {
        guard let centroid = centroid else { return }
        guard let ligandNode = ligandNode else { return }
        bonds.forEach { bond in
            let v1 = SCNVector3(atoms[bond.left - 1].posX - Double(centroid.x), atoms[bond.left - 1].posY - Double(centroid.y), atoms[bond.left - 1].posZ - Double(centroid.z))
            let v2 = SCNVector3(atoms[bond.right - 1].posX - Double(centroid.x), atoms[bond.right - 1].posY - Double(centroid.y), atoms[bond.right - 1].posZ - Double(centroid.z))
            if bond.link == 2 {
                ligandNode.addChildNode(CylinderLine(parent: ligandNode, v1: updateVector(value: -0.1, vector: v1), v2: updateVector(value: -0.1, vector: v2), radius: 0.05, radSegmentCount: 25, color: color))
                ligandNode.addChildNode(CylinderLine(parent: ligandNode, v1: updateVector(value: 0.1, vector: v1), v2: updateVector(value: 0.1, vector: v2), radius: 0.05, radSegmentCount: 25, color: color))
            }
            else {
                ligandNode.addChildNode(CylinderLine(parent: ligandNode, v1: v1, v2: v2, radius: 0.05, radSegmentCount: 25, color: color))
            }
        }
    }

    private func generateModel(with ligand: Ligand, mode: Int) {
        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()
        
        switch mode {
            case 0 :
                generateModel(with: ligand.bonds, atoms: ligand.atoms, centroid: ligand.centroid, color : .gray)
            case 2 :
                generateModel(with: ligand.atoms, centroid: ligand.centroid)
            default:
                generateModel(with: ligand.atoms, centroid: ligand.centroid)
                generateModel(with: ligand.bonds, atoms: ligand.atoms, centroid: ligand.centroid, color : .gray)
        }
        ligandNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(ligandNode!)
    }
    
    private func updateVector(value: Float, vector: SCNVector3) -> SCNVector3 {
        var vec = SCNVector3()
        vec.x = vector.x + value
        vec.y = vector.y + value
        vec.z = vector.z + value
        return vec
    }

}
