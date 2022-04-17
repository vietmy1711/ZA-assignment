//
//  ApiRequest.swift
//  ZA-assignment
//
//  Created by VinBrain on 14/04/2022.
//

import Foundation

class ApiRequest {
    
    public static let shared = ApiRequest()
    
    func request(with customDomain: String, method: HTTPMethod, queryParams: [String: String], completionHandler: @escaping (Data?, ErrorType?, Error?)->Void) {
        handleRequest(url: customDomain, method: method, queryParams: queryParams, completionHandler: completionHandler)

    }
    
    func request(path: String, method: HTTPMethod, queryParams: [String: String], completionHandler: @escaping (Data?, ErrorType?, Error?)->Void) {
        handleRequest(url: ApiManager.shared.baseUrl + path, method: method, queryParams: queryParams, completionHandler: completionHandler)
    }
    
    func handleRequest(url: String, method: HTTPMethod, queryParams: [String: String], completionHandler: @escaping (Data?, ErrorType?, Error?)->Void) {
        guard NetworkManager.isConnectedToNetwork() else {
            completionHandler(nil, .fetchingNoInternet, nil)
            return
        }
        var components = URLComponents(string: url)!
        components.queryItems = queryParams.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        if (AuthRepository.shared.isLoggedIn) {
            request.setValue("Bearer \(String(describing: ApiManager.shared.getAccessToken() ?? ""))", forHTTPHeaderField: "Authorization")
        }

        print("Making request to: \(String(describing: components.url))")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, .fetchingUnknown, error)
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            completionHandler(data, nil, nil)
        }
        task.resume()
    }
}
