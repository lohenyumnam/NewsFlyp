//
//  NetworkController.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

extension URL {
    func withQueries(_ parameter: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameter.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        
        return components?.url
    }
}


class NetworkController {
    
    /// Setting of Network URLSession
    lazy var session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        //        if #available(iOS 11.0, *) {
        //            config.waitsForConnectivity = true
        //        }
        config.allowsCellularAccess = true
        
        // Setting up URL session using the above configuration
        let session = URLSession(configuration: config)
        return session
    }()
    
    static let shared = NetworkController()
    private init(){}
}



// //MARK: - Home Feed
extension NetworkController {
    
    func fetchHomeFeed(withPage page: Int, completion: @escaping (_ feed: [Feed]?, _ status: FetchResultStatus) -> Void){
        // Shows network Activity Indicator on statusbar
        //self.statusActivity = true
        
        // Setting up URL request
        guard let baseUrl = URL(string: ApiURL.homeFeed.rawValue) else { print("Invalid base URL"); return}
        
        let query: [String: String] = [
            "user" : "1172186799481825", //user ID
            "type" : "news", //type of news
            "q" : "0,18,12,10,8,6,4,1", //categories
            //"page" : "1", //page number
            "page" : "\(page)", //page number
            "p" : "" //search perameters
        ]
        
        guard let url = baseUrl.withQueries(query) else { print("Invalid  URL with query"); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // JSON Decoder to Decode the JSON data that will be fetch by this methode
        let jsonDecoder = JSONDecoder()
        
        //        // Setting up URL Configuration
        //        let config = URLSessionConfiguration.default
        //        if #available(iOS 11.0, *) {
        //            config.waitsForConnectivity = true
        //        }
        //        config.allowsCellularAccess = true
        //
        //        // Setting up URL session using the above configuration
        //        let session = URLSession(configuration: config)
        
        // dataTask
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                if error.code == NSURLErrorNotConnectedToInternet {
                    return
                }
            }
            guard let data = data else {
                    print("No data or statusCode not OK")
                    completion(nil, FetchResultStatus.noInternetOrServerError)
                    
                    return
            }
            
            
//            guard let data = data,
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 200 else {
//                    print("No data or statusCode not OK")
//                    completion(nil, FetchResultStatus.noInternetOrServerError)
//
//                    return
//            }
            
            let jsonData = try? jsonDecoder.decode(DataFeed.self, from: data)
            
            if let jsonData = jsonData {
                completion(jsonData.feed, FetchResultStatus.success)
            } else {
                print("No data for the current page")
                completion(nil, FetchResultStatus.fail)
            }
        }
        task.resume()
    }
    
    func fetchFeed(withID id: String, completion: @escaping (_ feed: [Feed]?, _ status: FetchResultStatus) -> Void){
        // Shows network Activity Indicator on statusbar
        //self.statusActivity = true
        
        // Setting up URL request
        guard let baseUrl = URL(string: ApiURL.getFeedByID.rawValue) else { print("Invalid base URL"); return}
        
        let query: [String: String] = [
            "id" : "\(id)", //News ID
        ]
        
        guard let url = baseUrl.withQueries(query) else { print("Invalid  URL with query"); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // JSON Decoder to Decode the JSON data that will be fetch by this methode
        let jsonDecoder = JSONDecoder()
        
        //        // Setting up URL Configuration
        //        let config = URLSessionConfiguration.default
        //        if #available(iOS 11.0, *) {
        //            config.waitsForConnectivity = true
        //        }
        //        config.allowsCellularAccess = true
        //
        //        // Setting up URL session using the above configuration
        //        let session = URLSession(configuration: config)
        
        // dataTask
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                if error.code == NSURLErrorNotConnectedToInternet {
                    return
                }
            }
//            guard let data = data else {
//                print("No data or statusCode not OK")
//                completion(nil, FetchResultStatus.noInternetOrServerError)
//
//                return
//            }
            
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print("No data or statusCode not OK")
                    completion(nil, FetchResultStatus.noInternetOrServerError)
                    
                    return
            }
            
            let jsonData = try? jsonDecoder.decode(DataFeed.self, from: data)
            if let jsonData = jsonData {
                completion(jsonData.feed, FetchResultStatus.success)
            } else {
                print("No data for the current page")
                completion(nil, FetchResultStatus.fail)
            }
        }
        task.resume()
    }
}


//MARK: - Video Feed
extension NetworkController {
    func fetchVideoFeed(withPage page: Int, completion: @escaping (_ feed: [Feed]?, _ status: FetchResultStatus) -> Void){
        // Shows network Activity Indicator on statusbar
        //self.statusActivity = true
        
        // Setting up URL request
        guard let baseUrl = URL(string: ApiURL.homeFeed.rawValue) else { print("Invalid base URL"); return}
        
        let query: [String: String] = [
            "user" : "1172186799481825", //user ID
            "type" : "vid", //type of news
            "q" : "0,18,12,10,8,6,4,1", //categories
            //"page" : "1", //page number
            "page" : "\(page)", //page number
            "p" : "" //search perameters
        ]
        
        guard let url = baseUrl.withQueries(query) else { print("Invalid  URL with query"); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // JSON Decoder to Decode the JSON data that will be fetch by this methode
        let jsonDecoder = JSONDecoder()
        
        //        // Setting up URL Configuration
        //        let config = URLSessionConfiguration.default
        //        if #available(iOS 11.0, *) {
        //            config.waitsForConnectivity = true
        //        }
        //        config.allowsCellularAccess = true
        //
        //        // Setting up URL session using the above configuration
        //        let session = URLSession(configuration: config)
        
        // dataTask
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                if error.code == NSURLErrorNotConnectedToInternet {
                    return
                }
            }
            guard let data = data else {
                print("No data or statusCode not OK")
                completion(nil, FetchResultStatus.noInternetOrServerError)
                
                return
            }
            
            
            //            guard let data = data,
            //                let response = response as? HTTPURLResponse,
            //                response.statusCode == 200 else {
            //                    print("No data or statusCode not OK")
            //                    completion(nil, FetchResultStatus.noInternetOrServerError)
            //
            //                    return
            //            }
            
            let jsonData = try? jsonDecoder.decode(DataFeed.self, from: data)
            
            if let jsonData = jsonData {
                completion(jsonData.feed, FetchResultStatus.success)
            } else {
                print("No data for the current page")
                completion(nil, FetchResultStatus.fail)
            }
        }
        task.resume()
    }
}



