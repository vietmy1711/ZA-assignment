//
//  AuthModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

class AuthModel: Codable {
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
}
