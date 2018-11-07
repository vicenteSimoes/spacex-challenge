//
//  RocketObj.swift
//  SpaceX
//
//  Created by Vicente Simões on 05/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import Foundation

typealias RocketList = [RocketObj]

struct RocketObj : Codable {
    let rocketName: String
    let rocketType: String
    let rocketId: String
    let active: Bool
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let stages: Int
    let engines: Engines
    let description: String
    
    var dimensions: [String : String] = [:]
    
    enum CodingKeys: String, CodingKey {
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
        case rocketId = "rocket_id"
        case active
        case height
        case diameter
        case mass
        case stages
        case engines
        case description
    }
}

struct Dimension: Codable {
    let meters: Double
}

typealias Height = Dimension
typealias Diameter = Dimension


struct Mass : Codable {
    let kg: Double
}

struct Engines: Codable {
    let number: Int
    let type: String
    let version: String
    let layout: String?
    let engineLossMax: Int?
    let propellant1, propellant2: String
    let thrustSeaLevel, thrustVacuum: Thrust
    let thrustToWeight: Double?
    
    enum CodingKeys: String, CodingKey {
        case number, type, version, layout
        case engineLossMax = "engine_loss_max"
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case thrustToWeight = "thrust_to_weight"
    }
}

struct Thrust: Codable {
    let kN, lbf: Int
}

