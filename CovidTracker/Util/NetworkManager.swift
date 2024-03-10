//
//  NetworkManager.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getAllStates(completion: @escaping (Result<StateModel, Error>) -> (Void)) {
        guard let url = Constants.allStateUrl else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkManagerError.badResponse(response)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkManagerError.badData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(StateModel.self, from: data)
                let resultSerialization = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(resultSerialization)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCovidDataOfState(
        for scope: StateScope,
        completion: @escaping (Result<CovidModel, Error>) -> (Void)
    ) {
        let urlString: String
        
        switch scope {
        case .national: urlString = ""
        case .state(let state): 
            if let stateCode = state.state_code {
                urlString = "https://api.covidtracking.com/v2/states/\(stateCode.lowercased())/daily/simple.json"
            } else {
                urlString = ""
            }
        }
        
        print(urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkManagerError.badResponse(response)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkManagerError.badData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CovidModel.self, from: data)
                let resultSerialization = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(resultSerialization)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
