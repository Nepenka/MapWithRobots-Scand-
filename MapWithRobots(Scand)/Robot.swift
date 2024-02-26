//
//  Robot.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 25.02.24.
//

import Foundation
import UIKit

class Robot {
    var coordinate: Coordinate
    var direction: Direction
    var commands: [Command] = []
    var robotID: Int

    init(coordinate: Coordinate, direction: Direction, robotID: Int) {
        self.coordinate = coordinate
        self.direction = direction
        self.robotID = robotID
    }

    func addCommand(_ command: Command) {
        commands.append(command)
    }

    func executeCommands(onMap map: Map) {
        for command in commands {
            switch command {
            case .moveForward:
                moveForward(onMap: map)
            case .turnLeft:
                turnLeft()
            case .turnRight:
                turnRight()
            }
        }
        commands.removeAll()
    }
    
    func pushBox(onMap map: inout Map, robots: [Robot]) {
        let nextCoordinate = getNextCoordinate()
        
        guard let boxIndex = map.boxes.firstIndex(where: { $0.coordinate == nextCoordinate }) else {
            return
        }
        
        let exitDirection = calculateExitDirection(from: map, to: map.boxes[boxIndex].coordinate)
        
        guard exitDirection != .none else {
            return
        }
        
        let nextBoxCoordinate = Coordinate(x: nextCoordinate.x + exitDirection.dx, y: nextCoordinate.y + exitDirection.dy)
        
        guard isValidMove(to: nextBoxCoordinate, onMap: map, robots: robots) else {
            return
        }
        
        map.boxes[boxIndex].coordinate = nextCoordinate
        coordinate = nextCoordinate
    }

    private func moveForward(onMap map: Map) {
        let nextCoordinate = getNextCoordinate()
        if isValidMove(to: nextCoordinate, onMap: map, robots: []) {
            coordinate = nextCoordinate
        }
    }

    private func getNextCoordinate() -> Coordinate {
        var nextCoordinate = coordinate
        switch direction {
        case .up:
            nextCoordinate.y -= 1
        case .down:
            nextCoordinate.y += 1
        case .left:
            nextCoordinate.x -= 1
        case .right:
            nextCoordinate.x += 1
        case .none:
            return nextCoordinate
        }
        return nextCoordinate
    }

    private func isValidMove(to coordinate: Coordinate, onMap map: Map, robots: [Robot]) -> Bool {
        guard coordinate.x >= 0 && coordinate.x < map.dimensions.x &&
              coordinate.y >= 0 && coordinate.y < map.dimensions.y else {
            return false
        }

        if map.obstacles.contains(where: { $0 == coordinate }) {
            return false
        }

        if map.boxes.contains(where: { $0.coordinate == coordinate }) {
            return false
        }

        if robots.contains(where: { $0.coordinate == coordinate }) {
            return false
        }

        return true
    }
    
    private func calculateExitDirection(from map: Map, to coordinate: Coordinate) -> Direction {
        if coordinate.x == map.exit.x {
            return coordinate.y < map.exit.y ? .down : .up
        } else if coordinate.y == map.exit.y {
            return coordinate.x < map.exit.x ? .right : .left
        } else {
            return .none
        }
    }

    private func turnLeft() {
        switch direction {
        case .up:
            direction = .left
        case .down:
            direction = .right
        case .left:
            direction = .down
        case .right:
            direction = .up
        case .none:
            break
        }
    }

    private func turnRight() {
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
