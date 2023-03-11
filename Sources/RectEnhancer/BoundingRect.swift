//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import QuartzCore

public extension Array where Element == CGRect {
    
    func boundingRect() -> CGRect? {
          guard let firstRect = self.first else {
              return nil
          }
          var left = firstRect.origin.x
          var right = firstRect.origin.x + firstRect.width
          var top = firstRect.origin.y
          var bottom = firstRect.origin.y + firstRect.height
          
          for rect in self.dropFirst() {
              left = Swift.min(left, rect.origin.x)
              right = Swift.max(right, rect.origin.x + rect.width)
              top = Swift.min(top, rect.origin.y)
              bottom = Swift.max(bottom, rect.origin.y + rect.height)
          }
          
          let size = CGSize(width: right - left, height: bottom - top)
          let origin = CGPoint(x: left, y: top)
          
          return CGRect(origin: origin, size: size)
      }
    
}
