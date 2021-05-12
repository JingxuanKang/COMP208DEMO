//
//  Api.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/10.
//

import Foundation
import UIKit

class Api {
    private let host:String =  "http://8.208.117.166"
    
    func login(username: String, password: String, handler: @escaping (Result<User, Error>)->Void) {
        let map = ["username": username, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/user/login"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            if let user = try? JSONDecoder().decode(User.self, from: data!) {
                handler(.success(user))
                return
            }
            handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Login Failed"])))
        }
        dataTask.resume()
    }
    
    func register(username: String, password: String, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": username, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/user/regist"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Register Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func loadCityList(handler: @escaping (Result<[Country], Error>)->Void) {
        let urlString = "http://8.208.117.166/api/city/list"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([Country].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func loadArticleListOfCity(cityId: String, handler: @escaping (Result<[Article], Error>)->Void) {
        let urlString = host + "/api/blog/list/?city_id=\(cityId)"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([Article].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }

    func loadArticleList(userId: Int,handler: @escaping (Result<[Article], Error>)->Void) {
        
        
        let urlString = host + "/api/recommand/list?user_id=\(userId)"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([Article].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func loadShareImages(handler: @escaping (Result<[ImageShare], Error>)->Void) {
        let urlString = host + "/api/imageShare"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([ImageShare].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func loadArticleDetail(articleId: Int, userId: Int, handler: @escaping (Result<Article, Error>)->Void) {
        let urlString = host + "/api/blog/detail?article_id=\(articleId)&user_id=\(userId)"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode(Article.self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func likeArticle(user: User, articleId: Int, isUnlike: Bool = false, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
                   "article_id": String(articleId)
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/blog/\(isUnlike ? "cancellike" : "like")"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"\(isUnlike ? "Unlike" : "Like") article Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    func sendLike(user: User, articleId: Int,eventType:String, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
                   "article_id": String(articleId),
                   "eventType": eventType,
                   "userLatitude": user.latitude ?? "" ,
                   "userLongitude": user.longitude ?? ""
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/blog/recordEvent"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Like article Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    func sendView(user: User, articleId: Int,eventType:String, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
                   "article_id": String(articleId),
                   "eventType": eventType,
                   "userLatitude": user.latitude ?? "" ,
                   "userLongitude": user.longitude ?? ""
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/blog/recordEvent"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"view article Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func sendFavorite(user: User, articleId: Int,eventType:String, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
                   "article_id": String(articleId),
                   "eventType": eventType,
                   "userLatitude": user.latitude ?? "" ,
                   "userLongitude": user.longitude ?? ""
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/blog/recordEvent"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Favorite article Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
    
    func favouriteArticle(user: User, articleId: Int, isCancel: Bool = false, handler: @escaping (Result<String, Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
                   "article_id": String(articleId)
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/blog/\(isCancel ? "cancelfavor" : "favor")"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"\(isCancel ? "Unfavourite" : "favourite") article Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
    
    func fetchLikeList(user: User, type: UserArticleViewController.FormType, handler: @escaping (Result<[ArticleListResponse], Error>)->Void) {
        let map = ["username": user.username,
                   "password": user.password,
                   "user_id": String(user.user_id),
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/user/\(type == .favourite ? "favor" : (type == .liked ? "like" : "history"))List"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([ArticleListResponse].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func fetchCommentList(articleId: Int, handler: @escaping (Result<[CommentListResponse], Error>)->Void) {
        let urlString = host + "/api/comment/list?article_id=\(articleId)"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "GET"
        urlReq.timeoutInterval = 15.0
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                let array = try JSONDecoder().decode([CommentListResponse].self, from: data!)
                handler(.success(array))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }

    func publishComment(user: User, articleId: Int, content: String, handler: @escaping (Result<String, Error>)->Void) {
        let map = [
            "username": user.username,
            "password": user.password,
            "user_id": String(user.user_id),
            "article_id": String(articleId),
            "comment_content": content
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/comment/new"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Load failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }

}

extension Api {
    
    struct NewBlogParms {
        var title: String?
        var content: String?
        var userId: String?
        var username: String?
        var password: String?
        var cityId: String?
        var images:[UIImage]?
    }
    
    func createNewBlog(params: NewBlogParms, handler: @escaping (Result<String, Error>)->Void) {
        let urlString = host + "/api/blog/new"
        let myUrl = URL(string: urlString)!
        let request = NSMutableURLRequest(url:myUrl);
        request.httpMethod = "POST";
        
        let paramDic = [
            "title"  : params.title!,
            "content"  : params.content!,
            "user_id"  : params.userId!,
            "password"  : params.password!,
            "city_id"  : params.cityId!,
            "author": params.username!,
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageDatas = params.images?.map({$0.pngData()!}) else {
            handler(.failure(NSError.init(domain: "API", code: 0, userInfo: [NSLocalizedFailureErrorKey: "Please Selecte at least one image"])))
            return
        }
        
        request.httpBody = createBodyWithParameters(parameters: paramDic, filePathKey: "imgfile", imagesDatas: imageDatas, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Upload Blog Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imagesDatas: [Data], boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(NSUUID().uuidString).png"
        let mimetype = "image/png"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        for data in imagesDatas {
            body.append(data)
        }
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func updateUserInfo(user: User, email: String?, phoneNumber: String?, birthday: String?, handler: @escaping (Result<String, Error>)->Void) {
        var map:[String : Any] = [
            "username": user.username,
            "password": user.password,
            "user_id": String(user.user_id)
        ]
        map["email"] = email
        if let v = phoneNumber, let value = Int(v) {
            map["phone_number"] = value
        }
        map["birthday"] = birthday
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else {
            handler(.failure(NSError(domain: "Api", code: 0, userInfo: [NSLocalizedFailureErrorKey:"Data Error"])))
            return
        }
        
        let urlString = host + "/api/user/updateInfo"
        var urlReq = URLRequest(url: URL(string: urlString)!)
        urlReq.httpMethod = "POST"
        urlReq.timeoutInterval = 15.0
        urlReq.httpBody = bodyData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            guard data != nil else {
                handler(.failure(NSError(domain: "Api", code: 0, userInfo: [:])))
                return
            }
            do {
                if let map = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    if let errorCode = map["errno"] as? Int, errorCode == 0 {
                        handler(.success(""))
                        return
                    }
                }
                handler(.failure(NSError(domain: "Api", code: 1, userInfo: [NSLocalizedFailureErrorKey:"Update User Information Failed"])))
            } catch {
                handler(.failure(error))
            }
        }
        dataTask.resume()
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
