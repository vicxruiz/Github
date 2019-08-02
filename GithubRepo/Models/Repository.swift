//
//  Repository.swift
//  GithubRepo
//
//  Created by Victor  on 6/11/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation

//Model Structure for JSON Decoding
struct Items: Codable {
    let items: [Repository]
    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Repository: Codable, Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int
    let name: String
    let owner: Details
    let description: String?
    let stars: Int
    let website: String
    private enum CodingKeys: String, CodingKey {
        case id
        case stars = "stargazers_count"
        case name
        case description
        case owner
        case website = "html_url"
    }
}

struct Details: Codable {
    let login: String
    let avatar_url: String
}



