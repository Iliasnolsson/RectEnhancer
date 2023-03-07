//
//  RectLocation.swift
//  old-version-of-secret-project
//
//  Created by Ilias Nikolaidis Olsson on 2021-12-30.
//

import QuartzCore

public enum RectLocation {
    case middle
    
    case middleTop
    case middleBottom
    case middleLeft
    case middleRight
    
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

public extension RectLocation {
    
    var opposite: RectLocation {
        switch self {
        case .middle:
            return .middle
        case .middleTop:
            return .middleBottom
        case .middleBottom:
            return .middleTop
        case .middleLeft:
            return .middleRight
        case .middleRight:
            return .middleLeft
        case .topLeft:
            return .bottomRight
        case .topRight:
            return .bottomLeft
        case .bottomLeft:
            return .topRight
        case .bottomRight:
            return .topLeft
        }
    }
    
    var isCorner: Bool {
        switch self {
        case .topLeft:
            return true
        case .topRight:
            return true
        case .bottomLeft:
            return true
        case .bottomRight:
            return true
        default:
            return false
        }
    }
    
    static var allCases: [RectLocation] {[.middle, .middleTop, .middleBottom, .middleLeft, .middleRight, .topLeft, .topRight, .bottomLeft, .bottomRight]}
    
}
