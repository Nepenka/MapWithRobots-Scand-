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
    let boxes: [Box]
}

struct Box: Decodable {
    let id: Int
    let position: Position
    
    struct Position: Decodable {
        let x: Int
        let y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, position
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        position = try container.decode(Position.self, forKey: .position)
    }
}

import Foundation




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
        }
}
