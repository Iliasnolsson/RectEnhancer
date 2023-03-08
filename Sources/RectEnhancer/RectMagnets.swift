//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-08.
//

import Foundation
import FundamentalEnhancer

public struct RectMagnets {
    
    var lines: [RectMagneticLine]
    var snapOnDistance: CGFloat
    
    /// Called to indicate which lines was snapped to within the rect operation
    let linesUsed: (([RectMagneticLine]) -> ())?
    
    public init(lines: [RectMagneticLine], snapOnDistance: CGFloat, linesUsed: (([RectMagneticLine]) -> ())? = nil) {
        self.lines = lines
        self.snapOnDistance = snapOnDistance
        self.linesUsed = linesUsed
    }
    
}
