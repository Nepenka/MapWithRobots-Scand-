//
//  ViewController.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 22.02.24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let settingsButton = UIButton(type: .custom)
    let warehouseMapView = WarehouseMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        let warehouse = createWarehouse()
        warehouseMapView.setupWarehouse(warehouse)
    }
    
    
    private func setupUI() {
        view.addSubview(settingsButton)
        view.addSubview(warehouseMapView)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.frame = CGRect(x: 150, y: 150, width: 200, height: 50)
        
        
        settingsButton.snp.makeConstraints { setting in
            setting.top.equalToSuperview().offset(40)
            setting.right.equalToSuperview().inset(20)
            setting.height.equalTo(65)
            setting.width.equalTo(65)
            
        }
        
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        
        warehouseMapView.snp.makeConstraints { map in
            map.centerX.equalToSuperview().offset(60)
            map.centerY.equalToSuperview().offset(30)
            map.width.equalToSuperview().multipliedBy(0.5)
            map.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    @objc func settingsAction() {
        let vc = SettingController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
    }
    
    private func createWarehouse() -> Warehouse {
        let dimensions = (width: 10, height: 8)
        let entrance = (x: 2, y: 0)
        let exit = (x: 9, y: 5)
        
        let obstacles: [Partition] = [(x: 2, y: 3), (x: 5, y: 5)].map { Partition(x: $0.x, y: $0.y) }
        let partitions: [Partition] = [
            (x: 0, y: 0), (x: 0, y: 1), (x: 0, y: 2), (x: 0, y: 3),
            (x: 0, y: 4), (x: 0, y: 5), (x: 0, y: 6), (x: 0, y: 7),
            (x: 9, y: 0), (x: 9, y: 1), (x: 9, y: 2), (x: 9, y: 3),
            (x: 9, y: 4), (x: 9, y: 5), (x: 9, y: 6), (x: 9, y: 7),
            (x: 1, y: 0), (x: 2, y: 0), (x: 3, y: 0), (x: 4, y: 0),
            (x: 5, y: 0), (x: 6, y: 0), (x: 7, y: 0), (x: 8, y: 0),
            (x: 1, y: 7), (x: 2, y: 7), (x: 3, y: 7), (x: 4, y: 7),
            (x: 5, y: 7), (x: 6, y: 7), (x: 7, y: 7), (x: 8, y: 7)
        ].map { Partition(x: $0.x, y: $0.y) }
        
        let boxes: [Box] = [
            Box(id: 1, position: Box.Position(x: 3, y: 2)),
            Box(id: 2, position: Box.Position(x: 7, y: 6)),
            Box(id: 3, position: Box.Position(x: 4, y: 4))
        ]
        
        return Warehouse(dimensions: dimensions, entrance: entrance, exit: exit, obstacles: obstacles, partitions: partitions, boxes: boxes)
    }

}
