//
//  ViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class SpaceXMainViewController: UIViewController {

    var launchesButton: UIButton!
    var rocketsButton: UIButton!

    let mainStackView: UIStackView = createStackView(axis: .vertical, alignement: .center, distribution: .fill, spacing: nil)
    
    let centeredStackView: UIStackView = createStackView(axis: .horizontal, alignement: .center, distribution: .fillEqually, spacing: 10)
    
    private func createNavigationButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        return button
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = spaceXMainViewControllerTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        self.view.backgroundColor = .white
        self.view.addSubview(mainStackView)
        
        launchesButton = createNavigationButton()
        rocketsButton =  createNavigationButton()
        
        mainStackView.addArrangedSubview(centeredStackView)
        centeredStackView.addArrangedSubview(launchesButton)
        centeredStackView.addArrangedSubview(rocketsButton)
        
        setupNavigationButtons()
        autoLayout()
    }
    
    private func setupNavigationButtons() {
        launchesButton.backgroundColor = appThemeColor
        rocketsButton.backgroundColor = appThemeColor
        launchesButton.setTitle(launchesButtonTitle, for: .normal)
        rocketsButton.setTitle(rocketsButtonTitle, for: .normal)
        launchesButton.addTarget(self, action: #selector(navigationButtonTapped(_:)), for: .touchUpInside)
        rocketsButton.addTarget(self, action: #selector(navigationButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func navigationButtonTapped(_ sender: UIButton) {
        let viewController: UIViewController = sender.titleLabel?.text == launchesButtonTitle
            ? LaunchesViewController()
            : RocketsViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func autoLayout() {
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            // centered stack view
            centeredStackView.leadingAnchor
                .constraint(equalTo: mainStackView.leadingAnchor, constant: appLaunchScreenButtonWrapperPadding),
            centeredStackView.trailingAnchor
                .constraint(equalTo: mainStackView.trailingAnchor, constant: -appLaunchScreenButtonWrapperPadding)
        ])
    }
}
