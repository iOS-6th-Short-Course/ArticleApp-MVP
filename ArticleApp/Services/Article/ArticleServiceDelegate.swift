//
//  ArticleServiceDelegate.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/16/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

protocol ArticleServiceDelegate {
    func didResponseArticles(articles: [Article])
}
