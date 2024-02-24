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
    let tableView = UITableView()
    let warehouseMapView = WarehouseMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
       // tableView.dataSource = self
        //tableView.delegate = self
        print(warehouseMapView.frame)
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
            map.centerX.equalToSuperview()
            map.centerY.equalToSuperview()
            map.width.equalToSuperview().multipliedBy(0.8)
            map.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    @objc func settingsAction() {
        let vc = SettingController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
    }
    
    private func createWarehouse() -> Warehouse {
        let dimensions = (width: 10, height: 8)
        let entrance = (x: 0, y: 0)
        let exit = (x: 9, y: 7)
        
        let obstacles: [Partition] = [(x: 2, y: 3), (x: 5, y: 5)].map { Partition(x: $0.x, y: $0.y) }
        let partitions: [Partition] = [(x: 1, y: 2), (x: 1, y: 3), (x: 1, y: 4), (x: 2, y: 2), (x: 2, y: 4), (x: 3, y: 4), (x: 4, y: 4), (x: 5, y: 4), (x: 6, y: 4), (x: 7, y: 4)].map { Partition(x: $0.x, y: $0.y) }
        
        let boxes: [Box] = [
            Box(id: 1, position: Box.Position(x: 3, y: 2, from: someValue)),
            Box(id: 2, position: Box.Position(x: 7, y: 6, from: someValue)),
            Box(id: 3, position: Box.Position(x: 4, y: 4, from: someValue))
        ]
        
        return Warehouse(dimensions: dimensions, entrance: entrance, exit: exit, obstacles: obstacles, partitions: partitions, boxes: boxes)
    }

}

/*

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

*/
