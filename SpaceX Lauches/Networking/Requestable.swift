//
//  Requestable.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

public protocol Requestable: Encodable {
    static var method: HTTPMethods { get }
    static var path: String { get }
    static var requestType: RequestType { get }
    associatedtype ResponseType: Decodable
}

extension Requestable {
    public static var method: HTTPMethods {
        return .post
    }
    public static var requestType: RequestType {
        switch method {
        case .post:
            return .jsonBody(Data())
        case .get:
            return .urlQuery(["":""])
        default:
            return .httpHeader(["":""])
        }
    }
    
}

public struct HTTPMethods: RawRepresentable, Equatable, Hashable {
    public let rawValue: String
    public var description: String { return rawValue }
    public var debugDescription: String {
        return "HTTP Method: \(rawValue)"
    }
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(_ description: String) {
        rawValue = description.uppercased()
    }
    public static let get = HTTPMethods(rawValue: "GET")
    public static let post = HTTPMethods(rawValue: "POST")
    public static let put = HTTPMethods(rawValue: "PUT")
    public static let delete = HTTPMethods(rawValue: "DELETE")
    public static let head = HTTPMethods(rawValue: "HEAD")
    public static let patch = HTTPMethods(rawValue: "PATCH")
}

public enum RequestType {
    case httpHeader([String: String])
    case jsonBody(Data)
    case multipartFormData(Data, boundary: String)
    case urlQuery([String: Any])
}

