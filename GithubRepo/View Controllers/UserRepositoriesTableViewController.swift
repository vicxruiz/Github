//
//  UserRepositoriesTableViewController.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit

class UserRepositoriesTableViewController: UITableViewController {
    //Mark: Properties
    
    //checking for data
    var repositoryController = RepositoryController()
    var dataGetter = DataGetter()
    
    //MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repositoryController.loadFromPersistentStore()
        tableView.reloadData()
    }
    
    //MARK: Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryController.savedRepos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoSavedCell", for: indexPath) as! SavedRepoTableViewCell
        cell.dataGetter = dataGetter
        let repository = repositoryController.savedRepos[indexPath.row]

        //updating attributes
        cell.repository = repository
        
        return cell
    }
}
