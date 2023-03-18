import XCTest

@testable import RectEnhancer

final class RectEnhancerTests: XCTestCase {
    
    
    func testNearestLocation() {
        // Set up the test data
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let point = CGPoint(x: 90, y: 90)
        
        // Call the nearestLocation(forPoint:) function
        let nearestLocation = rect.nearestLocation(forPoint: point)
        
        // Verify the result
        XCTAssertEqual(nearestLocation.anchor, RectLocation.bottomRight, "Expected nearest location to be .bottomRight")
    }
    
    
    func test() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let decimal = 3
        func increase(_ rect: CGRect, by: CGPoint, from anchor: RectLocation, expects: CGRect, options: RectIncreaseOptions) {
            let modified = rect.increase(byTranslation: by, byDragging: anchor.opposite, options: options)
            if modified.origin.rounded(decimal: decimal) == expects.origin.rounded(decimal: decimal) {
                if modified.size.rounded(decimal: decimal) == expects.size.rounded(decimal: decimal) {
                    return;
                }
                XCTFail("Size does not equal")
            }
            XCTFail("Origin does not equal")
        }
        
        increase(.init(x: 20, y: 20, width: 100, height: 100),
                 by: .init(x: 10, y: 0),
                 from: .bottomRight,
                 expects: .init(x: 30, y: 20, width: 90, height: 100),
                 options: .none)
        
        
        increase(.init(x: 20, y: 20, width: 100, height: 100),
                 by: .init(x: 10, y: 0),
                 from: .bottomRight,
                 expects: .init(x: 25, y: 25, width: 95, height: 95),
                 options: .keepAspect)
        
        increase(.init(x: 20, y: 20, width: 100, height: 100),
                 by: .init(x: -10, y: 25),
                 from: .topLeft,
                 expects: .init(x: 20, y: 20, width: 107.5, height: 107.5),
                 options: .keepAspect)
        
        increase(.init(x: 20, y: 20, width: 100, height: 100),
                 by: .init(x: 100, y: 0),
                 from: .topLeft,
                 expects: .init(x: 20, y: 20, width: 190, height: 100),
                 options: .snapTo(.init(lines: [.init(offset: 210, axis: .horizontal)],
                                        snapOnDistance: 10)))
        
    }
    
    
    func testBoundingRect() {
        let rect1 = CGRect(x: 10, y: 20, width: 30, height: 40)
        let rect2 = CGRect(x: 100, y: 200, width: 50, height: 60)
        let rect3 = CGRect(x: 70, y: 80, width: 90, height: 100)
        let rectArray = [rect1, rect2, rect3]
        
        // Test that the bounding rect is calculated correctly
        if let boundingRect = rectArray.boundingRect() {
            XCTAssertEqual(boundingRect.origin.x, 10, accuracy: 0.001)
            XCTAssertEqual(boundingRect.origin.y, 20, accuracy: 0.001)
            XCTAssertEqual(boundingRect.size.width, 150, accuracy: 0.001)
            XCTAssertEqual(boundingRect.size.height, 240, accuracy: 0.001)
        } else {
            XCTFail("Bounding Rect should not be nil")
        }
        
        // Test that an empty array returns nil
        let emptyRectArray = [CGRect]()
        XCTAssertNil(emptyRectArray.boundingRect())
        
        // Test that an array with only one rectangle returns that rectangle as the bounding rect
        let singleRectArray = [rect1]
        if let singleRectBoundingRect = singleRectArray.boundingRect() {
            XCTAssertEqual(singleRectBoundingRect.origin.x, 10, accuracy: 0.001)
            XCTAssertEqual(singleRectBoundingRect.origin.y, 20, accuracy: 0.001)
            XCTAssertEqual(singleRectBoundingRect.size.width, 30, accuracy: 0.001)
            XCTAssertEqual(singleRectBoundingRect.size.height, 40, accuracy: 0.001)
        } else {
            XCTFail("Bounding Rect should not be nil")
        }
    }
    
}
