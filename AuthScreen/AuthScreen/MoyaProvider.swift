//
//  MoyaProvider.swift
//  AuthScreen
//
//  Created by Михаил on 31.08.2018.
//  Copyright © 2018 Михаил. All rights reserved.
//

import Foundation
import Moya

enum MoyaExampleService {
    case getWeather()
}

extension MoyaExampleService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=498698&APPID=1a30e0d24334dabe31b36d0e352370e7&units=metric")!
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
}
