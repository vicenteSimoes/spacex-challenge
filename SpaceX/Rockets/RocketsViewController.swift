//
//  RocketsViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class RocketsViewController: UIViewController {
    
    var rockets: [RocketObj]?
    
    let mainStack: UIStackView = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .vertical, alignement: .fill, distribution: .fillEqually, spacing: 20)
    
    let topStack: UIStackView = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .horizontal, alignement: .fill, distribution: .fillEqually, spacing: 20)
    
    let bottomStack: UIStackView = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .horizontal, alignement: .fill, distribution: .fillEqually, spacing: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupView()
        fetchAndPopulate()
        autoLayout()
    }
    
    func setupView() {
        self.view.addSubview(mainStack)
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(bottomStack)
    }
    
    @objc func rocketTapped(_ sender: RocketTapData) {
        self.navigationController?.pushViewController(RocketViewController(withRocketId: sender.rocket), animated: true)
    }
    
    func autoLayout() {
        let safeView = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: safeView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: safeView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = spaceXRocketsViewControllerTitle
    }
}

// We use this class in order to pass a rocket id to the selector since we cant pass any
// other arguments than sender. This way, each sender will hold its own rocket id
class RocketTapData: UITapGestureRecognizer {
    var rocketId: String = ""
    var rocket: String {
        get {
            return rocketId
        }
        set (newRocketId){
            return rocketId = newRocketId
        }
    }
}

extension RocketsViewController {
    func createSimpleTapableView(withSelector selector: Selector, backgroundColor: UIColor, labelText: String, rocketId: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 10
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame.size = CGSize(width: 100, height: 30)
        label.text = labelText
        label.textColor = .white
        label.textAlignment = .center
        
        view.addSubview(label)
        
        let tapRecognizer = RocketTapData(target: self, action: selector)
        tapRecognizer.rocket = rocketId
        
        view.addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        return view
    }
    
    func fetchAndPopulate() {
        fetch(requestURL: "https://api.spacexdata.com/v3/rockets") { data in
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let rockets = try! decoder.decode(RocketList.self, from: data)
            self.rockets = rockets
            for (index, rocket) in rockets.enumerated() {
                let stack = index < 2 ? self.topStack : self.bottomStack
                DispatchQueue.main.async {
                    stack.addArrangedSubview(
                        self.createSimpleTapableView(
                            withSelector: #selector(self.rocketTapped),
                            backgroundColor: appThemeColor,
                            labelText: rocket.rocketName,
                            rocketId: rocket.rocketId)
                    )
                }
            }
        }
    }
}
