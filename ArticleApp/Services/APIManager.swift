//
//  APIManager.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/16/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

class APIManager {
    
    private static let BASE_HOSTNAME = "http://ams.chhaileng.com"
    
    static let URL_ARTICLE = "\(BASE_HOSTNAME)/api/v1/articles"
    static let URL_UPLOAD = "\(BASE_HOSTNAME)/api/v1/upload"
    
    static let API_HEADERS = [
        "Authorization": "Basic YXBpOmFwaQ==",
        "Content-Type": "application/json"
    ]
    
}
