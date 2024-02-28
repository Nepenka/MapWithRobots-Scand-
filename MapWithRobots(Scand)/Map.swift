//
//  Map.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 25.02.24.
//

import Foundation
import UIKit


struct Coordinate: Equatable {
    var x: Int
    var y: Int
}

struct Map {
    var dimensions: Coordinate
    var entrance: Coordinate
    var exit: Coordinate
    var obstacles: [Coordinate]
    var partitions: [Coordinate]
    var boxes: [Boxing]

    init(warehouse: Warehouse) {
        dimensions = Coordinate(x: warehouse.dimensions.width, y: warehouse.dimensions.height)
        entrance = Coordinate(x: warehouse.entrance.x, y: warehouse.entrance.y)
        exit = Coordinate(x: warehouse.exit.x, y: warehouse.exit.y)
        
        obstacles = warehouse.obstacles.map { Coordinate(x: $0.x, y: $0.y) }
        partitions = warehouse.partitions.map { Coordinate(x: $0.x, y: $0.y) }
        
        boxes = warehouse.boxes.map { Boxing(id: $0.id, coordinate: Coordinate(x: $0.position.x, y: $0.position.y)) }
    }
}


struct Boxing {
    var id: Int
    var coordinate: Coordinate
}

struct RobotMessage {
    let senderID: Int
    let position: Coordinate
    let action: Command
    let intention: String
}

enum Direction {
    case up
    case down
    case left
    case right
    case none
    
    
    var dx: Int {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        case .up, .down, .none:
            return 0
        }
    }
    
    var dy: Int {
        switch self {
        case .up:
            return -1
        case .down:
            return 1
        case .left, .right, .none:
            return 0
        }
    }
}

enum Command {
    case moveForward
    case turnLeft
    case turnRight
}

