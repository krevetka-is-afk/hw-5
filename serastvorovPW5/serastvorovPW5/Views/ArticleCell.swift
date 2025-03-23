//
//  ArticleCell.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let shimmerView: ShimmerView = {
        let view = ShimmerView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentImageURL: URL?
    private var imageLoadTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(containerStackView)
        contentView.addSubview(shimmerView)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(equalToConstant: 80),
            newsImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            containerStackView.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with article: ArticleModel) {
        titleLabel.text = article.title
        descriptionLabel.text = article.announce
        
        if let url = article.img.url {
            // Проверяем, не загружаем ли мы то же самое изображение
            if currentImageURL != url {
                currentImageURL = url
                loadImage(from: url)
            }
        }
    }
    
    private func loadImage(from url: URL) {
        // Отменяем предыдущую загрузку, если она есть
        imageLoadTask?.cancel()
        
        // Проверяем кэш
        if let cachedImage = ImageCache.shared.get(for: url.absoluteString) {
            showImage(cachedImage)
            return
        }
        
        // Показываем эффект мерцания
        shimmerView.startShimmering()
        
        // Загружаем изображение
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            // Сохраняем в кэш
            ImageCache.shared.set(image, for: url.absoluteString)
            
            DispatchQueue.main.async {
                self.showImage(image)
            }
        }
        imageLoadTask?.resume()
    }
    
    private func showImage(_ image: UIImage) {
        UIView.transition(with: newsImageView,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
            self.newsImageView.image = image
            self.newsImageView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.shimmerView.alpha = 0
            } completion: { _ in
                self.shimmerView.stopShimmering()
                self.shimmerView.isHidden = true
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем текущую загрузку
        imageLoadTask?.cancel()
        imageLoadTask = nil
        
        // Очищаем URL текущего изображения
        currentImageURL = nil
        
        // Очищаем UI только если это действительно новое изображение
        if newsImageView.image != nil {
            UIView.animate(withDuration: 0.2) {
                self.newsImageView.alpha = 0
            } completion: { _ in
                self.newsImageView.image = nil
            }
        }
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        shimmerView.stopShimmering()
        shimmerView.isHidden = true
        shimmerView.alpha = 1
    }
}
