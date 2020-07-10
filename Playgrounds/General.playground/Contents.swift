
import SpriteKit
var a = SKShapeNode()

struct Tuple: Hashable {
    var x: Int
    var y: Int
}

struct SkNodeAndLocation: Hashable {
    var square: SKShapeNode
    var location: Tuple
}

func huristic(prospectSquare: Tuple, foodLocations: [SkNodeAndLocation]) -> Int {
    var foodDistances = [Int]()
    for foodSquare in foodLocations {
        let tempX = abs(prospectSquare.x - foodSquare.location.x)
        let tempY = abs(prospectSquare.y - foodSquare.location.y)
        foodDistances.append(tempX + tempY)
    }
    return foodDistances.min() ?? 0
}

var foodLocations = [SkNodeAndLocation(square: a, location: Tuple(x: 0, y: 0)),SkNodeAndLocation(square: a, location: Tuple(x: 4, y: 0))]
print(huristic(prospectSquare: Tuple(x: 1, y: 4), foodLocations: foodLocations))
