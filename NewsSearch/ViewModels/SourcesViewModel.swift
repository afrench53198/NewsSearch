//
//  SourcesViewModel.swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//


import UIKit




class NewsSourceViewModel {
    
    var networker: Networker
    var sources: [NewsSource] = []
    

    init(with networker: Networker) {
        self.networker = networker
    }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }

    
    func provideData(callback: @escaping (Result<[NewsSource]>) -> ()) -> ()  {
       
        networker.session { (data) in
          
                  let decoder = JSONDecoder()
                do {
                    let sourceResponse = try decoder.decode(SourceResponse.self, from: data)
                    callback(.success(sourceResponse.sources))
                } catch {
                    callback(.failure(error))
            }
            }

        }
    }
    



