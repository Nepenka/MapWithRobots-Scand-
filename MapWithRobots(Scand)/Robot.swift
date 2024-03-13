//
//  Robot.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 25.02.24.
//

import Foundation
import UIKit


protocol RobotDelegate: AnyObject {
    func robot(_ robot: Robot, didSendMessage message: RobotMessage)
}


class Robot: Decodable {
    
    var partition: Partition
    var direction: Direction
    var command: [Command] = []
    var robotID: Int = 0
    var warehouse: Warehouse
    static var robotCounter = 0
    weak var delegate: RobotDelegate?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.partition = try container.decode(Partition.self, forKey: .partition)
        self.direction = try container.decode(Direction.self, forKey: .direction)
        self.robotID = try container.decode(Int.self, forKey: .robotID)
        self.warehouse = try container.decode(Warehouse.self, forKey: .warehouse)
    }
    
    init(partition: Partition, direction: Direction, command: [Command], warehouse: Warehouse) {
        self.partition = partition
        self.direction = direction
        self.command = command
        self.warehouse = warehouse
        self.robotID = Robot.robotCounter
        Robot.robotCounter += 1
    }
    
    private enum CodingKeys: String, CodingKey {
        case partition
        case direction
        case command
        case robotID
        case warehouse
    }
    
    
    func moveRobot(to target: Partition) {
        guard (warehouse.boxes.sorted(by: { distanceBetween(p1: partition, p2: $0.position) < distanceBetween(p1: partition, p2: $1.position) }).first != nil) else {
            return
        }
        if isObstacles(at: target), isRobot(at: target), isWall(at: target) {
            turnRight()
            let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Робот поменял направление из-за препятствия")
            delegate?.robot(self, didSendMessage: message)
        } else {
            self.partition = target
            let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Передвинулся на \(partition)")
            delegate?.robot(self, didSendMessage: message)
        }
    }

    func distanceBetween(p1: Partition, p2: Box.Position) -> Double {
        let diffX = p2.x - p1.x
        let diffY = p2.y - p1.y
        
        return sqrt(pow(Double(diffX), 2) + pow(Double(diffY), 2))
      }
    
    func isObstacles(at partition: Partition) -> Bool {
        let hasObstacles = warehouse.obstacles.contains(where: { $0.x == partition.x && $0.y == partition.y })
        if hasObstacles {
            let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Робот обнаружил препятствие")
            delegate?.robot(self, didSendMessage: message)
        }
        return hasObstacles
    }
    
    func isRobot(at partition: Partition) -> Bool {
            for index in 0..<warehouse.robots.count {
                let robot = warehouse.robots[index]
                if robot.partition.x == partition.x && robot.partition.y == partition.y {
                    robot.turnRight()
                    let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Робот развернулся из-за другого робота")
                    delegate?.robot(self, didSendMessage: message)
                    return true
                }
            }
        
            return false
        }
    
    
    func isWall(at partition: Partition) -> Bool {
        let isPartitionWall = warehouse.partitions.contains(where: { $0.x == partition.x && $0.y == partition.y })
        let isOutsideWarehouse = partition.x < 0 || partition.y < 0
            || partition.x >= warehouse.dimensions.width
            || partition.y >= warehouse.dimensions.height
        
        if isPartitionWall || isOutsideWarehouse {
            let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Робот достиг границы склада или стены")
            delegate?.robot(self, didSendMessage: message)
        }
        
        return isPartitionWall || isOutsideWarehouse
    }
    
    func detectedBoxInFront() -> Int? {
        let possiblePositions = [
            (partition.x + direction.dx, partition.y + direction.dy),
            (partition.x + direction.dx + direction.dy, partition.y + direction.dy - direction.dx),
            (partition.x + direction.dx - direction.dy, partition.y + direction.dy + direction.dx)
        ]
        
        for (_, position) in possiblePositions.enumerated() {
            if let foundIndex = warehouse.boxes.firstIndex(where: {$0.position.x == position.0 && $0.position.y == position.1}) {
                let message = RobotMessage(senderID: robotID, partition: partition, action: .turnRight, intention: "Ящик найден в \(position) с индексом \(foundIndex)")
                delegate?.robot(self, didSendMessage: message)
                return foundIndex
            }
        }
        
        return nil
    }
    
    func pushBoxToExit() {
        guard let boxIndex = detectedBoxInFront() else {
            return
        }

        var box = warehouse.boxes[boxIndex]

        let targetX = box.position.x + direction.dx
        let targetY = box.position.y + direction.dy
        let targetPartition = Partition(x: targetX, y: targetY)

       
        if !isObstacles(at: targetPartition) && !isBox(at: targetPartition) {
           
            box.position.x = targetX
            box.position.y = targetY
            warehouse.boxes[boxIndex] = box
            self.partition = Partition(x: targetX, y: targetY)

            
            let message = RobotMessage(senderID: robotID, partition: partition, action: .moveForward, intention: "Толкнул ящик на \(targetPartition)")
            delegate?.robot(self, didSendMessage: message)
        }
    }
    
    func isBox(at partition: Partition) -> Bool {
        return warehouse.boxes.contains(where: {$0.position.x == partition.x && $0.position.y == partition.y})
    }
    
    func turnRight() {
        switch direction {
        case .up:
            direction = .right
        case .down:
            direction = .left
        case .left:
            direction = .up
        case .right:
            direction = .down
        case .none:
            break
        }
    }
}
