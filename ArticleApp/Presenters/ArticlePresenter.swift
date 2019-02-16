//
//  ArticlePresenter.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/16/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

class ArticlePresenter: ArticleServiceDelegate {
    
    var delegate: ArticlePresenterDelegate?
    var articleService: ArticleService?
    
    init() {
        articleService = ArticleService()
        articleService?.delegate = self
    }
    
    func getArticles(title: String?, page: Int) {
        if page <= 0 { return }
        articleService?.getArticles(title: title, page: page)
    }
    
    func didResponseArticles(articles: [Article]) {
        for article in articles {
            let date = article.createdDate?.split(separator: " ")
            let newDate = "\(date![0]), \(date![2])-\(date![1])-\(date![5]) | \(date![3])"
            article.createdDate = newDate
        }
        
        delegate?.didResponseArticles(articles: articles)
    }
    
}
