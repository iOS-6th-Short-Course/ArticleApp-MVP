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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter = ArticlePresenter()
        articlePresenter.delegate = self
        articlePresenter.getArticles(title: nil, page: 1)
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


}

extension ViewController: ArticlePresenterDelegate {
    func didResponseArticles(articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }
}
