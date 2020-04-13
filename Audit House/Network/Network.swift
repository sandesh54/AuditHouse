//
//  Network.swift
//  TargetModule
//
//  Created by Sandesh on 28/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import Reachability

struct Network {
    
    enum NetworkErrors: Error {
        case NoConnectivity
        case NotFound
        case InvalidURL
    }
    
   
    
    enum EndPoints: String {
        case addDevice = "addDevice"
        case checkDevice = "checkDevice"
        case getInfo = "getInfo"
        case getReminders = "getReminders"
        case getNotifications = "getNotifications"
        case readInfo = "readInfo"
        case readCount = "readCount"
        case offlineData = "offlineData"
        case crashReport = "crashReport"
    }
    
    private static let BASE_URL = "http://support.theskygge.com/audithouse/public/rest/"
    //private static let BASE_URL = "http://www.audithouse.in/rest/"
    
    static func request( _ endpoint: EndPoints,parameters: [String: String],_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
       
        
        guard let url = URL(string: BASE_URL+endpoint.rawValue) else {
//            throw NetworkErrors.InvalidURL
            fatalError("Invalid URL")
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(parameters) else {
            fatalError("Cannot encode \(parameters)")
        }
        
        request.httpBody = data
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
        }.resume()
    }
}



