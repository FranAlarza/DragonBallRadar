//
//  HeroModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 11/9/22.
//

import Foundation

struct Hero: Decodable {
    let description, name, id: String
    let photo: URL
    let favorite: Bool
    var latitud: Double?
    var longitud: Double?
}
