//
//  Parser.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 23.02.24.
//



struct Partition: Decodable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

struct Warehouse: Decodable {
    let dimensions: (width: Int, height: Int)
    let entrance: (x: Int, y: Int)
    let exit: (x: Int, y: Int)
    let obstacles: [Partition]
    let partitions: [Partition]
    var boxes: [Box]
   // var robot: Robot
    
    init(dimensions: (width: Int, height: Int), entrance: (x: Int, y: Int), exit: (x: Int, y: Int), obstacles: [Partition], partitions: [Partition], boxes: [Box]) {
        self.dimensions = dimensions
        self.entrance = entrance
        self.exit = exit
        self.obstacles = obstacles
        self.partitions = partitions
        self.boxes = boxes
        //self.robot = robot
    }
}

struct Box: Decodable {
    var id: Int
    var position: Position
    
    struct Position: Decodable {
        var x: Int
        var y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
}

struct RobotMessage {
    let senderID: Int
    let partition: Partition
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



import Foundation
import UIKit



func parser(from jsonString: String) -> Warehouse?  {
    
    guard let jsonData = jsonString.data(using: .utf8) else {
        print("Ошибка преобразования строки в данные JSON")
        return nil
    }
    
    do{
        let warehouseData = try JSONDecoder().decode([String: Warehouse].self, from: jsonData)
        return warehouseData["warehouse"]
    }catch{
        print("Ошибка декодирования JSON", error)
        return nil
        
    }
}


extension Warehouse {
    private enum CodingKeys: String, CodingKey {
            case dimensions, entrance, exit, obstacles, partitions, boxes
        }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let dimensionsArray = try container.decode([Int].self, forKey: .dimensions)
            dimensions = (dimensionsArray[0], dimensionsArray[1])
            let entranceArray = try container.decode([Int].self, forKey: .entrance)
            entrance = (entranceArray[0], entranceArray[1])
            let exitArray = try container.decode([Int].self, forKey: .exit)
            exit = (exitArray[0], exitArray[1])
            obstacles = try container.decode([Partition].self, forKey: .obstacles)
            partitions = try container.decode([Partition].self, forKey: .partitions)
            boxes = try container.decode([Box].self, forKey: .boxes)
            //robot = try container.decode(Robot.self, forKey: .robot)
        }
}
