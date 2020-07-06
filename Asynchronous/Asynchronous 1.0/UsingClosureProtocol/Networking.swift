//
//  Networking.swift
//  WhytPlot
//
//  Created by Exlinct on 5/21/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import UIKit

// Here are some convenience functions for dealing with JSON APIs
public typealias JSONDictionary = [String: AnyObject]

public typealias FailureHandler = (reason: Reason, errorMessage: String?) -> Void

private let SuccessStatusCodeRange: Range<Int> = 200..<300

let defaultFailureHandler: FailureHandler = { reason, errorMessage in
    print("\n***************************** Networking Failure *****************************")
    print("Reason: \(reason)")
    if let errorMessage = errorMessage {
        print("errorMessage: >>>\(errorMessage)<<<\n")
    }
}

var NetworkActivityCount = 0 {
didSet {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = (NetworkActivityCount > 0)
}
}

public enum Method: String, CustomStringConvertible {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    
    public var description: String {
        return self.rawValue
    }
}

public struct Resource<A>: CustomStringConvertible {
    let path: String
    let method: Method
    let requestBody: NSData?
    let headers: [String:String]
    let parse: NSData -> A?
    
    public var description: String {
        let decodeRequestBody: [String: AnyObject]
        if let requestBody = requestBody {
            decodeRequestBody = decodeJSON(requestBody)!
        } else {
            decodeRequestBody = [:]
        }
        
        return "Resource(Method: \(method), path: \(path), headers: \(headers), requestBody: \(decodeRequestBody))"
    }
}

public enum ErrorCode: String {
    case BlockedByRecipient = "rejected_your_message"
}

public enum Reason: CustomStringConvertible {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int, errorCode: ErrorCode?)
    case Other(NSError?)
    
    public var description: String {
        switch self {
        case .CouldNotParseJSON:
            return "CouldNotParseJSON"
        case .NoData:
            return "NoData"
        case .NoSuccessStatusCode(let statusCode):
            return "NoSuccessStatusCode: \(statusCode)"
        case .Other(let error):
            return "Other, Error: \(error?.description)"
        }
    }
}

public func apiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: Resource<A>?, failure: FailureHandler?, completion: A -> Void) {
    
    guard let resource = resource else {
        failure?(reason: .Other(nil), errorMessage: "No resource")
        return
    }
    
    let session = NSURLSession.sharedSession()
    let url = baseURL.URLByAppendingPathComponent(resource.path)
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = resource.method.rawValue
    
    func needEncodesParametersForMethod(method: Method) -> Bool {
        switch method {
        case .GET, .HEAD, .DELETE:
            return true
        default:
            return false
        }
    }
    
    func query(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value: value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
    }
    
    func handleParameters() {
        if needEncodesParametersForMethod(resource.method) {
            guard let URL = request.URL else {
                print("Invalid URL of request: \(request)")
                return
            }
            
            if let requestBody = resource.requestBody {
                if let URLComponents = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) {
                    URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + query(decodeJSON(requestBody)!)
                    request.URL = URLComponents.URL
                }
            }
            
        } else {
            request.HTTPBody = resource.requestBody
        }
    }
    
    handleParameters()
    
    modifyRequest(request)
    
    for (key, value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    let _failure: FailureHandler
    
    if let failure = failure {
        _failure = failure
    } else {
        _failure = defaultFailureHandler
    }
    
    let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
        
        if let httpResponse = response as? NSHTTPURLResponse {
            
            if SuccessStatusCodeRange.contains(httpResponse.statusCode) {
                
                if let responseData = data {
                    
                    if let result = resource.parse(responseData) {
                        completion(result)
                        
                    } else {
                        let dataString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                        print(dataString)
                        
                        _failure(reason: .CouldNotParseJSON, errorMessage: errorMessageInData(data))
                        print("\(resource)\n")
                        print(request.cURLCommandLine)
                    }
                    
                } else {
                    _failure(reason: .NoData, errorMessage: errorMessageInData(data))
                    print("\(resource)\n")
                    print(request.cURLCommandLine)
                }
                
            } else {
                let errorCode = errorCodeInData(data)
                _failure(reason: .NoSuccessStatusCode(statusCode: httpResponse.statusCode, errorCode: errorCode), errorMessage: errorMessageInData(data))
                print("\(resource)\n")
                print(request.cURLCommandLine)
            }
            
        } else {
            _failure(reason: .Other(error), errorMessage: errorMessageInData(data))
            print("\(resource)")
            print(request.cURLCommandLine)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            NetworkActivityCount -= 1
        }
    }
    
    task.resume()
    
    dispatch_async(dispatch_get_main_queue()) {
        NetworkActivityCount += 1
    }
}

func queryComponents(key: String, value: AnyObject) -> [(String, String)] {
    
    func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
        return string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
    }
    
    var components: [(String, String)] = []
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value: value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value: value)
        }
    } else {
        components.appendContentsOf([(escape(key), escape("\(value)"))])
    }
    
    return components
}

func errorMessageInData(data: NSData?) -> String? {
    if let data = data {
        if let json = decodeJSON(data) {
            if let errorMessage = json["error"] as? String {
                return errorMessage
            }
        }
    }
    
    return nil
}

func errorCodeInData(data: NSData?) -> ErrorCode? {
    if let data = data {
        if let json = decodeJSON(data) {
            print("error json: \(json)")
            if let errorCodeString = json["code"] as? String {
                return ErrorCode(rawValue: errorCodeString)
            }
        }
    }
    
    return nil
}

func decodeJSON(data: NSData) -> JSONDictionary? {
    
    if data.length > 0 {
        guard let result = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) else {
            return JSONDictionary()
        }
        
        if let dictionary = result as? JSONDictionary {
            return dictionary
        } else if let array = result as? [JSONDictionary] {
            return ["data": array]
        } else {
            return JSONDictionary()
        }
        
    } else {
        return JSONDictionary()
    }
}

func encodeJSON(dict: JSONDictionary) -> NSData? {
    return dict.count > 0 ? (try? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions())) : nil
}

public func jsonResource<A>(path path: String, method: Method, requestParameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A> {
    return jsonResource(token: nil, path: path, method: method, requestParameters: requestParameters, parse: parse)
}

public func authJsonResource<A>(path path: String, method: Method, requestParameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A>? {
    return jsonResource(token: "", path: path, method: method, requestParameters: requestParameters, parse: parse)
}

public func jsonResource<A>(token token: String?, path: String, method: Method, requestParameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A> {
    
    let jsonParse: NSData -> A? = { data in
        if let json = decodeJSON(data) {
            return parse(json)
        }
        return nil
    }
    
    let jsonBody = encodeJSON(requestParameters)
    var headers = [
        "Content-Type": "application/json",
        ]
    if let token = token {
        headers["Authorization"] = token
    }
    
    let locale = NSLocale.autoupdatingCurrentLocale()
    if let
        languageCode = locale.objectForKey(NSLocaleLanguageCode) as? String,
        countryCode = locale.objectForKey(NSLocaleCountryCode) as? String {
        headers["Accept-Language"] = languageCode + "-" + countryCode
    }
    
    return Resource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: jsonParse)
}

