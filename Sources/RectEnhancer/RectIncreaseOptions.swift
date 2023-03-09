//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-08.
//

import Foundation

public struct RectIncreaseOptions {
    
    var keepAspectInternal: Bool
    
    var snapToMagnets: RectMagnets?
    
    var containWithinRect: CGRect?
    
    public init(keepAspect: Bool, snapTo snapToMagnets: RectMagnets?, andContainWithin containWithinRect: CGRect? = nil) {
        self.keepAspectInternal = keepAspect
        self.snapToMagnets = snapToMagnets
        self.containWithinRect = containWithinRect
    }

}

public extension RectIncreaseOptions {
    
    static func snapTo(_ magnets: RectMagnets) -> RectIncreaseOptions {
        return .init(keepAspect: false, snapTo: magnets, andContainWithin: nil)
    }
    
    static func containWithin(_ rect: CGRect) -> RectIncreaseOptions {
        return .init(keepAspect: false, snapTo: nil, andContainWithin: rect)
    }
    
    static var keepAspect: RectIncreaseOptions = .init(keepAspect: true, snapTo: nil, andContainWithin: nil)
    
    static var none: RectIncreaseOptions = .init(keepAspect: false, snapTo: nil)
    
    func setKeepAspect(to value: Bool) -> RectIncreaseOptions {
        return .init(keepAspect: value, snapTo: snapToMagnets, andContainWithin: containWithinRect)
    }
    
    func containWithin(_ rect: CGRect) -> RectIncreaseOptions {
        return .init(keepAspect: keepAspectInternal, snapTo: snapToMagnets, andContainWithin: rect)
    }
    
    func snap(to magnets: RectMagnets) -> RectIncreaseOptions {
        return .init(keepAspect: keepAspectInternal, snapTo: magnets, andContainWithin: containWithinRect)
    }
    
}

