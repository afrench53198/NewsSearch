//
//  NetworkManager .swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

protocol Networker {
    func makeUrl() -> URL?
    func getSourcesFromNetwork(callback: @escaping ([NewsSource]) -> () )
}

class SourcesNetworkManager: Networker {
   
    
    init() {
    }
  
    internal func makeUrl() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v1/sources"
        let queryItem = URLQueryItem(name: "language", value: "en")
        urlComponents.queryItems = [queryItem]
        guard let url = urlComponents.url else {print("faultyUrl"); return nil}
        return url
    }
    private func makeUrlWithCategories(categories:[SourceCategory]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v1/sources"
        var queryItems: [URLQueryItem] = []
        for category in categories {
            let queryItem = URLQueryItem(name: "category", value: category.rawValue)
            queryItems.append(queryItem)
        }
         urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {print("faulty URL: \(String(describing: urlComponents.url))"); return nil}
        return url
    }
   
    func getSourcesFromNetwork(callback: @escaping ([NewsSource]) -> ())  {
       
        guard let url = makeUrl() else {print("Made Faulty URL"); return}
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
  
          let task = session.dataTask(with: request) { (data, response, error) in
            
                if let error = error {
                    print("error in session:\(error.localizedDescription)")
                }
                if let data = data {
                   let decoder = JSONDecoder()
                    do {
                        let sourceResponse = try decoder.decode(SourceResponse.self, from: data)
                        let sources = sourceResponse.sources
                        callback(sources)
                    } catch {
                        print("Decoding Error: \(error)")
                    }
            }
    }
   task.resume()
  }
    func getSourcesWithCategories(categories:[SourceCategory], callback: @escaping ([NewsSource]) -> ()) {
        
            if let url = makeUrlWithCategories(categories: categories) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        if let error = error {
                            print(error)
                        }
                        if let theData = data {
                            do {
                                let sourceResponse = try JSONDecoder().decode(SourceResponse.self, from: theData)
                                let sources = sourceResponse.sources
                                callback(sources)
                            } catch {
                                print("Decoder Error: \(error)")
                            }
                        }
                    })
                task.resume()
        }
    }
}
