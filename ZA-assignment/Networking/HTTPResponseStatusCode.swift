//
//  HTTPResponseStatusCode.swift
//  ZA-assignment
//
//  Created by VinBrain on 14/04/2022.
//

enum HTTPResponseStatusCode: Int {
    case noInternet                     = -1
    case unknown                        = 0
    case ok                             = 200
    case badRequest                     = 400
    case notFound                       = 404
}
