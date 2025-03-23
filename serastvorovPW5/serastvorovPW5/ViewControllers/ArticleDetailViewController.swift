//
//  ArticleDetailViewController.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    var article: ArticleModel?
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isSelectable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Читать полностью", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.addSubview(newsImageView)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(readMoreButton)
        
        readMoreButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: readMoreButton.topAnchor, constant: -20),
            
            readMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readMoreButton.widthAnchor.constraint(equalToConstant: 200),
            readMoreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    private func configure() {
        guard let article = article else { return }
        
        print("полученная статья -> \(article)")
        
        titleLabel.text = article.title
        textView.text = article.fullText ?? article.announce
        
        if let url = article.img.url {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.newsImageView.image = image
                    }
                }
            }
        }
    }
    
    @objc private func openWebView() {
        guard let url = article?.articleUrl else {
            print("Ошибка: нет ссылки на статью")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Ошибка: Safari не может открыть этот URL")
        }
    }
    
    
}
