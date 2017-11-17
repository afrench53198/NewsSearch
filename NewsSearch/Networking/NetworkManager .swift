//
//  NetworkManager .swift
//  NewsSearch
//
//  Created by Adam B French on 10/17/17.
//  Copyright © 2017 Adam B French. All rights reserved.
//

import UIKit

protocol NewsNetworker {
    func getSourcesFromNetwork(callback: @escaping ([NewsSource]) -> () )
    func getArticlesForSource(with source: NewsSource, callback: @escaping ([NewsArticle]) -> ())
}

class NetworkManager: NewsNetworker {
    
    
    var currentSession: URLSession?
    init() {
    }
    

    private func makeUrlForSources() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsAPI.sources.scheme
        urlComponents.host = NewsAPI.sources.host
        urlComponents.path = NewsAPI.sources.path
        let queryItem = URLQueryItem(name: "language", value: "en")
        urlComponents.queryItems = [queryItem]
        guard let url = urlComponents.url else {print("faultyUrl"); return nil}
        return url
    }
    /// This function creates a url using the NewsAPI enum. This url is used to make a request to NewsAPi.org to retrieve articles for a given source
    private func makeUrlForArticles(with source: NewsSource, sortedBy: NewsAPI.SortBy?) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsAPI.articles.scheme
        urlComponents.host = NewsAPI.articles.host
        urlComponents.path = NewsAPI.articles.path
    
        let sourceQueryItem = URLQueryItem(name: "source", value: source.id)
        let apiKeyQueryitem = NewsAPI.articles.key
        var queryItems: [URLQueryItem] = [sourceQueryItem,apiKeyQueryitem]
        urlComponents.queryItems = queryItems
        
        guard let sortByQuery = sortedBy else {return urlComponents.url}
        queryItems.append(sortByQuery.query)
        
        guard let url = urlComponents.url else {print("url for articles is invalid "); return nil}
       
        return url
    }
    
    func getSourcesFromNetwork(callback: @escaping ([NewsSource]) -> ())  {
        if let current = currentSession {
            current.finishTasksAndInvalidate()
        }
        guard let url = makeUrlForSources() else {print("Made Faulty URL for sources data task"); return}
        let session = URLSession(configuration: .default)
        currentSession = session
        let request = URLRequest(url: url)
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

    func getArticlesForSource(with source: NewsSource, callback: @escaping ([NewsArticle]) -> ()) {
        if let current = currentSession {
            current.finishTasksAndInvalidate()
        }
        guard let url = makeUrlForArticles(with: source, sortedBy: nil) else {print("Made Faulty Url for articles data task"); return}
        print(url)
        let session = URLSession(configuration: .default)
        currentSession = session
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error in session:\(error.localizedDescription)")
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                   
                    let articleResponse = try decoder.decode(ArticleResponse.self, from: data)
                    let articles = articleResponse.articles
                    DispatchQueue.main.async {
                            callback(articles)
                    }
                
                } catch {
                    print("Decoding Error: \(error)")
                }
            }
        }
        task.resume()
        }
    }





    


