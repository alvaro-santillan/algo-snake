struct MyPoint {
    var x: Int
    var y: Int
}

extension MyPoint: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

    public static func == (lhs: MyPoint, rhs: MyPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func matrixToDictionary(mazze: Array<Array<Int>>) -> Dictionary<MyPoint, Dictionary<MyPoint, Int>> {
    var mazeDistances = [MyPoint : [MyPoint : Int]]()
    var vaildValues = [MyPoint : Int]()

    for(y, innerArray) in maze.enumerated() {
        for(x, _) in innerArray.enumerated() {
            if ((mazze[y][x]) == 0) {
                // Up
                if ((mazze[y-1][x]) == 0) {
                    vaildValues[MyPoint(x: x, y: y-1)] = 1
                }
                // Right
                if (mazze[y][x+1] == 0) {
                    vaildValues[MyPoint(x: x+1, y: y)] = 1
                }
                // Left
                if (mazze[y][x-1] == 0) {
                    vaildValues[MyPoint(x: x-1, y: y)] = 1
                }
                // Down
                if (mazze[y+1][x] == 0) {
                    vaildValues[MyPoint(x: x, y: y+1)] = 1
                }
                mazeDistances[MyPoint(x: x, y: y)] = vaildValues
                vaildValues = [MyPoint : Int]()
            }
        }
    }
    return mazeDistances
}

var maze = ([[1, 1, 1, 1, 1, 1],
             [1, 0, 0, 0, 0, 1],
             [1, 0, 1, 0, 0, 1],
             [1, 0, 0, 0, 1, 1],
             [1, 0, 1, 0, 0, 1],
             [1, 1, 1, 1, 1, 1]])

var temp = matrixToDictionary(mazze: maze)

for(i, j) in temp[MyPoint(x: 1, y: 2)]! {
    print("i", i, "j", j)
}

// Breath first
var start = [MyPoint(x: 0, y: 0)]
var goal = [MyPoint(x: 10, y: 10)]

var currentNode = [MyPoint]()
var visitedNodes = [MyPoint]()
var fronterNodes = [MyPoint]()
var visitedNodeCount = 0
var nodeAndParentNode = [MyPoint : MyPoint]()

nodeAndParentNode = [start : MyPoint(x: 0, y: 0)]
visitedNodes = [start]
visitedNodeCount += 1
currentNode = start

while (currentNode != goal) {
    if (currentNode, not in visitedNodes) {
        visitedNodes.append(currentNode)
        visitedNodeCount += 1
    }
    for (newNode, in (state_graph[currentNode])) {
        if (newNode, not, in visitedNodes) {
            if (newNode, not, in fronterNodes) {
                fronterNodes.append(newNode)
                nodeAndParentNode.update({newNode:currentNode})
            }
        }
    }
    currentNode = fronterNodes[0]
    fronterNodes.pop(0)
}
