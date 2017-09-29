//
//  calculateXYZ.swift
//  Roovel
//
//  Created by Lorman Lau on 9/28/17.
//  Copyright © 2017 Lucy Tan. All rights reserved.
//

import Foundation
import CoreMotion

extension ViewController {
    //the follow three functions scale -180~180 to -90~90
    public func xyToScale(xyDegree: Int)-> Int{
        var scaledDegree: Int = 0;
        
        if xyDegree <= -135 {
            scaledDegree = -xyDegree - 180
        } else if xyDegree <= -45 {
            scaledDegree = xyDegree + 90
        } else if xyDegree <= 45 {
            scaledDegree = -xyDegree
        } else if xyDegree <= 135 {
            scaledDegree = xyDegree - 90 + 1
        } else {
            scaledDegree = -xyDegree + 180 - 1
        }
        
        return scaledDegree
    }
    
    public func xzToScale(xzDegree: Int)-> Int{
        var scaledDegree: Int = 0
        
        if xzDegree > -45 && xzDegree < 0{
            scaledDegree = xzDegree
        } else if xzDegree < 45 && xzDegree > 0{
            scaledDegree = -xzDegree
        } else if xzDegree > 135 {
            scaledDegree = 180 - xzDegree
        } else if xzDegree < -135 {
            scaledDegree = xzDegree + 180
        }
        
        return scaledDegree
    }
    
    public func yzToScale(yzDegree: Int)-> Int{
        var scaledDegree: Int = 0
        
        if yzDegree > -45 && yzDegree < 0 {
            scaledDegree = yzDegree
        } else if yzDegree < 45 && yzDegree > 0 {
            scaledDegree = -yzDegree
        } else if yzDegree > 135 {
            scaledDegree = 180 - yzDegree
        } else if yzDegree < -135 {
            scaledDegree = yzDegree + 180
        }
        
        return scaledDegree
    }
    
    
}
