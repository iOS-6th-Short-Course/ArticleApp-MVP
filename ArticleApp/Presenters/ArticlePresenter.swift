//
//  ArticlePresenter.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/16/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit

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
    
    func addArticleWithImage(image: UIImage, article: Article) {
        let imageData = UIImage.jpegData(image)(compressionQuality: 0.5)
        articleService?.uploadImageAndAddArticle(imageData: imageData!, article: article)
    }
    
    func didResponseArticles(articles: [Article]) {
        for article in articles {
            let date = article.createdDate?.split(separator: " ")
            let newDate = "\(date![0]), \(date![2])-\(date![1])-\(date![5]) | \(date![3])"
            article.createdDate = newDate
        }
        
        delegate?.didResponseArticles(articles: articles)
    }
    
    func didFinishAddArticle(message: String, article: Article) {
        delegate?.didFinishAddArticle(message: message, article: article)
    }
    
}
