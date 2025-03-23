//
//  WebViewController.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var url: URL?
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.bounds
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}
