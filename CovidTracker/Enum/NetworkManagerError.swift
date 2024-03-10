//
//  NetworkManagerError.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import Foundation

enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}
