//
//  SettingControllerViewController.swift
//  MapWithRobots(Scand)
//
//  Created by 123 on 23.02.24.
//

import UIKit
import SnapKit

protocol SettingControllerDelegate: AnyObject {
    func didChangeRoboStepperValue(_ value: Double)
}

class SettingController: UIViewController {
    
    var roboImages: [UIImageView] = []
    let roboStepper = UIStepper(frame: CGRect(x: 50, y: 100, width: 200, height: 30))
    let countLabel = UILabel()
    let doneButton = UIButton()
    weak var delegate: SettingControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        let initialRoboCount = UserDefaults.standard.integer(forKey: "RoboCount")
        roboStepper.value = Double(initialRoboCount)
        countLabel.text = "\(Int(roboStepper.value))"
        updateRoboImages()
    }
    
    func setupUI() {
        view.addSubview(roboStepper)
        roboStepper.minimumValue = 2
        roboStepper.maximumValue = 3
        roboStepper.value = 2
        
        roboStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        roboStepper.snp.makeConstraints { stepper in
            stepper.centerX.equalToSuperview()
            stepper.top.equalToSuperview().offset(120)
        }
        
        view.addSubview(countLabel)
        countLabel.textAlignment = .center
        
        countLabel.snp.makeConstraints { label in
            label.centerX.equalToSuperview()
            label.top.equalTo(roboStepper.snp.bottom).offset(20)
        }
        
        view.addSubview(doneButton)
        doneButton.setTitle("Save", for: .normal)
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = UIColor.black.cgColor
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 12
        doneButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 25)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        doneButton.snp.makeConstraints { button in
            button.top.equalTo(countLabel.snp.bottom).offset(120)
            button.left.right.equalToSuperview().inset(95)
            button.height.equalTo(60)
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
        let roboCount = Int(roboStepper.value)
        countLabel.text = "\(roboCount)"
        UserDefaults.standard.set(roboCount, forKey: "RoboCount")
        UserDefaults.standard.set(roboCount, forKey: "StepperValue")
        updateRoboImages()
        delegate?.didChangeRoboStepperValue(roboStepper.value)
    }
    
    @objc func doneButtonAction() {
        let roboCount = Int(roboStepper.value)
        UserDefaults.standard.set(roboCount, forKey: "RoboCount")
        UserDefaults.standard.set(roboCount, forKey: "StepperValue")
        updateRoboImages()
        dismiss(animated: true)
    }

}
