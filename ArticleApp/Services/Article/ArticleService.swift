//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ArticleService {
    
    var delegate: ArticleServiceDelegate?
    
    func getArticles(title: String?, page: Int) {
        Alamofire.request("\(APIManager.URL_ARTICLE)?page=\(page)&title=\(title ?? "")", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIManager.API_HEADERS).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if let data = response.data {
                    let json = try? JSON(data: data)
                    let jsonDataArray = json!["data"].array
                    var articles = [Article]()
                    for jsonData in jsonDataArray! {
                        let article = Article(json: jsonData)
                        articles.append(article)
                    }
                    self.delegate?.didResponseArticles(articles: articles)
                }
            case .failure(_):
                print("GET DATA FAILED")
            }
            
        }
    }
    
    
    func addArticle(article: Article) {
        let param: [String: Any] = [
            "title": article.title!,
            "description": article.description!,
            "author": article.author!,
            "category": [
                "id": article.category?.id
            ],
            "thumbnail": article.thumbnail!
        ]
        
        Alamofire.request(APIManager.URL_ARTICLE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: APIManager.API_HEADERS).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let json = try? JSON(data: response.data!)
                let message = json!["message"].string
                let reponsedArticle = Article(json: json!["data"])
                self.delegate?.didFinishAddArticle(message: message!, article: reponsedArticle)
            case .failure(_):
                print("ADDING ARTICLE FAILED")
            }
        }
    }
    
    func uploadImageAndAddArticle(imageData: Data, article: Article) {
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imageData, withName: "file", fileName: ".jpg", mimeType: "image/*")
        }, usingThreshold: 0, to: APIManager.URL_UPLOAD, method: .post, headers: APIManager.API_HEADERS) { (uploadResult) in
            switch uploadResult {
                
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    let thumbnail = String(data: response.data!, encoding: .utf8)
                    article.thumbnail = thumbnail
                    self.addArticle(article: article)
                })
            case .failure(_):
                print("UPLOAD FAILED")
            }
        }
    }
    
}
