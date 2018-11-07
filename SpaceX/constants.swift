//
//  constants.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import Foundation
import UIKit


let appThemeColor = UIColor(red: 15 / 255, green: 55 / 255, blue: 75 / 255, alpha: 1)

let launchInfoNormalTextColor = UIColor(red: 15 / 255, green: 55 / 255, blue: 75 / 255, alpha: 1),
    launchInfoSmallTextColor = UIColor(red: 15 / 255, green: 55 / 255, blue: 75 / 255, alpha: 0.5)

let launchInfoNormalTextFont = UIFont.systemFont(ofSize: 17),
    launchInfoSmallTextFont = UIFont.systemFont(ofSize: 15)

let appThemeColorForLaunchView = UIColor(red: 15 / 255, green: 55 / 255, blue: 75 / 255, alpha: 0.2)

let spaceXMainViewControllerTitle = "SpaceX",
    spaceXLaunchesViewControllerTitle = "Launches",
    spaceXRocketsViewControllerTitle = "Rockets"

let appLaunchScreenButtonWrapperPadding: CGFloat = 30

let launchesButtonTitle: String = "Launches"

let rocketsButtonTitle: String = "Rockets"

let launchesTableCellHeight:CGFloat = 600
let launchesCollectionCellHeight: CGFloat = 300

let selectedCellBackgroundColor = UIColor(red: 15 / 255, green: 55 / 255, blue: 75 / 255, alpha: 1)

let launchesTableNumberOfRows = 3

let launchesCellPadding: CGFloat = 10

let rocketMainStackPadding: CGFloat = 10

// how much of the launch view is filled by the rocket image
let imageViewProportion: CGFloat = 6 / 16
let normalCardImageViewProportion: CGFloat = 6 / 16
let smallCardImageViewProportion: CGFloat = 3.5 / 16

struct LaunchList: Codable {
    let launches: [Launch]
}

struct Launch: Codable {
    let flight_number: Int
    let launch_date_unix: TimeInterval

    var images: [UIImage?] = []
    var date: Date?
    
    let rocket: Rocket
    let launch_site: LaunchSite
    let launch_success: Bool?
    let links: ImageLinks
    let details: String?
    
    enum CodingKeys: String, CodingKey {
        case flight_number
        case launch_date_unix
        case rocket
        case launch_site
        case launch_success
        case links
        case details
    }
}

// just a dummy object to fill space before the actual data is fetched
let _launch = Launch(flight_number: 1,
                    launch_date_unix: 0,
                    images: [],
                    date: Date(),
                    rocket: Rocket(rocket_id: "smdl", rocket_name: "lsmdlçm", rocket_type: "lmdsd"),
                    launch_site: LaunchSite(site_id: "mkd",
                                            site_name: "smdlm",
                                            site_name_long: "skodmd"),
                    launch_success: true,
                    links: ImageLinks(flickr_images: ["lsmdm", "smdmd"]),
                    details: "Ljojdfmn")

struct ImageLinks: Codable {
    let flickr_images: [String]
}

struct LaunchSite: Codable {
    let site_id: String
    let site_name: String
    let site_name_long: String
}

struct Rocket: Codable {
    let rocket_id: String
    let rocket_name: String
    let rocket_type: String
}

struct CompleteRocketObejct: Codable {
    let rocket_id: String
    let rocket_name: String
    let rocket_type: String
    let flickr_images: [String]
}

let infoItemTextPadding: CGFloat = 10

let cellTitles: [String] = ["Latest Launch", "Future Launches", "Past Launches"]

let latestUrl = "https://api.spacexdata.com/v3/launches/latest"
let futureUrl = "https://api.spacexdata.com/v3/launches/upcoming"
let pastUrl = "https://api.spacexdata.com/v3/launches/past"

func fetch(requestURL: String, callback: @escaping (Data?) -> ()) {
    let url = URL(string: requestURL)
    
    let res = URLSession.shared.dataTask(with: url!) {
        (data, response, error) in
        
        if(error != nil) { print("Failure to fetch url: \(requestURL). error info: \(error!)"); return }
        
        guard let data = data else { print("Error unwrapping fetched data"); return }
        
        callback(data)
    }
    res.resume()
}


func createStackView(
    translatesAutoResizingMaskIntoConstraints: Bool? = false,
    axis: NSLayoutConstraint.Axis?,
    alignement: UIStackView.Alignment?,
    distribution: UIStackView.Distribution?,
    spacing: CGFloat?)
    -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = translatesAutoResizingMaskIntoConstraints!
        stack.axis = axis ?? .vertical
        stack.alignment = alignement ?? .fill
        stack.distribution = distribution ?? .fill
        stack.spacing = spacing ?? 0
        return stack
}

enum LaunchInfoFontType {
    case small
    case normal
}

protocol textChanges {
    
    func getFontColor(for size: LaunchInfoFontType) -> UIColor
    func getFont(for size: LaunchInfoFontType) -> UIFont
}

extension textChanges {
    func getFontColor(for size: LaunchInfoFontType) -> UIColor {
        return size == .small
            ? launchInfoSmallTextColor
            : launchInfoNormalTextColor
    }
    
    func getFont(for size: LaunchInfoFontType) -> UIFont {
        return size == .small
            ? launchInfoSmallTextFont
            : launchInfoNormalTextFont
    }
}

extension UILabel : textChanges {}
extension UITextView : textChanges {}
