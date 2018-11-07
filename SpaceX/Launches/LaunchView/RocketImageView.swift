//
//  RocketImageView.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class RocketImageView: UIImageView {
    
    var storedImage: UIImage!
    var imageCache: [String : UIImage] = [:]
    weak var delegate: LaunchView?
    var rocket: Rocket?
    
    convenience init(image: UIImage) {
        self.init(frame: CGRect())
        self.storedImage = image
        setupTap()
        setupView()
    }
    
    func setupTap() {
        self.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapRocketImage))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func didTapRocketImage(_ sender: UIImageView) {
        if let delegate = self.delegate {
            delegate.didTapInsideLaunchView(self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentMode = .scaleAspectFit
        self.image = UIImage(named: "loading")
    }
}

extension RocketImageView {
    
    // On the next 2 methods I try to implement a crude cache just to improve a
    // bit on the latency fetching the images cost us
    func loadImageFromUrl(_ url: [String]?) -> Bool {
        if let url = url, url.count > 0 {
            if let image = self.imageCache[url[0]] {
                self.setImage(image: image)
                return true
            }
            self.fetchAndKeep(url: url[0]){ image in
                self.imageCache[url[0]] = image
            }
            return true
        }
        return false
    }
    
    func loadImageFromRocketUrl(_ rocket_id: String){
        let rocketURL = "https://api.spacexdata.com/v3/rockets/\(rocket_id)"
        if let image = self.imageCache[rocketURL] {
            self.setImage(image: image)
            return
        }
        fetch(requestURL: rocketURL) { rocketData in
            let decoder = JSONDecoder()
            let rocket = try! decoder.decode(CompleteRocketObejct.self, from: rocketData!)
            let imageArrayCount = rocket.flickr_images.count
            // try and get different images for the same rocket for UX reasons
            let randomRocket = Int.random(in: 0 ..< imageArrayCount)
            self.fetchAndKeep(url: rocket.flickr_images[randomRocket]){ image in
                self.imageCache[rocketURL] = image
            }
        }
    }
    
    func fetchAndKeep(url: String, callback: @escaping (UIImage?) -> ()) {
        fetch(requestURL: url) { imageData in
            guard let image = UIImage(data: imageData!) else { return }
            DispatchQueue.main.async {
                self.image = image
                callback(image)
            }
        }
    }
    
    func resetImage() {
        self.image = nil
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    func setDelegate(delegate: LaunchView) {
        self.delegate = delegate
    }
}
