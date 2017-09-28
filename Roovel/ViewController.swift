//
//  ViewController.swift
//  Roovel
//
//  Created by Lucy Tan on 9/27/17.
//  Copyright © 2017 Lucy Tan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var measureLabel: UILabel!
    
    
    let emptyVector = SCNVector3()
    var startPosition = SCNVector3()
    var endPosition = SCNVector3()
    var active = false

    func reset() {
        active = false
        startPosition = SCNVector3()
        endPosition = SCNVector3()
    }
    
    func calcDist(){
        if let currentPos = sceneView.vector(scrnPos: view.center) {
            if active {
                if startPosition == emptyVector {
                    startPosition = currentPos
                }
                endPosition = currentPos
                measureLabel.text = "\(startPosition.distance(from: endPosition) * 100 ) cm"
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.calcDist()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
        active = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        active = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
   
}
