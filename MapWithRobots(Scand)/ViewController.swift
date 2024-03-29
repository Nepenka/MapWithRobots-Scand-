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
    let tableView = UITableView()
    let startButton = UIButton()
    var messageQueue: [RobotMessage] = []
    private var robotImageView: [UIImageView] = []
    weak var delegate: RobotDelegate?
    var currentRobotCount: Int = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        let warehouse = createWarehouse()
        warehouseMapView.setupWarehouse(warehouse)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    private func setupUI() {
        view.addSubview(settingsButton)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.frame = CGRect(x: 150, y: 150, width: 200, height: 50)
        
        settingsButton.snp.makeConstraints { setting in
            setting.top.equalToSuperview().offset(40)
            setting.right.equalToSuperview().inset(20)
            setting.height.equalTo(65)
            setting.width.equalTo(65)
        }
        
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        
        view.addSubview(warehouseMapView)
        warehouseMapView.snp.makeConstraints { map in
            map.trailing.equalToSuperview().inset(20)
            map.centerY.equalTo(view.snp.centerY)
            map.width.equalToSuperview().multipliedBy(0.5)
            map.height.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { table in
            table.leading.equalToSuperview().offset(20)
            table.trailing.equalTo(warehouseMapView.snp.leading).offset(-20)
            table.width.equalTo(200)
            table.centerY.equalTo(warehouseMapView.snp.centerY)
            table.height.equalTo(warehouseMapView.snp.height)
        }
        
        view.addSubview(startButton)
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 12
        startButton.layer.masksToBounds = true
        startButton.setTitle("Start", for: .normal)
        startButton.snp.makeConstraints { start in
            start.centerX.equalTo(tableView)
            start.top.equalTo(tableView.snp.bottom).offset(20)
            start.width.equalTo(100)
            start.height.equalTo(50)
        }
        
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        
    }

    
    @objc func settingsAction() {
        let vc = SettingController()
        vc.delegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
    }

    
    func updateRobotsCount(_ count: Int) {
            currentRobotCount = count
            warehouseMapView.clearRobots()
            for id in 1...count {
                let robotView = UIImageView(image: UIImage(named: "robots.png"))
                let coordinate = (x: id, y: id, id: id)
                let partition = Partition(x: coordinate.x, y: coordinate.y)
                warehouseMapView.addRobot(at: partition, robotView: robotView)
            }
        }

    
    @objc func startButtonAction() {
        let warehouse = createWarehouse()
        warehouseMapView.clearRobots()

        
        for _ in 1...currentRobotCount {
            let randomX = Int.random(in: 0..<warehouse.dimensions.width)
            let randomY = Int.random(in: 0..<warehouse.dimensions.height) 
            let partition = Partition(x: randomX, y: randomY)
            let robotView = UIImageView(image: UIImage(named: "robots.png"))
            warehouseMapView.addRobot(at: partition, robotView: robotView)

            let robot = Robot(partition: partition, direction: .up, command: [.turnLeft, .turnRight, .moveForward], warehouse: warehouse)
            robot.delegate = self

            let boxIndex = robot.detectedBoxInFront()
            if boxIndex != nil {
                let targetPartition = Partition(x: partition.x + 1, y: partition.y)
                robot.moveRobot(to: targetPartition)
                robot.pushBoxToExit()
            } else {
                let targetPartition = Partition(x: partition.x + 1, y: partition.y)
                robot.moveRobot(to: targetPartition)
            }
        }

        warehouseMapView.setupWarehouse(warehouse) // Обновление карты склада после создания роботов
    }



    
    private func updateTableView() {
        
        tableView.reloadData()
    }
    
    public func createWarehouse() -> Warehouse {
        let dimensions = (width: 10, height: 8)
        let entrance = (x: 2, y: 0)
        let exit = (x: 9, y: 5)
        let robots: [Robot] = []
        
        let obstacles: [Partition] = [(x: 2, y: 3), (x: 5, y: 5), (x:4, y: 1), (x: 5, y: 6)].map { Partition(x: $0.x, y: $0.y) }
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
            Box(id: 1, position: Box.Position(x: 3, y: 3)),
            Box(id: 2, position: Box.Position(x: 4, y: 5)),
            Box(id: 3, position: Box.Position(x: 6, y: 3))
        ]
        
        return Warehouse(dimensions: dimensions, entrance: entrance, exit: exit, obstacles: obstacles, partitions: partitions, boxes: boxes, robots: robots)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageQueue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        let message = messageQueue[indexPath.row]
        cell.textLabel?.text = "\(message.senderID): \(message.intention)"
        
        return cell
    }
}

//MARK: - RobotDelegate


extension ViewController: RobotDelegate {
    func robot(_ robot: Robot, didSendMessage message: RobotMessage) {
        messageQueue.insert(message, at: 0)
        updateTableView()
    }
}

//MARK: - SettingControllerDelegate

extension ViewController: SettingControllerDelegate {
    func didChangeRoboStepperValue(_ value: Double) {
        
        updateRobotsCount(Int(value))
    }
}
