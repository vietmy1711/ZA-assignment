//
//  ErrorModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

enum ErrorType {
    case fetchingNoInternet
    case fetchingUnknown
    
    var errorTitle: String? {
        switch self {
        default:
            return "Request Failed"
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .fetchingNoInternet:
            return "No internet connection. Please connect and try again"
        case .fetchingUnknown:
            return "Something went wrong. Please try again"
        }
    }
}
