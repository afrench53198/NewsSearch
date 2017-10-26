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
    func session(callback: @escaping (Data) throws -> ())
}

class SourcesNetworkManager: Networker {
   
    
    init() {
    }
  
    internal func makeUrl() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "https://newsapi.org/v1/"
        urlComponents.path = "/sources?"
        guard let url = urlComponents.url else {print("faultyUrl"); return nil}
        return url
    }
    
    func session(callback: @escaping (Data) throws -> ())  {
       
        let url = URL(string:"https://newsapi.org/v1/sources?language=en")
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: .default)
  
          let task = session.dataTask(with: request) { (data, response, error) in
            
                if let error = error {
                    print("error in session:\(error.localizedDescription)")
                }
                if let data = data {
                    do {
                        print(data)
                        try callback(data)
                    } catch {
                    print("no data")
                    }
            }
    }
   task.resume()
  }
}
