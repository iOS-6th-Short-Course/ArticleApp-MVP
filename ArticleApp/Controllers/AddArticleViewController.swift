//
//  AddArticleViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/9/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

class AddArticleViewController: UIViewController, ArticlePresenterDelegate {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    var articlePresenter: ArticlePresenter!
    
    var imagePickerController: UIImagePickerController!
    
    var article: Article?
    
    var firstImage: UIImage?
    var secondImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = article {
            titleTextField.text = article.title
            authorTextField.text = article.author
            descriptionTextView.text = article.description
            categoryTextField.text = "\(article.category!.id!)"
            thumbnailImageView.kf.setImage(with: URL(string: article.thumbnail!))
            
            title = "Update Article"
            button.setTitle("Update", for: .normal)
            
            firstImage = thumbnailImageView.image
            secondImage = firstImage
        }
        
        articlePresenter = ArticlePresenter()
        articlePresenter.delegate = self
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        thumbnailImageView.addGestureRecognizer(tapGesture)
        thumbnailImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func pickImage() {
        present(imagePickerController, animated: true, completion: nil)
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
        let article = Article()
        article.title = titleTextField.text
        article.description = descriptionTextView.text
        article.author = authorTextField.text
        article.category = Category(id: Int(categoryTextField.text!)!, name: "")
        
        articlePresenter.addArticleWithImage(image: thumbnailImageView.image!, article: article)
    }
    
    func didFinishAddArticle(message: String, article: Article) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name("newArticleAdded"), object: nil, userInfo: ["newArticle" : article])
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func didResponseArticles(articles: [Article]) {
        
    }
    
}


extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            thumbnailImageView.image = image
            secondImage = image
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}
