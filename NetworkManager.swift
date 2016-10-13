//
//  NetworkManager.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 10/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import Foundation

import Alamofire
import RealmSwift
import ObjectMapper


/// API error related constants

public enum APIErrorConstants {
    static let domain = "com.amakkn.errorDomain"
}


/// Enum wrapping all errors in an Error type specific to your app

enum BackendError: Error {
    case network(error: Error)                  // Capture any underlying Error from the URLSession API
    case dataSerialization(reason: String)
    case jsonSerialization(error: Error)
    case serverApplication(error: NSError)
    case realm(error: NSError)
    case objectSerialization(reason: String)
    case sessionValidation(reason: String)
    
    func logDescription() -> String {
        
        var targetDescription: String
        
        switch self {
            
        case .sessionValidation(let reason):
            targetDescription = "BackendError.sessionValidation: \(reason)"
        case .objectSerialization(let reason):
            targetDescription = "BackendError.objectSerialization: \(reason)"
        case .network(let underlyingError as AFError):
            targetDescription = "BackendError.network AF: \(underlyingError.errorDescription)"
        case .network(let underlyingError):
            targetDescription = "BackendError.network: \(underlyingError.localizedDescription)"
        case .jsonSerialization(let underlyingError):
            targetDescription = "BackendError.jsonSerialization: \(underlyingError.localizedDescription)"
        case.serverApplication(let underlyingError):
            targetDescription = "BackendError.serverApplication - \(underlyingError.code): \(underlyingError.localizedDescription)"
        case .dataSerialization(let reason):
            targetDescription = "BackendError.dataSerialization: \(reason)"
        case .realm(let error):
            targetDescription = "Realm: \(error.description)"
        }
        
        return targetDescription
    }
}


/// Singleton class for making API calls

class NetworkManager {
    
    static let shared = NetworkManager()
    
    static let serverTrustPolicies: [String: ServerTrustPolicy] = [
        BaseURLConfiguration.host: .disableEvaluation,
        ]
    
    var internalManager: SessionManager!
    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    
    fileprivate init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        // Init the Alamofire manager
        internalManager = SessionManager(configuration: configuration,
                                         serverTrustPolicyManager: ServerTrustPolicyManager(policies: NetworkManager.serverTrustPolicies))
    }
}



// MARK: - Validation Methods

extension NetworkManager {
    
    func validate(response urlResponse: HTTPURLResponse, data: Data?) -> Request.ValidationResult {
        
       if 200 ... 299 ~= urlResponse.statusCode {
            // Check if the application server response is valid
            if let data = data {
                
                do {
                    if  var responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONDictionary,
                        let codeArray = responseDictionary["factions"] as? NSArray {
                        debugPrint("response: \(codeArray)")
                        if codeArray != [ ] {
                            return .success
                        } else {
                            // Parse the application error code
                            let userInfo = [
                                NSLocalizedDescriptionKey: NSLocalizedString("Failed", value: "", comment: ""),
                                ] as [String : Any]
                            
                            return .failure(BackendError.serverApplication(error: NSError(domain: APIErrorConstants.domain, code:0, userInfo: userInfo)))
                        }
                    } else {
                        return .failure(BackendError.objectSerialization(reason: "Unexpected response format"))
                    }
                    
                } catch let error {
                    return .failure(BackendError.jsonSerialization(error: error))
                }
            } else {
                return .failure(BackendError.dataSerialization(reason: "Missing response data"))
            }
            
        }
    else {
            return .failure(BackendError.network(error: NSError(domain: APIErrorConstants.domain, code: urlResponse.statusCode, userInfo: nil)))
        }
  
}
}

// MARK: - Authentication Methods

extension NetworkManager {
    
    func retrieveCards(completion: @escaping (BackendError?) -> ()) {
        
        let router = APIRouter(endpoint: .getcards())
        
        internalManager.request(router)
            .validate({ (request, response, data) -> Request.ValidationResult in
                return self.validate(response: response, data: data)
            })
            .responseJSON { (response) in
                
                switch response.result {
                    
                case .success:
                    
                    if let responseDict = response.result.value as? JSONDictionary,
                        let dataArray = responseDict["factions"] as? NSArray {
                        
                            debugPrint("Array response: \(dataArray)")
                            
                            DispatchQueue(label: "realmBackground").async {
                                
                                do {
                                    let realm = try Realm()
                                    
                                    if let card = Mapper<Cards>().mapArray(JSONArray: dataArray as! [[String : AnyObject]]) {
                                        
                                        debugPrint("card response: \(card)")

                                        //card.isMe = true
                                        
                                        debugPrint("card response: \(dataArray)")

                                        // Import the object
                                        try realm.write {
                                            // update the unique object if it is already in the store
                                            realm.add(card, update: true)
                                        }
                                        
                                        // Call the completion block
                                        DispatchQueue.main.async(execute: {
                                            completion(nil)
                                        })
                                    } else {
                                        // Parsing error
                                        DispatchQueue.main.async(execute: {
                                            completion(BackendError.objectSerialization(reason: "Invalid incoming User object"))
                                        })
                                    }
                                } catch let error as NSError {
                                    // handle error
                                    DispatchQueue.main.async(execute: {
                                        completion(BackendError.realm(error: error))
                                    })
                                }
                            }
                        
                    }
                    
                case .failure(let error as BackendError):
                    DispatchQueue.main.async(execute: {
                        completion(error)
                    })
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        completion(BackendError.network(error: error))
                    })
                }
        }
        
    }
    
    
    
    
}

