//
//  SettingControllerViewController.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 23.02.24.
//

import UIKit
import SnapKit

class SettingController: UIViewController {
    
    var roboImages: [UIImageView] = []
    let roboStepper = UIStepper(frame: CGRect(x: 50, y: 100, width: 200, height: 30))
    let countLabel = UILabel()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        countLabel.text = "\(Int(roboStepper.value))"
    }
    
    func setupUI() {
        view.addSubview(roboStepper)
        view.addSubview(countLabel)
        
        roboStepper.minimumValue = 2
        roboStepper.maximumValue = 4
        roboStepper.value = 2
        
        roboStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        countLabel.textAlignment = .center
        
        roboStepper.snp.makeConstraints { stepper in
            stepper.centerX.equalToSuperview()
            stepper.top.equalToSuperview().offset(120)
        }
        
        countLabel.snp.makeConstraints { label in
            label.centerX.equalToSuperview()
            label.top.equalTo(roboStepper.snp.bottom).offset(20)
        }
        
        updateRoboImages()
    }
    
    
    func updateRoboImages() {
        
        for roboImage in roboImages {
            roboImage.removeFromSuperview()
        }
        roboImages.removeAll()
        
        
        let roboCount = Int(roboStepper.value)
        let imageSize = CGSize(width: 50, height: 50)
        let spacing: CGFloat = 20
        
        var previousRoboImage: UIImageView?
        
        for _ in 0..<roboCount {
            let roboImage = UIImageView(image: UIImage(named: "robots.png"))
            roboImage.contentMode = .scaleAspectFit
            view.addSubview(roboImage)
            roboImages.append(roboImage)
            
            roboImage.snp.makeConstraints { image in
                image.top.equalTo(countLabel.snp.bottom).offset(20)

                if let previousImage = previousRoboImage {
                    image.left.equalTo(previousImage.snp.right).offset(spacing)
                } else {
                    image.left.equalToSuperview().offset(spacing)
                }
                image.size.equalTo(imageSize)
            }
            
            previousRoboImage = roboImage 
        }
    }
    
    @objc func stepperValueChanged() {
        countLabel.text = "\(Int(roboStepper.value))"
        updateRoboImages()
    }

}
