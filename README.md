RectEnhancer
============

RectEnhancer is a Swift package that provides a powerful set of tools to manipulate and enhance CGRect instances in your projects. With this package, you can easily perform operations such as resizing, snapping to magnetic lines, or maintaining aspect ratio when increasing the size of a CGRect.

Features
--------

*   Increase the size of CGRect with anchor points
*   Keep the aspect ratio while resizing
*   Snap to magnetic lines for precise adjustments
*   Easily find the nearest anchor point for a given CGPoint
*   Retrieve points or lines for CGRect instances
*   Customize behavior with RectIncreaseOptions

Installation
------------

You can install RectEnhancer using Swift Package Manager by adding the package to your dependencies in your `Package.swift` file:


```swift
dependencies: [
    .package(url: "https://github.com/Iliasnolsson/RectEnhancer", from: Version(1,0,0)..<Version(2,0,0))
]
```

Then, import RectEnhancer in the files where you want to use it:

```swift
import RectEnhancer
```

Usage
-----

### Basic CGRect manipulation

Increase the size of a CGRect by translation:


```swift
let rect = CGRect(x: 20, y: 20, width: 100, height: 100)
let translation = CGPoint(x: 10, y: 0)
let anchor = RectLocation.bottomRight
let newRect = rect.increase(byTranslation: translation, byDragging: anchor)
// Origin of (30, 20) and a size of (90, 100)
```

### Maintaining aspect ratio

Keep the aspect ratio while resizing a CGRect:


```swift
let rect = CGRect(x: 20, y: 20, width: 100, height: 100)
let translation = CGPoint(x: 10, y: 0)
let anchor = RectLocation.bottomRight
let options = RectIncreaseOptions.keepAspect
let newRect = rect.increase(byTranslation: translation, byDragging: anchor, options: options)
// Origin of (25, 25) and a size of (95, 95)
```

### Snapping to magnetic lines

Snap the CGRect to magnetic lines while resizing: (keep aspect and magnets can be combied)


```swift
let rect = CGRect(x: 20, y: 20, width: 100, height: 100)
let translation = CGPoint(x: 100, y: 0)
let anchor = RectLocation.topLeft
let magnets = RectMagnets(lines: [RectMagneticLine(offset: 210, axis: .horizontal)], snapOnDistance: 10)
let options = RectIncreaseOptions.snapTo(magnets)

let newRect = rect.increase(byTranslation: translation, byDragging: anchor, options: options)
// Origin of (20, 20) and a size of (190, 100).
```

### Finding the nearest anchor point

Get the nearest anchor point for a given CGPoint:

```swift
let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let point = CGPoint(x: 75, y: 75)
let nearestLocation = rect.nearestLocation
```

> you stopped writing at the title Finding the nearest anchor point. Could you please continue

for a given CGPoint:

```swift
let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let point = CGPoint(x: 75, y: 75)
let nearestLocation = rect.nearestLocation(forPoint: point)
// .bottomRight
```

This will return a tuple with the nearest anchor point and its distance to the given CGPoint.

### Retrieve points or lines for CGRect instances

Get points for a CGRect with a specified transform:

```swift
let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let transform = CGAffineTransform(rotationAngle: .pi / 4)
let points = rect.points(withTransform: transform)
// - topLeft: (-35.36, 35.36)
// - topRight: (35.36, 106.07)
// - bottomLeft: (-106.07, -35.36)
// - bottomRight: (0.0, 35.36)
// - middleTop: (-35.36, 70.71)
// - middleBottom: (-70.71, 0.0)
// - middleLeft: (-70.71, 35.36)
// - middleRight: (0.0, 70.71)
// - middle: (-35.36, 35.36)
```

The `points` dictionary will contain the transformed points for each anchor location. A transform does not need to be specified. The method also gives an optional parameter if you would want to exclude certian locations of the rectangle 

### Calculate bounds of multiple rects

Get the total bounding area around multiple CGRects:

```swift
let rect1 = CGRect(x: 10, y: 10, width: 50, height: 50)
let rect2 = CGRect(x: 40, y: 20, width: 70, height: 30)
let rect3 = CGRect(x: 90, y: 10, width: 20, height: 20)

let rects = [rect1, rect2, rect3]

if let boundingRect = rects.boundingRect() {
    print("Bounding rect: \(boundingRect)") 
    // Bounding rect: (10.0, 10.0, 100.0, 40.0)
} else {
    print("No rects in the array.")
}
```

Contributing
------------

We welcome contributions to RectEnhancer! If you'd like to contribute, please fork the repository, make your changes, and submit a pull request.

License
-------

RectEnhancer is available under the MIT license. See the LICENSE file for more information.
