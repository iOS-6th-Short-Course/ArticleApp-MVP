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
    
}
