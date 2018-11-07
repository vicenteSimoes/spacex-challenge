//
//  SiteView.swift
//  SpaceX
//
//  Created by Vicente Simões on 07/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit
import MapKit

class SiteView: UIView {
    
    var data: [String : String] = [:]
    
    let mainStack: UIStackView = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .vertical, alignement: .fill, distribution: .fillEqually, spacing: nil)
    
    let infoStack = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .vertical, alignement: .fill, distribution: .fillEqually, spacing: 10)
    
    let defaultLocation = CLLocation(latitude: 38.708189, longitude: -9.150635)
    let mapView: MKMapView = MKMapView()
    let radius: CLLocationDistance = 1000
    var annotation = MKPointAnnotation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // info stack
        mainStack.addArrangedSubview(infoStack)
        mainStack.addArrangedSubview(mapView)
        centerMapOnLocation(location: defaultLocation)
        
        annotation.title = "Farfetch"
        annotation.coordinate = defaultLocation.coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    func createNewLabel(_label: String, _value: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = _label
        label.font = label.getFont(for: .small)
        label.textColor = label.getFontColor(for: .small)
        
        let value = UILabel()
        value.translatesAutoresizingMaskIntoConstraints = false
        value.text = _value
        value.font = label.getFont(for: .normal)
        value.textColor = label.getFontColor(for: .normal)
        value.numberOfLines = 0
        value.lineBreakMode = .byWordWrapping
        
        view.addSubview(label)
        view.addSubview(value)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            value.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            value.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            value.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            ])
        
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(withSite site: Site) {
        let location = CLLocation(latitude: site.location.latitude, longitude: site.location.longitude)
        annotation.coordinate = location.coordinate
        annotation.title = "\(site.siteNameLong)"
        mapView.addAnnotation(annotation)
        centerMapOnLocation(location: location)
        DispatchQueue.main.async {
            // "little" cheating happening here
            self.infoStack.addArrangedSubview(self.createNewLabel(_label: "", _value: ""))
            self.infoStack.addArrangedSubview(self.createNewLabel(_label: "Name (current status = \(site.status))", _value: site.siteNameLong))
            self.infoStack.addArrangedSubview(self.createNewLabel(_label: "Vehicles Lauched", _value: site.vehiclesLaunched.reduce(""){$0 + $1 + "\n"}))
            self.infoStack.addArrangedSubview(self.createNewLabel(_label: "Details", _value: site.details))
            // here too... sorry
            self.infoStack.addArrangedSubview(self.createNewLabel(_label: "", _value: ""))
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
}
