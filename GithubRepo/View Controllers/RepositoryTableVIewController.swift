//
//  RepositoryTableVIewController.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit


class RepositoryTableViewController: UITableViewController {
    //MARK: Properties
    
    //checking data
    let repositoryController = RepositoryController()
    let dataGetter = DataGetter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    //MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryController.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        guard let repoCell = cell as? RepositoryTableViewCell else {return cell}
        //passing data
        repoCell.dataGetter = dataGetter
        let repository = repositoryController.repositories[indexPath.row]
        repoCell.repository = repository
        
        return cell
    }
    
    //Fetches data
    func fetch() {
        repositoryController.fetch { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                self.tableView.reloadData()
                print("Table reloaded")
            }
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RepoDetail" {
            guard let destinationVC = segue.destination as? RepositoryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else { return }
            //Passing data to destination vc
            repositoryController.repository = repositoryController.repositories[indexPath.row]
            destinationVC.repositoryController = repositoryController
        }
        //UI
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .white
    }
}
