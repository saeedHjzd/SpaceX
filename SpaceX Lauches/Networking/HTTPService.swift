//
//  HTTPService.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation
import UIKit

typealias requestCompletion<T: Decodable> = (Result<T, NetworkingError>) -> Void

protocol NetworkingLayer {
    func request<T: Decodable>(path: String, method: HTTPMethod, requestType: RequestType, completion: @escaping requestCompletion<T>)
    func requestImage(fromURL url: URL, completion: @escaping (UIImage?) -> Void)
}

final class URLSessionNetworkingLayer: NetworkingLayer {
    private var urlSession: URLSession!
    private var imageCache = NSCache<NSString, UIImage>()
    
    init() {
        initializeService()
    }
    
    private func initializeService() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        config.networkServiceType = .responsiveData
        config.shouldUseExtendedBackgroundIdleMode = true
        self.urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    }
    
    
    private func handleRequest(path: String, method: HTTPMethod, requestType: RequestType) -> URLRequest {
        let baseURL = URL(string: Constants.baseURL)
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = method.rawValue
        
        switch requestType {
        case .httpHeader:
            // ...
            break
        case .jsonBody(let data):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        case .multipartFormData(let data, let boundary):
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        case .urlQuery(let parameters):
            let urlWithParams = addQueryParameters(to: request.url!, parameters: parameters)
            request.url = urlWithParams
        }
        
        return request
    }
    
    private func addQueryParameters(to url: URL, parameters: [String: Any]) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    func request<T>(path: String, method: HTTPMethod, requestType: RequestType, completion: @escaping (Result<T, NetworkingError>) -> Void) where T: Decodable{
        let request = handleRequest(path: path, method: method, requestType: requestType)
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.validationFailed("\(httpResponse.statusCode)")))
                return
            }
            guard let responseData = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
    
    func requestImage(fromURL url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url)
            
            urlSession.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(nil)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let imageData = data,
                      let image = UIImage(data: imageData)
                else {
                    completion(nil)
                    return
                }
                
                // Cache the downloaded image
                self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                // Return the downloaded image
                completion(image)
            }.resume()
        }
    }
    
    
    
}


enum RequestType {
    case httpHeader
    case jsonBody(Data)
    case multipartFormData(Data, boundary: String)
    case urlQuery([String: String])
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
