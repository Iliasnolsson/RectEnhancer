//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-08.
//

import Foundation
import CoordinateEnums

public struct RectMagneticLine {
    
    let offset: CGFloat
    let axis: Axis
    
    init(offset: CGFloat, axis: Axis) {
        self.offset = offset
        self.axis = axis
    }
    
}

public extension CGRect {
    
    func lines() -> [RectMagneticLine] {
        return lines(onAxis: .horizontal) + lines(onAxis: .vertical)
    }
    
    func lines(onAxis axis: Axis) -> [RectMagneticLine] {
        if axis == .horizontal {
            return [.init(offset: minY, axis: .vertical), .init(offset: midY, axis: .vertical), .init(offset: maxY, axis: .vertical)]
        } else {
            return [.init(offset: minX, axis: .horizontal), .init(offset: midX, axis: .horizontal), .init(offset: maxX, axis: .horizontal)]
        }
    }
    
}
