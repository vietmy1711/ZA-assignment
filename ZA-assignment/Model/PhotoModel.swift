//
//  PhotoModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 17/04/2022.
//

import Foundation

class PhotoModel: Codable {
    let id: String
    let urls: URLModel
    let user: UserModel
    let isLiked: Bool
    
    init(id: String, urls: URLModel, user: UserModel, isLiked: Bool) {
        self.id = id
        self.urls = urls
        self.user = user
        self.isLiked = isLiked
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case isLiked = "liked_by_user"
    }
    
    func copy(with isLiked: Bool) -> PhotoModel {
        let copy = PhotoModel(id: id, urls: urls, user: user, isLiked: isLiked)
        return copy
    }
}
