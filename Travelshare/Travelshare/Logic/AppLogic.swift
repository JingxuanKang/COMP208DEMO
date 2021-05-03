//
//  File.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import Foundation
import UIKit

class AppLogic {
    static let shared: AppLogic = .init()
    
    let api = Api()
    
    lazy var user: User? = {
        if let data = UserDefaults.standard.value(forKey: "user") as? Data {
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                return user
            }
            return nil
        }
        return nil
    }() {
        didSet {
            cacheUser(user: user)
        }
    }
    
    lazy var allCountries: [Country] = {
        if let data = UserDefaults.standard.data(forKey: "allCountries") {
            if let list = try? JSONDecoder().decode([Country].self, from: data) {
                return list
            }
        }
        return [Country]()
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(allCountries) {
                UserDefaults.standard.set(data, forKey: "allCountries")
            }
        }
    }

    lazy var allArticles: [Article] = {
        if let data = UserDefaults.standard.data(forKey: "allarticles") {
            if let list = try? JSONDecoder().decode([Article].self, from: data) {
                return list
            }
        }
        return [Article]()
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(allArticles) {
                UserDefaults.standard.set(data, forKey: "allarticles")
            }
        }
    }
    
    lazy var allImageShares: [ImageShare] = {
        if let data = UserDefaults.standard.data(forKey: "allImageShares") {
            if let list = try? JSONDecoder().decode([ImageShare].self, from: data) {
                return list
            }
        }
        return [ImageShare]()
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(allImageShares) {
                UserDefaults.standard.set(data, forKey: "allImageShares")
            }
        }
    }
    
    var isLogin: Bool {
        return user != nil
    }
    
    func setup() {
        self.loadCityList { _ in
        }
    }
    
    func login(username: String, password: String, handler: @escaping (Result<User, Error>)->Void) {
        api.login(username: username, password: password) { (result) in
            switch result {
            case .success(let user):
                self.user = user
                handler(.success(user))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func cacheUser(user: User?) {
        if user == nil {
            UserDefaults.standard.set(nil, forKey: "user")
        }
        let data = try! JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    func fetchArticles(by cityId: Int, handler: @escaping ((Result<[Article], Error>) ->Void)) {
        api.loadArticleListOfCity(cityId: String(cityId)) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let allArticles):
                let articles = allArticles.filter({$0.c_id == cityId})
                handler(.success(articles))
            }
        }
    }
    
    func fetchSource(of image: ImageShare) -> Any? { // return Article, City
        //network,去向服务器请求article的结果
        if let id = image.a_id {
            return allArticles.first(where: {$0.a_id == id})
        } else if let id = image.c_id {
            for c in allCountries {
                for city in c.cities {
                    if city.c_id == id {
                        return city
                    }
                }
            }
        }
        return nil
    }
    
    func fetchUserArticles(by user:User, type: UserArticleViewController.FormType, handler: @escaping ((Result<[ArticleListResponse], Error>) ->Void)) {
        api.fetchLikeList(user: user, type: type, handler: handler)
    }
    
    func loadCityList(handler: @escaping (Result<[Country], Error>)->Void) {
        api.loadCityList { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
                
            case .success(let list):
                DispatchQueue.main.async {
                    self.allCountries = list
                    handler(.success(list))
                }
            }
        }
    }
    
    func loadArticleList(userId:Int,handler: @escaping (Result<[Article], Error>)->Void) {
        api.loadArticleList(userId: user?.user_id ?? 9999){ (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
                
            case .success(let list):
                DispatchQueue.main.async {
                    self.allArticles = list
                    handler(.success(list))
                }
            }
        }
    }
    
    func fetchImageShares(handler: @escaping ((Result<[ImageShare], Error>) ->Void)) {
        api.loadShareImages { (result) in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let list):
                self.allImageShares = list
                handler(.success(list))
            }
        }
    }
}

extension UIFont {
    class func normalFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    class func mediumFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    class func boldFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
