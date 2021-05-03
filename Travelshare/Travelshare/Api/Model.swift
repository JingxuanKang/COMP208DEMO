//
//  Model.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import Foundation

class User: Codable {
    let user_id: Int
    let username: String
    let password: String
    
    var email: String?
    var phone_number: String?
    var birthday: String?
    var avatarImage: String?
    var longitude : String?
    var latitude : String?
    init(user_id: Int, username: String, password: String) {
        self.user_id = user_id
        self.username = username
        self.password = password
    }
}

class Country: Codable {
    let country: String
    let cities: [City]
    
    class City: Codable {
        let c_name: String
        let c_id: Int
        let latitude: String
        let longitude: String
        let images: [String]
        let city_description: String
        let city_introduction: String
    }
    
    init(country: String, cities: [City]) {
        self.country = country
        self.cities = cities
    }
}

class Article: Codable {
    let a_id: Int
    let c_id: Int
    let name: String
    let author_name: String
    let date: String
    let images: [String]
    let article_introduction: String
    
    let views_count: Int?
    let likes_count: Int?
    let favors_count: Int?
    let is_liked: Bool?
    let is_favored: Bool?
    
    enum CodingKeys: String, CodingKey {
        case date = "data"
        case a_id, c_id, name, author_name, images, article_introduction
        case views_count, likes_count, favors_count, is_liked, is_favored
    }
}

class ArticleListResponse: Codable {
    let like_id: Int?
    let favourite_collection_id:Int?
    let history_id: Int?
    let date_of_like: String?
    let article_id: Int
    let title: String
}

class ImageShare: Codable {
    let image: String
    let id: Int?
    let a_id: Int?
    let c_id: Int?
}

class CommentListResponse: Codable {
    let comment_id: Int
    let user_id: Int
    let comment_content: String
    let date_of_comment: String
    let article_id: Int
}
