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


    lazy var atomLauncher : AtomLauncher = {
        let launcher = AtomLauncher()
        return launcher
    }()

    var ligand : Ligand? {
        willSet {
            modeButton.selectedSegmentIndex = 1
        }
        didSet {
            guard let ligand = self.ligand else { return }
            guard let infos = ligand.infos else { return }
            self.formula.text = infos.results.first?.formula
            self.generateModel(with: ligand, mode: modeButton.selectedSegmentIndex)
        }
    }

    private var isAnimatated = false

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

    private lazy var sceneView : SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAtomInfo)))
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

    let infoButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "infos")?.withRenderingMode(.alwaysTemplate)
        button.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(displayInfos), for: .touchUpInside)

        return button
    }()

    let formula : UITextField = {
        let field = UITextField()
        field.isEnabled = false
        field.isUserInteractionEnabled = false
        field.textColor = C_TextLight
        field.font = UIFont.systemFont(ofSize: 25)
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let spin : CABasicAnimation = {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float.pi * 2))
        spin.duration = 5
        spin.repeatCount = .infinity
        return spin
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

    @objc func handleShare(sender: UIButton) {
        guard let formula = ligand?.infos?.results.first?.formula else {
            let alert = UIAlertController(title: "Error", message: "No ligand to share", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try with an other one", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let objectsToShare = ["Formula : \(formula)", sceneView.snapshot()] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }

    @objc func handleDisplay() {
        guard let ligand = self.ligand else { return }
        generateModel(with: ligand, mode: modeButton.selectedSegmentIndex)
    }

    @objc func handleAtomInfo(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: sceneView)
            let targetPoint = sceneView.hitTest(location, options: nil)
            guard let targetNode = targetPoint.first?.node.position else { return }
            guard let centroid = ligand?.centroid else { return }
            guard let atom = ligand?.atoms.first(where: { SCNVector3($0.posX - Double(centroid.x), $0.posY - Double(centroid.y), $0.posZ - Double(centroid.z)) == targetNode }) else { return }
            atomLauncher.atom = atom
            atomLauncher.show()
        }
    }

    @objc func displayInfos() {
        let infosController = InfosController()
        guard let infos = ligand?.infos else { return }
        infosController.infos = infos
        infosController.title = "Informations"
        self.navigationController?.pushViewController(infosController, animated: true)
    }

    private func generateModel(with ligand: Ligand, mode: Int) {
        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()

        switch mode {
        case 0 :
            generateModel(with: ligand.bonds, atoms: ligand.atoms, centroid: ligand.centroid)
        case 2 :
            generateModel(with: ligand.atoms, centroid: ligand.centroid)
        default:
            generateModel(with: ligand.atoms, centroid: ligand.centroid)
            generateModel(with: ligand.bonds, atoms: ligand.atoms, centroid: ligand.centroid)
        }
        ligandNode?.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(ligandNode!)
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

    private func generateModel(with bonds: [Bond], atoms: [Atom], centroid: SCNVector3?) {
        guard let centroid = centroid else { return }
        bonds.forEach { bond in
            let v1 = SCNVector3(atoms[bond.left - 1].posX - Double(centroid.x), atoms[bond.left - 1].posY - Double(centroid.y), atoms[bond.left - 1].posZ - Double(centroid.z))
            let v2 = SCNVector3(atoms[bond.right - 1].posX - Double(centroid.x), atoms[bond.right - 1].posY - Double(centroid.y), atoms[bond.right - 1].posZ - Double(centroid.z))
            if bond.link == 2 {
                generateCylinders(value: -0.1, vectors: [v1,v2], atoms: atoms, bond: bond)
                generateCylinders(value: 0.1, vectors: [v1,v2], atoms: atoms, bond: bond)
            }
            else {
                generateCylinders(value: 0, vectors: [v1, v2], atoms: atoms, bond: bond, radius: 0.1)
            }
        }
    }

    private func generateCylinders(value: Float, vectors: [SCNVector3], atoms: [Atom], bond: Bond, radius: CGFloat = 0.05) {
        guard let ligandNode = ligandNode else { return }
        let newV1 = vectors[0].updateValue(value: value)
        let newV2 = vectors[1].updateValue(value: value)
        let centroid = [newV1, newV2].centroid()
        [[newV1, atoms[bond.left - 1].type], [newV2, atoms[bond.right - 1].type]].forEach { vector in
            let sphere = SCNSphere(radius: radius)
            let node = SCNNode(geometry: sphere)
            let material = SCNMaterial()
            node.position = vector[0] as! SCNVector3
            material.diffuse.contents = UIColor.CPK[vector[1] as! String]
            sphere.materials = [material]
            ligandNode.addChildNode(node)
        }
        ligandNode.addChildNode(CylinderLine(parent: ligandNode, v1: newV1, v2: centroid, radius: radius, radSegmentCount: 25, color: UIColor.CPK[atoms[bond.left - 1].type]))
        ligandNode.addChildNode(CylinderLine(parent: ligandNode, v1: centroid, v2: newV2, radius: radius, radSegmentCount: 25, color: UIColor.CPK[atoms[bond.right - 1].type]))
    }

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

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.atomLauncher.updateSettings()
        }, completion: { _ in })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let animationButton = UIBarButtonItem(image: UIImage(named: "animation")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleAnimation))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleShare))
        navigationItem.rightBarButtonItems = [shareButton, animationButton]
        view.backgroundColor = C_DarkBackground

        view.addSubview(sceneView)
        view.addSubview(modeButton)
        view.addSubview(formula)
        view.addSubview(infoButton)

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

        infoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

}

extension Array where Element == SCNVector3 {
    func centroid() -> SCNVector3 {
        var totalX = Float(0)
        var totalY = Float(0)
        var totalZ = Float(0)
        self.forEach { vector in
            totalX += vector.x
            totalY += vector.y
            totalZ += vector.z
        }
        return SCNVector3(totalX / Float(self.count), totalY / Float(self.count), totalZ / Float(self.count))
    }
}

extension SCNVector3 {
    static func ==(rhs : SCNVector3, lhs : SCNVector3) -> Bool {
        return rhs.x == lhs.x && rhs.y == lhs.y && rhs.z == lhs.z
    }

    func updateValue(value: Float) -> SCNVector3 {
        var vec = self
        vec.x = self.x + value
        vec.y = self.y
        vec.z = self.z
        return vec
    }

    func distance(receiver: SCNVector3) -> Float {
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))

        if (distance < 0) {
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
