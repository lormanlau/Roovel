//
//  vectorEx.swift
//  Roovel
//
//  Created by Lucy Tan on 9/27/17.
//  Copyright © 2017 Lucy Tan. All rights reserved.
//

import Foundation
import ARKit

extension SCNVector3: Equatable {
    static func getPosition(_ position: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(position.columns.3.x, position.columns.3.y, position.columns.3.z)
    }
    
    func distance(from vector: SCNVector3) -> Float {
        let disX = self.x - vector.x
        let disY = self.y - vector.y
        let disZ = self.z - vector.z
        let distanceMeasurements = (pow(disX, 2) + pow(disY, 2) + pow(disZ, 2))
        return sqrtf(distanceMeasurements)
    }
    
    public static func ==(start: SCNVector3, end: SCNVector3) -> Bool {
        return (start.x == end.x) && (start.y == end.y) && (start.z == end.z)
    }
}

extension ARSCNView {
    func vector(scrnPos: CGPoint) -> SCNVector3? {
        let results = self.hitTest(scrnPos, types: [.featurePoint])
        if let result = results.first {
            return SCNVector3.getPosition(result.worldTransform)
        }
        return nil
    }
}
