//
//  SavedRepoTableViewCell.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit

class SavedRepoTableViewCell: UITableViewCell {
    //MARK: Properties
    
    //checking data
    var dataGetter: DataGetter?
    var repository: Repository? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    private func updateViews() {
        //unwrap object
        guard let repository = repository else {
            print("no song")
            return
        }
        //setting cell labels to object properties
        repoNameLabel.text = repository.name
        repoDescriptionLabel.text = repository.description
        starCountLabel.text = "\(repository.stars)"
        usernameLabel.text = repository.owner.login
        setImage()
    }
    
    //Gets image data
    private func setImage() {
        guard let pictureURL = repository?.owner.avatar_url,
            let url = URL(string: pictureURL) else { return }
        let request = URLRequest(url: url)
        
        dataGetter?.fetchData(with: request, requestID: repository?.owner.avatar_url) { [weak self] (requestID, data, error) in
            guard error == nil else { return }
            guard requestID == self?.repository?.owner.avatar_url else { return }
            guard let data = data else { return }
        
            //converting data to image
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self?.userImageView.image = image
                self?.layoutSubviews()
            }
        }
    }
}
