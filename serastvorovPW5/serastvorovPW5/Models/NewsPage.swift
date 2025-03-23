//
//  NewsPage.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

struct NewsPage: Decodable {
    let news: [ArticleModel]  // Внутри API-ответа "news" - это массив статей
}
