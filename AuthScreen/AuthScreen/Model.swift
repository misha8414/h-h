//
//  File.swift
//  AuthScreen
//
//  Created by Михаил on 31.08.2018.
//  Copyright © 2018 Михаил. All rights reserved.
//

import Foundation

struct ResponseModel: Codable {
    let list: [AllTimeWeather]
}

struct AllTimeWeather: Codable {
    let main: ModelWeather
    let dt_txt: String
}

struct ModelWeather: Codable {
    let temp: Double
}


