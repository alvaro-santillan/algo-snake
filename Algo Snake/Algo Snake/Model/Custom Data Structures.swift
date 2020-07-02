//
//  Custom Data Structures.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

struct Tuple: Hashable {
    var x: Int
    var y: Int
}

struct SkNodeAndLocation: Hashable {
    var square: SKShapeNode
    var location: Tuple
}
