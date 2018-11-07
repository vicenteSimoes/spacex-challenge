//
//  LaunchView.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class LaunchView: UIView {
    
    var launch: Launch?
    weak var delegate: UIViewController?
    let rocketImageView = RocketImageView(image: UIImage(named: "loading")!)
    
    var mainStack: UIStackView!
    var imageViewStack: UIStackView!
    var imageView:RocketImageView!
    var infoStack: UIStackView!
    var isSmallCard: Bool = false
    var infoItems: [LaunchInfoItem] = []
    
    var respondToSelf: Bool = true
    
    convenience init(launch: Launch, asSmallCard small: Bool? = false) {
        self.init(frame: CGRect())
        
        self.setupTap()
        self.launch = launch
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSmallCard = small!
        setupView()
        autoLayout()
    }
    
    func setupTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapInsideLaunchView))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func didTapInsideLaunchView(_ sender: Any?) {
        if let launch = self.launch, let delegate = delegate {
            let viewController: Any!
            if let _ = sender as? RocketImageView {
                viewController = RocketViewController(withRocketId: launch.rocket.rocket_id)
            }
            else {
                if !respondToSelf { return }
                viewController = LaunchViewController(launch: launch)
            }
            delegate.presentNewViewController(vc: viewController as! UIViewController)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = appThemeColorForLaunchView
        let imageViewProportion = isSmallCard ? smallCardImageViewProportion : normalCardImageViewProportion
        
        mainStack = createStackView(axis: nil, alignement: nil, distribution: nil, spacing: 10)
        imageViewStack = createStackView(axis: nil, alignement: nil, distribution: nil, spacing: nil)
        infoStack = createStackView(axis: nil, alignement: nil, distribution: .fillEqually, spacing: 5)
        
        self.addSubview(mainStack)
        
        setupInfoStack()
        
        imageViewStack.heightAnchor.constraint(equalToConstant: launchesTableCellHeight * imageViewProportion ).isActive = true
        imageViewStack.backgroundColor = .white
        mainStack.addArrangedSubview(imageViewStack)
        mainStack.addArrangedSubview(infoStack)
        
        imageView = rocketImageView
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageViewStack.addArrangedSubview(imageView)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: launchesCellPadding),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: launchesCellPadding),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -launchesCellPadding),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -launchesCellPadding)
        ])
    }
    
    func setupInfoStack() {
        let numberOfItems = isSmallCard ? 2 : 6
        
        infoItems.append(LaunchInfoItem(infoTopic: "Rocket"))
        infoItems.append(LaunchInfoItem(infoTopic: "Launch Date"))
        infoItems.append(LaunchInfoItem(infoTopic: "Launch Number"))
        infoItems.append(LaunchInfoItem(infoTopic: "Launch Site"))
        infoItems.append(LaunchInfoItem(infoTopic: "Launch Status"))
        infoItems.append(LaunchInfoItem(infoTopic: "Details"))
        
        for i in 0 ..< numberOfItems {
            infoStack.addArrangedSubview(infoItems[i])
        }
    }
}

extension LaunchView {
    func updateValues(forLaunch launch: Launch){
        self.launch = launch
        // get the first image to be displayed here
        // try to load the first image
        if !self.imageView.loadImageFromUrl(launch.links.flickr_images) {
            self.imageView.loadImageFromRocketUrl(launch.rocket.rocket_id)
        }
        // update the label values
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let date = Date()
        let currDate = Date(timeIntervalSince1970: date.timeIntervalSince1970)
        let success = launch.launch_success ?? false
        let dateLabel = currDate < launch.date! ? "Unknown" : success ? "Success" : "Failure"
    
        DispatchQueue.main.async {
            self.infoItems[0].setInfoValue(withValue: launch.rocket.rocket_name)
            self.infoItems[1].setInfoValue(withValue: formatter.string(from: launch.date!))
            self.infoItems[2].setInfoValue(withValue: String(launch.flight_number))
            self.infoItems[3].setInfoValue(withValue: launch.launch_site.site_name_long)
            self.infoItems[4].setInfoValue(withValue: dateLabel)
            self.infoItems[5].setInfoValue(withValue: launch.details ?? "")
        }
    }
    
    func resetValues() {
        infoItems.forEach { $0.removeFromSuperview() }
        self.imageView.resetImage()
        self.setupInfoStack()
    }
    
    func setDelegate(delegate: UIViewController, shouldRespondToSelf: Bool? = true) {
        self.delegate = delegate
        self.rocketImageView.setDelegate(delegate: self)
        self.respondToSelf = shouldRespondToSelf!
    }
}
