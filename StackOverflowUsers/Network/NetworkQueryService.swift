//
//  NetworkQueryService.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 21/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

class NetworkQueryService {
    
    typealias NetworkServiceResult = (Data?, Error?) -> Void
    
    private let defaultUrlSession = URLSession(configuration: .default)
    
    private var urlSessionDataTask: URLSessionDataTask?
    
    func performNetworkQuery(withBaseUrlString baseUrl :String, andQueryString query :String, completion :@escaping NetworkServiceResult) {

        urlSessionDataTask?.cancel()
      
      if var urlComponents = URLComponents(string: baseUrl) {
      urlComponents.query = query
        
        guard let url = urlComponents.url else {
          return
        }
      
        urlSessionDataTask = defaultUrlSession.dataTask(with: url) { [weak self] data, response, error in
          defer {
            self?.urlSessionDataTask = nil
          }
          
            if let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
                        
            DispatchQueue.main.async {
              completion(data, error)
            }
          }
        }
        
        urlSessionDataTask?.resume()
      }
    }
    
    
    
    
}
