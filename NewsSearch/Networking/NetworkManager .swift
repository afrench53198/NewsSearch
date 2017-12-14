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
    func getArticles(with sources: [NewsSource]?, callback: @escaping ([NewsArticle]) -> ())
}

class NetworkManager: NewsNetworker {
    // TODO: - Migrate to V2 and update features as necessary
    var currentSession: URLSession?
    init() {
    }
    private var key: URLQueryItem? 
    
    private func makeUrlForSources() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsAPI.sources.scheme
        urlComponents.host = NewsAPI.sources.host
        urlComponents.path = NewsAPI.sources.path
        let queryItem = URLQueryItem(name: "language", value: "en")
        guard let key = AppDelegate().key else {return nil}
        let keyQuery = URLQueryItem(name: "apiKey", value: key)
        urlComponents.queryItems = [queryItem,keyQuery]
        guard let url = urlComponents.url else {print("faultyUrl"); return nil}
        return url
    }
    /// This function creates a url using the NewsAPI enum. Returns top headlines if no source parameter specified
    private func makeUrlForArticles(with sources: [NewsSource]?, query: String?) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsAPI.articles.scheme
        urlComponents.host = NewsAPI.articles.host
        urlComponents.path = NewsAPI.articles.path
       
        guard let key = AppDelegate().key else {return nil}
        let languageQuery = URLQueryItem(name: "language", value: "en")
        let keyQuery = URLQueryItem(name: "apiKey", value: key)
        var queryItems = [keyQuery,languageQuery]
       // Check for source and if nil return url with simple query
        guard let theSources = sources else {
           urlComponents.queryItems = queryItems
            if let returnUrl = urlComponents.url {
                return returnUrl
            } else {
                return nil
            }
          }
      
        for source in theSources {
             let sourceQueryItem = URLQueryItem(name: "sources", value: source.id)
               queryItems.append(sourceQueryItem)
        }
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil}
       // print(url)
        return url
    }
    
    func getSourcesFromNetwork(callback: @escaping ([NewsSource]) -> ())  {
        if let current = currentSession {
            current.finishTasksAndInvalidate()
        }
        guard let url = makeUrlForSources() else { return}
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
                   
                    DispatchQueue.main.async {
                            callback(sources)
                    }
                
                } catch {
                    print("Decoding Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getArticles(with sources: [NewsSource]?, callback: @escaping ([NewsArticle]) -> ()) {
        if let current = currentSession {
            current.finishTasksAndInvalidate()
        }
        guard let url = makeUrlForArticles(with: sources, query:nil) else { return}
    
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
                    print(articleResponse.status)
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

    func getArticlesWithQuery(query: String, callback: @escaping ([NewsArticle]) -> ()) {
        
    }



}








