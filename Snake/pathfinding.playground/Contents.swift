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
    var mazeDistances = [MyPoint : [MyPoint : Int]] ()
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

var maze = ([[11, 12, 13, 14, 15, 16],
            [22, 22, 0, 22, 22, 22],
            [33, 33, 99, 654, 33, 33],
            [44, 44, 0, 44, 44, 44],
            [55, 55, 55, 55, 55, 55]])

var temp = matrixToDictionary(mazze: maze)

for(i, j) in temp[MyPoint(x: 2, y: 2)]! {
    print("i", i, "j", j)
}
