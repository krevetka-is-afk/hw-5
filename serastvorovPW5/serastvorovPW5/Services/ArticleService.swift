//
//  ArticleService.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import Foundation
// Выносим ошибвки в перечисление
enum ArticleError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case emptyData
}

class ArticleService {
    // Выставляем дефолтные настройки
    private let baseURL = "https://news.myseldon.com/api/Section"
    private let pageSize = 8
    
    func fetchNews(page: Int, completion: @escaping (Result<[ArticleModel], ArticleError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "rubricId", value: "4"),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "pageIndex", value: String(page))
        ]
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        // Выполняем сетевой запрос
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            // Проверяем HTTP статус ответа
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(.emptyData))
                return
            }
            // Декодируем JSON в модель данных
            do {
                let decodedData = try JSONDecoder().decode(NewsPage.self, from: data)
                completion(.success(decodedData.news))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
