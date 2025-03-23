//
//  NewsViewModel.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import Foundation

class NewsViewModel {
    private let service = ArticleService() // api сервис
    private(set) var articles: [ArticleModel] = [] // массив новостей
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    
    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    func loadNews(forceRefresh: Bool = false) {
        guard !isLoading else { return }
        
        // сбрасываем состояние при обновлении
        if forceRefresh {
            currentPage = 1
            articles = []
            hasMorePages = true
        }
        
        guard hasMorePages else { return }
        
        isLoading = true
        onLoading?(true)
        
        service.fetchNews(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.onLoading?(false)
                
                switch result {
                case .success(let newArticles):
                    if forceRefresh {
                        self.articles = newArticles
                    } else {
                        self.articles.append(contentsOf: newArticles)
                    }
                    self.currentPage += 1
                    self.hasMorePages = !newArticles.isEmpty
                    self.onDataUpdated?()
                    
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    // Обновляем страницы, есди до конца загруженного экрана 4 страницы
    func loadMoreIfNeeded(currentItem: Int) {
        let threshold = articles.count - 4
        if currentItem >= threshold {
            loadNews()
        }
    }
}
