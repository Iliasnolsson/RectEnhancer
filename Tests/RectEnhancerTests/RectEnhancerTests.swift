import XCTest
import FundamentalEnhancer

@testable import RectEnhancer

final class RectEnhancerTests: XCTestCase {
    
    func test() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let decimal = 1000
        func increase(_ rect: CGRect, by: CGPoint, from anchor: RectLocation, expects: CGRect, options: RectIncreaseOptions) {
            let modified = rect.increase(byTranslation: by, fromAnchor: anchor, options: options)
            print("Produced: ", modified.debugDescription)
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
}
