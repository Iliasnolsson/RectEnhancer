//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-05.
//

import QuartzCore
import MathEnhancer

public extension CGRect {
    
    func increase(byTranslation translation: CGPoint, fromAnchor anchor: RectLocation) -> CGRect {
        return internalIncrease(byTranslation: translation, fromAnchor: anchor, keepAspect: false, containWithinRect: nil, snapTo: nil)
    }
    
    func increase(byTranslation translation: CGPoint, fromAnchor anchor: RectLocation, options: RectIncreaseOptions) -> CGRect {
        return internalIncrease(byTranslation: translation, fromAnchor: anchor, keepAspect: options.keepAspectInternal, containWithinRect: options.containWithinRect, snapTo: options.snapToMagnets)
    }
    
    private func internalIncrease(byTranslation translation: CGPoint, fromAnchor anchor: RectLocation, keepAspect: Bool, containWithinRect parentRect: CGRect? = nil, snapTo magnets: RectMagnets? = nil) -> CGRect {
        let magnets = magnets ?? .init(lines: [], snapOnDistance: 0)
        var translation = translation
        let handle = point(forLocation: anchor.opposite)
        var handleTranslated = handle + translation
        if let parentRect = parentRect {
            if handleTranslated.x > parentRect.maxX {
                handleTranslated.x = parentRect.maxX
            } else if handleTranslated.x < parentRect.minX {
                handleTranslated.x = parentRect.minX
            }
            if handleTranslated.y < parentRect.minY {
                handleTranslated.y = parentRect.minY
            } else if handleTranslated.y > parentRect.maxY {
                handleTranslated.y = parentRect.maxY
            }
        }
        translation = handleTranslated - handle
        
        if anchor != .middle && !magnets.lines.isEmpty {
            var lines = magnets.lines
            switch anchor {
            case .middleTop, .middleBottom:
                lines = lines.filter {$0.axis == .vertical}
            case .middleLeft, .middleRight:
                lines = lines.filter {$0.axis == .horizontal}
            default:
                break
            }
            
            var linesUsed = [RectMagneticLine]()
            let magnetAndDistances: [(magnet: RectMagneticLine, distance: CGFloat)] = magnets.lines.map {($0, abs($0.offset - handleTranslated.float(onAxis: $0.axis)))}
            if let (nearestHorizontalMagnet, horizontalMagnetDistance) = magnetAndDistances.filter({$0.magnet.axis == .horizontal}).min(by: {a, b in a.distance < b.distance}) {
                if horizontalMagnetDistance <= magnets.snapOnDistance {
                    linesUsed.append(nearestHorizontalMagnet)
                    translation.x = nearestHorizontalMagnet.offset - handle.x
                }
            }
            if let (nearestVerticalMagnet, verticalMagnetDistance) = magnetAndDistances.filter({$0.magnet.axis == .vertical}).min(by: {a, b in a.distance < b.distance}) {
                if verticalMagnetDistance <= magnets.snapOnDistance {
                    linesUsed.append(nearestVerticalMagnet)
                    translation.y = nearestVerticalMagnet.offset - handle.y
                }
            }
            magnets.linesUsed?(linesUsed)
        } else {
            magnets.linesUsed?([])
        }
        
        let newFrame = {() -> CGRect in
            switch anchor {
            case .middle:
                return .init(center: center, size: .init(width: size.width + translation.x, height: size.height + translation.y))
            case .middleTop:
                if keepAspect {
                    let aspectToWidth = size.width / size.height
                    let newHeight = size.height + translation.y
                    return .init(x: origin.x, y: origin.y, width: newHeight * aspectToWidth, height: newHeight)
                }
                return .init(x: origin.x, y: origin.y, width: size.width, height: size.height + translation.y)
            case .middleBottom:
                if keepAspect {
                    let aspectToWidth = size.width / size.height
                    let newHeight = size.height - translation.y
                    return .init(x: origin.x, y: origin.y + translation.y, width: newHeight * aspectToWidth, height: newHeight)
                }
                return .init(x: origin.x, y: origin.y + translation.y, width: size.width, height: size.height - translation.y)
            case .middleLeft:
                if keepAspect {
                    let aspectToHeight = size.height / size.width
                    let newWidth = size.width + translation.x
                    return .init(x: origin.x, y: origin.y, width: newWidth, height: newWidth * aspectToHeight)
                }
                return .init(x: origin.x, y: origin.y, width: size.width + translation.x, height: size.height)
            case .middleRight:
                if keepAspect {
                    let aspectToHeight = size.height / size.width
                    let newWidth = size.width - translation.x
                    return .init(x: origin.x + translation.x, y: origin.y, width: newWidth, height: newWidth * aspectToHeight)
                }
                return .init(x: origin.x + translation.x, y: origin.y, width: size.width - translation.x, height: size.height)
            default:
                if keepAspect {
                    let scale = handle.scale(forReaching: handleTranslated, byScalingFrom: point(forLocation: anchor))
                    let linearScale = scale.x.interpolateTo(scale.y, amount: 0.5)
                    let newSize = CGSize(width: width * linearScale, height: height * linearScale)
                    translation = .init(x: newSize.width - size.width, y: newSize.height - size.height)
                }
                switch anchor {
                case .topLeft:
                    return .init(x: origin.x, y: origin.y, width: size.width + translation.x, height: size.height + translation.y)
                case .topRight:
                    if keepAspect {
                        let newWidth = size.width + translation.x
                        if newWidth < 0 {
                            return .init(x: origin.x + size.width, y: origin.y, width: abs(newWidth), height: size.height + translation.y)
                        }
                        return .init(x: origin.x + translation.x, y: origin.y, width: size.width + translation.x, height: size.height + translation.y)
                    }
                    return .init(x: origin.x + translation.x, y: origin.y, width: size.width - translation.x, height: size.height + translation.y)
                case .bottomLeft:
                    if keepAspect {
                        let newHeight = size.height + translation.y
                        if newHeight < 0 {
                            return .init(x: origin.x, y: origin.y + size.height, width: size.width + translation.x, height: abs(newHeight))
                        }
                        return .init(x: origin.x, y: origin.y + translation.y, width: size.width + translation.x, height: size.height + translation.y)
                    }
                    return .init(x: origin.x, y: origin.y + translation.y, width: size.width + translation.x, height: size.height - translation.y)
                case .bottomRight:
                    if keepAspect {
                        return .init(x: origin.x - translation.x, y: origin.y - translation.y, width: size.width + translation.x, height: size.height + translation.y)
                    }
                    return .init(x: origin.x + translation.x, y: origin.y + translation.y, width: size.width - translation.x, height: size.height - translation.y)
                default:
                    return self
                }
            }
        }()
        let minX = newFrame.minX
        let minY = newFrame.minY
        let maxX = newFrame.maxX
        let maxY = newFrame.maxY
        return .init(origin: .init(x: minX, y: minY), size: .init(width: maxX - minX, height: maxY - minY))
    }


