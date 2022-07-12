//
//  WebServiceManager.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation

enum HttpMethod: String, Codable {
    case get = "GET"
    case post = "POST"
}

struct Resource<T> {
    let url: URL
    let method: HttpMethod
    let body: Data?
    let parse: (Data) -> T?
}

final class WebServiceManager: NSObject {
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    static let webServiceHelper = WebServiceManager()
    private var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        config.timeoutIntervalForResource = TimeInterval(timeOutInterval)
        return URLSession(configuration: config)
    }
    private let timeOutInterval: Double = Configurations.API.REQUEST_TIMEOUT
    private var task: URLSessionTask?
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: User-defined Methods
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    private override init() {}
    
    func stopTask() {
        if task?.state == .running {
            task?.cancel()
        }
    }
    
    // A method to handle multiple web-service calls
    func fetchData<T>(resource: Resource<T>,
                      completionHandler: @escaping (_ status: Bool, _ error: String?, _ object: T?) -> Void) {
        
        if task?.state == .running {
            task?.cancel()
        }
        
        var request = URLRequest(url: resource.url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [Configurations.RequestHeaderKey.ContentType_Key: Configurations.RequestHeaderKey.ContentType_Value,
                                       Configurations.RequestHeaderKey.Cache_Control_Key : Configurations.RequestHeaderKey.Cache_Control_Value]
        
        task = urlSession.dataTask(with: request) { (data, response, error) in
            let httpresponse = response as? HTTPURLResponse
            if httpresponse?.statusCode == 200,
               let respondata = data {
                #if DEBUG
                    let string = String(data: respondata, encoding: .utf8)
                    print(string as Any)
                #endif
                completionHandler(true, nil, resource.parse(respondata))
            } else {
                if let errr = error {
                    completionHandler(false, errr.localizedDescription, nil)
                } else if let statuscode = httpresponse?.statusCode {
                    let message = HTTPURLResponse.localizedString(forStatusCode: statuscode)
                    completionHandler(false, message, nil)
                } else {
                    completionHandler(false, "api_something_went_wrong".localised(), nil)
                }
            }
        }
        task?.resume()
    }
}

// MARK: - ================================
// MARK: URLSession Delegate Methods
// MARK: ================================

extension WebServiceManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
}
