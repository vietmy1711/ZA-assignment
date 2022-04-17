//
//  PhotoRepository.swift
//  ZA-assignment
//
//  Created by VinBrain on 17/04/2022.
//

import Foundation

class PhotoRepository: NSObject {
    
    static let shared = PhotoRepository()
    
    // MARK: - Get Photos by [popular]
    
    func getPhotos(page: Int, perPage: Int, orderBy: String, completionHandler: @escaping (Array<PhotoModel>?, ErrorType?)->Void) {
        let params = [
            "page" : String(describing: page),
            "per_page": String(describing: perPage),
            "order_by": orderBy,
        ]
        ApiRequest.shared.request(path: "photos", method: .GET, queryParams: params) { data, errType, err in
            guard let data = data else {
                completionHandler(nil, errType)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let photoModels = try jsonDecoder.decode([PhotoModel].self, from: data)
                completionHandler(photoModels, errType)
            } catch let parsingError {
                print("Error: \(parsingError)")
                completionHandler(nil, errType)
            }
        }
    }
    
    // MARK: - Like photo by [id]
    
    func likePhoto(id: String, like: Bool, completionHandler: @escaping (PhotoModel?, ErrorType?) -> Void) {
        ApiRequest.shared.request(path: "photos/\(id)/like", method: like ? .POST : .DELETE, queryParams: [:]) { data, errType, err in
            guard let data = data else {
                completionHandler(nil, errType)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let photoModels = try jsonDecoder.decode(PhotoModel.self, from: data)
                completionHandler(photoModels, errType)
            } catch let parsingError {
                print("Error: \(parsingError)")
                completionHandler(nil, errType)
            }
        }
    }
}
