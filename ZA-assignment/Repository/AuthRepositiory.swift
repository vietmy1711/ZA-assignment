//
//  AuthRepositiory.swift
//  ZA-assignment
//
//  Created by VinBrain on 14/04/2022.
//

import Foundation
import AuthenticationServices

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

class URLScheme{
    public static let scheme: String = "mynguyen"
}

class AuthArguments{
    public static let redirectUri: String = "mynguyen://unsplash"
    public static let responseType: String = "code"
    public static let scope: String = "public+write_likes"
    public static let grandType: String = "authorization_code"
}

class AuthRepository: NSObject {
    
    static let shared = AuthRepository()
    
    public let domain: String = "\(ApiManager.shared.baseUrl)oauth/"
    
    var isLoggedIn: Bool {
        return !(ApiManager.shared.getAccessToken()?.isEmpty ?? true)
    }
    
    // MARK: - Private
    private var authSession: ASWebAuthenticationSession!
    private var isAuthorizing: Bool = false
    
    func authorize(completionHandler: @escaping (String)->Void) {
        let params = [
            URLQueryItem(name: "client_id", value: SavedKeys.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthArguments.redirectUri),
            URLQueryItem(name: "response_type", value: AuthArguments.responseType),
            URLQueryItem(name: "scope", value: AuthArguments.scope),
        ]
        
        var urlComponents = URLComponents(string: domain + "authorize")!
        urlComponents.queryItems = params
        // Cancel if authorizing
        if isAuthorizing { return }
            
        let authSession = ASWebAuthenticationSession(url: urlComponents.url!, callbackURLScheme: URLScheme.scheme){ [weak self](callbackURL, error) in
            self?.isAuthorizing = false
            guard error == nil, let callbackURL = callbackURL else { return }
            print("Logging: CallbackURL \(callbackURL)")
            guard let code = callbackURL.valueOf("code") else { return }
            print("Logging: Code \(code)")
            completionHandler(code)
        }
        if #available(iOS 13.0, *) {
            authSession.presentationContextProvider = self
        }
        
        
        
        authSession.prefersEphemeralWebBrowserSession = true
        authSession.start()
        isAuthorizing = true
    }
    
    func token(code: String, completionHandler: @escaping (Bool, ErrorType?)->Void) {
        let params = [
                    "client_id" : SavedKeys.accessKey,
                    "client_secret": SavedKeys.secretKey,
                    "redirect_uri": AuthArguments.redirectUri,
                    "code": code,
                    "grant_type": AuthArguments.grandType,
                ]
        ApiRequest.shared.request(path: "oauth/token", method: .POST, queryParams: params) { data, errType, err in
            guard let data = data else {
                completionHandler(false, errType)
                return
            }
           
            do {
                let jsonDecoder = JSONDecoder()
                let authModel = try jsonDecoder.decode(AuthModel.self, from: data)
                guard let accessToken = authModel.accessToken else {
                    completionHandler(false, errType)
                    return
                }
                ApiManager.shared.setAccessToken(accessToken)
                completionHandler(true, errType)
            } catch let parsingError {
                print("Error: \(parsingError)")
                completionHandler(false, errType)
            }
        }
    }
    
    func logOut() {
        ApiManager.shared.removeAccessToken()
    }
    
}
// MARK: - ASWebAuthenticationPresentationContextProviding
extension AuthRepository: ASWebAuthenticationPresentationContextProviding{
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
