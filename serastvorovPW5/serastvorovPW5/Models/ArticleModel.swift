//
//  ArticleModel.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import Foundation

struct ArticleModel: Decodable {
    let newsId: Int
    let title: String
    let announce: String
    let fullText: String?  
    let img: ImageContainer


    var articleUrl: URL? {
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)")
    }
}

struct ImageContainer: Decodable {
    let url: URL?
}
