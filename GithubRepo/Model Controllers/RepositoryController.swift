//
//  RepositoryController.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation

class RepositoryController {
    //MARK: Properties
    
    //passing data
    let dataGetter = DataGetter()
    let baseURL = URL(string: "https://api.github.com")!
    var repositories: [Repository] = []
    var repository: Repository?
    
    //User Saved Data
    var savedRepos: [Repository] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    //MARK: API
    
    //api call
    func fetch(completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        
        //adds query items
        let queryItemQuery = URLQueryItem(name: "q", value: "created:>2017-10-22")
        let querySortItemQuery = URLQueryItem(name: "sort", value: "stars")
        let queryOrderItemQuery = URLQueryItem(name: "order", value: "desc")
        components.queryItems = [queryItemQuery, querySortItemQuery, queryOrderItemQuery]
        print(components.url ?? "no url")
        
        //Makes request
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            //error handling
            if let error = error {
                completion(error)
            }
            guard let data = data else { return }
            
            //decoding
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(Items.self, from: data)
                self.repositories = data.items
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
    
    //MARK: Persistence
    
    //method to save to array
    func save() {
        guard let repository = repository else { return }
        savedRepos.append(repository)
        savedRepos = savedRepos.sorted { $0.id < $1.id }
        self.repository = nil
        saveToPersistentStore()
    }
    
    //method to delete pokemon
    func delete(repository: Repository) {
        guard let index = savedRepos.index(of: repository) else { return }
        savedRepos.remove(at: index)
        saveToPersistentStore()
    }
    
    //saves data to url in document
    func saveToPersistentStore() {
        let plistEncoder = PropertyListEncoder()
        do {
            let data = try plistEncoder.encode(savedRepos)
            guard let repositoryFileURL = repositoryFileURL else { return }
            try data.write(to: repositoryFileURL)
        } catch {
            NSLog("Error enconding items: \(error)")
        }
    }
    
    //loads data from path
    func loadFromPersistentStore() {
        do {
            guard let repositoryFileURL = repositoryFileURL,
                FileManager.default.fileExists(atPath: repositoryFileURL.path) else  { return }
            let data = try Data(contentsOf: repositoryFileURL)
            let plistDecoder = PropertyListDecoder()
            self.savedRepos = try plistDecoder.decode([Repository].self, from: data)
        } catch {
            print(error)
        }
    }
    
    //makes file path
    var repositoryFileURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "repositories.plist"
        return documentDirectory?.appendingPathComponent(fileName)
    }

}
