//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-08.
//

import Foundation
import CoordinateEnums

public extension Side {
    
    var centerAnchor: RectLocation {
        switch self {
        case .top:
            return .middleTop
        case .bottom:
            return .middleBottom
        case .left:
            return .middleLeft
        case .right:
            return .middleRight
        }
    }
    
}

public extension CGRect {
    
    func side(forLocation point: CGPoint, excludeSides: [Side] = []) -> (Side, distance: CGFloat) {
        let sides = Side.allCases.filter {!excludeSides.contains($0)}
        var sidesAndDistance = [(side: Side, distance: CGFloat)]()
        for side in sides {
            var nearestFloatOnLine = point.float(onAxis: side.axisUsedForDrawing)
            let lineFloatRange = range(forSide: side)
            nearestFloatOnLine = nearestFloatOnLine.clamp(lineFloatRange.lowerBound, lineFloatRange.upperBound)
            
            var nearestPointOnLine = CGPoint()
            nearestPointOnLine.set(nearestFloatOnLine, onAxis: side.axisUsedForDrawing)
            nearestPointOnLine.set(float(forSide: side), onAxis: side.axisUsedForDrawing.opposite)

            sidesAndDistance.append((side, nearestPointOnLine.distanceTo(point)))
        }
        return sidesAndDistance.min(by: {a, b in a.distance < b.distance})!
    }
    
    
}

