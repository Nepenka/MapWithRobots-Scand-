//
//  WarehouseMapView.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 24.02.24.
//

import UIKit

class WarehouseMapView: UIView {
    
    var warehouse: Warehouse?

    private(set) var tileSize: CGSize = .zero

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
        
        guard let warehouse = warehouse else { return }
        
        tileSize = CGSize(width: rect.width / CGFloat(warehouse.dimensions.width),
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
            
            UIColor.gray.setFill()
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
        
        
        drawLabelBackground(at: warehouse.entrance, with: tileSize, color: .white)
        
        drawLabel("Вход", at: warehouse.entrance, with: tileSize, color: .black)
        
        drawLabelBackground(at: warehouse.exit, with: tileSize, color: .white)
        
        drawLabel("Выход", at: warehouse.exit, with: tileSize, color: .black)
    }

  func addRobot(at coordinate: Partition, robotView: UIView) {
    guard let warehouse,
          coordinate.x <= warehouse.dimensions.width,
          coordinate.x >= 0,
          coordinate.y <= warehouse.dimensions.height,
          coordinate.y >= 0,
          tileSize.width > .zero,
          tileSize.height > .zero
    else {
      return
    }

    addSubview(robotView)
    robotView.frame.size.width = tileSize.width
    robotView.frame.size.height = tileSize.height
    robotView.frame.origin = .init(x: CGFloat(coordinate.x) * tileSize.width,
                                   y: CGFloat(coordinate.y) * tileSize.height)
  }

    private func drawLabelBackground(at position: (x: Int, y: Int), with tileSize: CGSize, color: UIColor) {
        let labelRect = CGRect(x: CGFloat(position.x) * tileSize.width,
                               y: CGFloat(position.y) * tileSize.height,
                               width: tileSize.width,
                               height: tileSize.height)
        
        color.setFill()
        UIBezierPath(rect: labelRect).fill()
    }
    
    private func drawLabel(_ text: String, at position: (x: Int, y: Int), with tileSize: CGSize, color: UIColor) {
        let labelRect = CGRect(x: CGFloat(position.x) * tileSize.width,
                               y: CGFloat(position.y) * tileSize.height,
                               width: tileSize.width,
                               height: tileSize.height)
        
        let label = UILabel(frame: labelRect)
        label.text = text
        label.textAlignment = .center
        label.textColor = color
        
        addSubview(label)
    }
}
