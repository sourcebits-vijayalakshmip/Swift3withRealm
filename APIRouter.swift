
//
//  APIRouter.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 10/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import Foundation

import Alamofire

public typealias JSONDictionary = [String : Any]
public typealias APIParameters = [String : Any]?


/// Base URLs for the Amakkn API.
public struct BaseURLConfiguration {

    /// The API base URL.
    public static let host = "omgvamp-hearthstone-v1.p.mashape.com"
    public static let baseURL = "https://omgvamp-hearthstone-v1.p.mashape.com"

}


/// Enumeration of all the available API endpoints.

enum Endpoint {
    
    case getcards()

}


/// Protocol for being able to create an API call.

protocol APIConfigurable {
    var method: Alamofire.HTTPMethod { get }
    var headers: Alamofire.HTTPHeaders { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var path: String { get }
    var parameters: APIParameters { get }
    var baseURL: String { get }
    
}


class BaseRouter: URLRequestConvertible, APIConfigurable {
    
    init() {
        
    }
    
    var method: Alamofire.HTTPMethod {
        fatalError("[\(Mirror(reflecting: self).description) - \(#function))] Must be overridden in subclass")
    }
    
     var headers: Alamofire.HTTPHeaders {
        fatalError("[\(Mirror(reflecting: self).description) - \(#function))] Must be overridden in subclass")
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        fatalError("[\(Mirror(reflecting: self).description) - \(#function))] Must be overridden in subclass")
    }
    
    var path: String {
        fatalError("[\(Mirror(reflecting: self).description) - \(#function))] Must be overridden in subclass")
    }
    
    var parameters: APIParameters {
        fatalError("[\(Mirror(reflecting: self).description) - \(#function))] Must be overridden in subclass")
    }
    
    var baseURL: String {
        return BaseURLConfiguration.baseURL
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let baseURL = try self.baseURL.asURL()
        let endpoint = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: endpoint)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
       // urlRequest.addValue("xd90O4gfMdmshyLxk5cBvl44PPHlp1ONA3kjsnFFOAtbQnoshp", forHTTPHeaderField: "")
        
       if let encoding = encoding {
            
            if let extendedParameters = parameters {
                
                let request = try encoding.encode(urlRequest, with: extendedParameters)
                return request
                
            } else {
                let request = try encoding.encode(urlRequest, with: parameters)
                return request
            }
        }
        
        return urlRequest
    }
    
}


/**
 This is a class used for representing an API endpoint call. It is initialised using an Endpoint and all it's required paramters.
 URLRequestConvertible copliance then allows it to be used by the Alamofire.
 
 */
class APIRouter: BaseRouter {
    
    var endpoint: Endpoint
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.HTTPMethod {
        
        switch endpoint {
            
        case .getcards(): return .get
        
        }
    }
    
    override  var headers: Alamofire.HTTPHeaders {
        
        switch endpoint {
            
        case .getcards():
            let headers: HTTPHeaders = ["X-Mashape-Key": "xd90O4gfMdmshyLxk5cBvl44PPHlp1ONA3kjsnFFOAtbQnoshp",
                                        "Content-type": "application/json"]
            
            return headers
        }
    }
    
    
    override var path: String {
        
        switch endpoint {
            
        case .getcards(): return "info"

        }
    }
    
    override var parameters: APIParameters {
        
        switch endpoint {
            
        case .getcards():
        
            return nil
        }
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        
        switch endpoint {
            
        case .getcards(): return JSONEncoding.default
            
        }
    }
    
    }

