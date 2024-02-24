//
//  WarehouseMapView.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 24.02.24.
//

import UIKit

class WarehouseMapView: UIView {

    var warehouse: Warehouse?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
    }
    
    func setupWarehouse(_ warehouse: Warehouse) {
        self.warehouse = warehouse
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let warehouse = warehouse else {return}
        
        let tileSize = CGSize(width: rect.width / CGFloat(warehouse.dimensions.width),
                              height: rect.height / CGFloat(warehouse.dimensions.height))
        
        for obstacle in warehouse.obstacles {
            let obstacleRect = CGRect(x: CGFloat(obstacle.x) * tileSize.width,
                                      y: CGFloat(obstacle.y) * tileSize.height,
                                      width: tileSize.width,
                                      height: tileSize.height)
            UIColor.red.setFill()
            UIBezierPath(rect: obstacleRect).fill()
        }
        
        for partition in warehouse.partitions {
            let partitionRect = CGRect(x: CGFloat(partition.x) * tileSize.width,
                                       y: CGFloat(partition.y) * tileSize.height,
                                       width: tileSize.width,
                                       height: tileSize.height)
            
            UIColor.blue.setFill()
            UIBezierPath(rect: partitionRect).fill()
        }
        
        for box in warehouse.boxes {
            let boxesRect = CGRect(x: CGFloat(box.position.x) * tileSize.width,
                                   y: CGFloat(box.position.y) * tileSize.height,
                                   width: tileSize.width,
                                   height: tileSize.height)
            
            UIColor.green.setFill()
            UIBezierPath(rect: boxesRect).fill()
        }
        
        let entranceRect = CGRect(x: CGFloat(warehouse.entrance.x) * tileSize.width,
                                  y: CGFloat(warehouse.entrance.y) * tileSize.height,
                                  width: tileSize.width,
                                  height: tileSize.height)
        UIColor.orange.setFill()
        UIBezierPath(rect: entranceRect).fill()
        
        let exitRect = CGRect(x: CGFloat(warehouse.exit.x) * tileSize.width,
                              y: CGFloat(warehouse.exit.y) * tileSize.height,
                              width: tileSize.width,
                              height: tileSize.height)
        UIColor.purple.setFill()
        UIBezierPath(rect: exitRect).fill()
    }

}
