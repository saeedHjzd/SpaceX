//
//  HTTPService.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

typealias requestCompletion<T: Decodable> = (Result<T, NetworkingError>) -> Void

protocol NetworkingLayer {
    func request<R: Requestable>(_ requestObj: R, completion: @escaping requestCompletion<R.ResponseType>)
}

final class URLSessionNetworkingLayer: NetworkingLayer {
    //    public let baseURL: URL
    //    internal let jsonEncoder: JSONEncoder
    //    internal let decoder: JSONDecoder
    private var urlSession: URLSession!
    
    init() {
        //        self.baseURL = baseURL
        //        let encoder = JSONEncoder()
        //        encoder.outputFormatting = []
        //        encoder.dataEncodingStrategy = .base64
        //        encoder.dateEncodingStrategy = .custom({ date, dateCoder in
        //            var container = dateCoder.singleValueContainer()
        //            try container.encode(Int64(date.timeIntervalSince1970 * 1000))
        //        })
        //        self.jsonEncoder = encoder
        //        let decoder = JSONDecoder()
        //        decoder.dataDecodingStrategy = .base64
        //        decoder.dateDecodingStrategy = .millisecondsSince1970
        //        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
        //            positiveInfinity: "Infinity",
        //            negativeInfinity: "-Infinity",
        //            nan: "NaN")
        //        self.decoder = decoder
        initializeService()
    }
    func initializeService() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        config.networkServiceType = .responsiveData
        config.shouldUseExtendedBackgroundIdleMode = true
        self.urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    }
    
    
    private func handleRequest<R: Requestable>(_ requestObj: R) -> URLRequest {
        let baseURL = URL(string: Constants.baseURL)
        var request = URLRequest(url: URL(string: type(of: requestObj).path, relativeTo: baseURL)!)
        request.httpMethod = type(of: requestObj).method.rawValue

        switch type(of: requestObj).requestType {
        case .jsonBody(let bodyData):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData
        case .urlQuery(let parameters):
            let urlWithParams = addQueryParameters(to: request.url!, parameters: parameters)
            request.url = urlWithParams
        case .httpHeader(let headers):
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        case .multipartFormData(let bodyData, let boundary):
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData
        }

        return request
    }

    func addQueryParameters(to url: URL, parameters: [String: Any]) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
    
    func request<R>(_ requestObj: R, completion: @escaping requestCompletion<R.ResponseType>) where R : Requestable {
        
        let request = handleRequest(requestObj)
        
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
                let decodedResponse = try JSONDecoder().decode(R.ResponseType.self, from: responseData)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
        
    }
    
    
    
    
}
