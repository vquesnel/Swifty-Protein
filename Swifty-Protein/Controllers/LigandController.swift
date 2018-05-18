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
        }
    }

    private var isAnimatated = false

    private let spin : CABasicAnimation = {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 1, y: 1, z: 1, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 1, y: 1, z: 1, w: Float.pi * 2))
        spin.duration = 5
        spin.repeatCount = .infinity
        return spin
    }()

    private let camera: SCNNode = {
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
        let control = UISegmentedControl(items: ["Sticks & balls", "Sticks"])
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(image: UIImage(named: "animation")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleAnimation))
        navigationItem.rightBarButtonItem = button
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

    private func generateModel(with atoms: [Atom], centroid: SCNVector3?) {
        guard let centroid = centroid else { return }
        atoms.forEach { atom in
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            let material = SCNMaterial()
            node.position = SCNVector3(atom.posX - Double(centroid.x), atom.posY - Double(centroid.y), atom.posZ - Double(centroid.z))
            material.diffuse.contents = UIColor.CPK[atom.type]
            sphere.materials = [material]
            ligandNode?.addChildNode(node)
        }
    }

    private func generateModel(with ligand: Ligand) {
        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()

        generateModel(with: ligand.atoms, centroid: ligand.centroid)
        ligandNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(ligandNode!)
    }

}
