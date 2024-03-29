//
//  DataGetter.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation

class DataGetter {
    //setting constants
    enum HTTPError: Error {
        case non200StatusCode
        case noData
    }
    
    //retrieves data
    func fetchData(with request: URLRequest, requestID: String? = nil, completion: @escaping (String?, Data?, Error?) -> Void) {
        
        //data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //error handling
            if let error = error {
                print(error)
                completion(requestID, nil, error)
                return
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("non 200 http response: \(response.statusCode)")
                let myError = HTTPError.non200StatusCode
                completion(requestID, nil, myError)
                return
            }
            
            guard let data = data else {
                completion(requestID, nil, HTTPError.noData)
                return
            }
            completion(requestID, data, nil)
            }.resume()
    }
}
