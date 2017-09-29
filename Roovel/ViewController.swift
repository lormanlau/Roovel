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
import CoreMotion

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var motion = CMMotionManager()
    
    let emptyVector = SCNVector3()
    var startPosition = SCNVector3()
    var endPosition = SCNVector3()
    var active = false
    
    var rotAngle: Double!

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
                measureLabel.text = String(format: "%.2f", (startPosition.distance(from: endPosition) * 100)) + " cm/" + String(format: "%.2f", (startPosition.distance(from: endPosition) * 39.3701)) + " in"
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
    
    func processAccData(acceleration: CMAcceleration){
        
        let x = acceleration.x
        let y = acceleration.y
        let z = acceleration.z
        
        //from arctan angle to 360 degree format
        let XYAngle = atan2(x, y)
        let XZAngle = atan2(x, y)
        let YZAngle = atan2(x, y)
        let xyDegree: Int = Int(round(XYAngle * 180 / .pi))
        let xzDegree: Int = Int(round(XZAngle * 180 / .pi))
        let yzDegree: Int = Int(round(YZAngle * 180 / .pi))
        
        let chosenDegree: Int = chooseDegree(x: x, y: y, z: z, xyDegree: xyDegree, xzDegree: xzDegree, yzDegree: yzDegree)

        levelLabel.text = "\(chosenDegree)"
        
    }
    
    func chooseDegree(x: Double, y: Double, z: Double, xyDegree: Int, xzDegree: Int, yzDegree: Int)-> Int{
        var chosenDegree: Int = 0
        
        
        let xz = xzToScale(xzDegree: xzDegree)
        let xy = xyToScale(xyDegree: xyDegree)
        let yz = yzToScale(yzDegree: yzDegree)
        
        if z != 0 && x/z < 1 && x/z > -1 && y/z > -1 && y/z < 1  {
            if abs(yz) > abs(xz) {
                chosenDegree = yz - 1
            }else {
                chosenDegree = xz - 1
            }
        }else {
            chosenDegree = xy
        }

        return chosenDegree
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        motion.accelerometerUpdateInterval = 1/24
        motion.startAccelerometerUpdates(to: OperationQueue.current!) {
            data, error in
            self.processAccData(acceleration: data!.acceleration)
        }
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