    typealias LocationAndDistance = (anchor: RectLocation, distance: CGFloat)
    func nearestLocation(forPoint p: CGPoint, exclude: [RectLocation] = []) -> LocationAndDistance {
        typealias LocationAndPoint = (anchor: RectLocation, point: CGPoint)
        let anchorWithLocation: [LocationAndPoint] = RectLocation.allCases.filter({!exclude.contains($0)}).map {($0, point(forLocation: $0))}
        let anchorWithDistance: [LocationAndDistance] = anchorWithLocation.map {($0.anchor, $0.point.distanceTo(p))}
        return anchorWithDistance.min(by: {a, b in a.distance < b.distance})!
    }
    
    
    
    func point(forLocation anchor: RectLocation) -> CGPoint {
        switch anchor {
        case .middle:
            return self.center
        
        case .middleTop:
            return CGPoint(x: midX, y: minY)
        case .middleBottom:
            return CGPoint(x: midX, y: maxY)
        case .middleLeft:
            return CGPoint(x: minX, y: midY)
        case .middleRight:
            return CGPoint(x: maxX, y: midY)
            
        case .topLeft:
            return self.topLeft
        case .topRight:
            return self.topRight
        case .bottomLeft:
            return self.bottomLeft
        case .bottomRight:
            return self.bottomRight
        }
    }
    
    func points(withTransform transform: CGAffineTransform?) -> [RectLocation : CGPoint] {
        var rectPoints = [RectLocation : CGPoint]()
        rectPoints[.topLeft] = topLeft
        rectPoints[.topRight] = topRight
        rectPoints[.bottomLeft] = bottomLeft
        rectPoints[.bottomRight] = bottomRight
        
        rectPoints[.middleTop] = CGPoint(x: midX, y: origin.y)
        rectPoints[.middleBottom] = CGPoint(x: midX, y: origin.y + height)
        
        rectPoints[.middleLeft] = CGPoint(x: origin.x, y: midY)
        rectPoints[.middleRight] = CGPoint(x: origin.x + width, y: midY)
        
        rectPoints[.middle] = center
        
        if transform != nil {
            for index in rectPoints.indices {
                rectPoints[rectPoints[index].key] = rectPoints[index].value.applying(transform!)
            }
        }
        return rectPoints
    }

}
