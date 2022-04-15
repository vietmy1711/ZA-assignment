//
//  ApiManager.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import Foundation

class SavedKeys{
    public static let accessToken = "access_token"
    public static var accessKey: String {
        return ProcessInfo.processInfo.environment["ACCESS_KEY"] ?? ""
    }
    public static var secretKey: String {
        return ProcessInfo.processInfo.environment["SECRET_KEY"] ?? ""
    }
}

class ApiManager {
    public static let shared = ApiManager()
    
    let baseUrl = "https://unsplash.com/"
    
    func setAccessToken(_ accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: SavedKeys.accessToken)
    }
    
    func getAccessToken() -> String?{
        UserDefaults.standard.string(forKey: SavedKeys.accessToken)
    }
}
