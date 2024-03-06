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


class Robot  {
    
    var partition: Partition
    var direction: Direction
    var command: [Command] = []
    var robotID: Int = 0
    var warehouse: Warehouse
    weak var delegate: RobotDelegate?
    
    
    init(partition: Partition, direction: Direction, robotID: Int, warehouse: Warehouse) {
        self.partition = partition
        self.direction = direction
        self.robotID = robotID
        self.warehouse = warehouse
    }
    
    
    
    func moveRobot(to target: Partition) {
        guard (warehouse.boxes.sorted(by: { distanceBetween(p1: partition, p2: $0.position) < distanceBetween(p1: partition, p2: $1.position) }).first != nil)  else {
            return
        }
        if isObstacles(at: target) || isRobot(at: target) || isWall(at: target) {
            turnRight()
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
        return warehouse.obstacles.contains(where: {$0.x == partition.x && $0.y == partition.y})
    }
    
    func isRobot(at partition: Partition) -> Bool {
        let otherRobots = warehouse.robot.filter {$0.partition == partition && $0.robotID != self.robotID }
        return !otherRobots.isEmpty
    }
    
    func isWall(at partition: Partition) -> Bool {
        let isPartitionWall = warehouse.partitions.contains(where: {$0.x == partition.x && $0.y == partition.y})
        
        let isOutsideWarehouse = partition.x < 0 || partition.y < 0
            || partition.x >= warehouse.dimensions.width
            || partition.y >= warehouse.dimensions.height
        
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

        if isObstacles(at: targetPartition) || isBox(at: targetPartition) {
            return
        }

        box.position.x = targetX
        box.position.y = targetY
        self.partition = Partition(x: box.position.x, y: box.position.y)

        warehouse.boxes[boxIndex] = box

        let message = RobotMessage(senderID: robotID, partition: partition, action: .moveForward, intention: "Толкнул ящик на \(targetPartition)")
        delegate?.robot(self, didSendMessage: message)
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
