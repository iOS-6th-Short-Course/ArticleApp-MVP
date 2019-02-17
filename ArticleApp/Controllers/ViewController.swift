//
//  ViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articlePresenter: ArticlePresenter!
    var articles = [Article]()
    
    var page = 1
    
    let loadMore = UIActivityIndicatorView(style: .gray)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter = ArticlePresenter()
        articlePresenter.delegate = self
        articlePresenter.getArticles(title: nil, page: page)
        
        tableView.tableFooterView = loadMore
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticle), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newArticleAdded(notification:)), name: NSNotification.Name("newArticleAdded"), object: nil)
        
        
    }
    
    @objc func refreshArticle() {
        print("refresh")
        articles = []
        tableView.reloadData()
        page = 1
        articlePresenter.getArticles(title: nil, page: page)
    }
    
    @objc func newArticleAdded(notification: Notification) {
        let article = notification.userInfo!["newArticle"] as! Article
        articles.insert(article, at: 0)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: [:])?.first as! TableViewCell
        
        cell.setupCell(article: articles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "addArticleVC") as! AddArticleViewController
            editVC.article = self.articles[indexPath.row]
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count - 1 {
            page += 1
            articlePresenter.getArticles(title: nil, page: page)
            loadMore.startAnimating()
        }
    }

}

extension ViewController: ArticlePresenterDelegate {
    func didFinishAddArticle(message: String, article: Article) {
        
    }
    
    func didResponseArticles(articles: [Article]) {
        self.articles += articles
        loadMore.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}
