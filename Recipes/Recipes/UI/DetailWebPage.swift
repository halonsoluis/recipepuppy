//
//  DetailWebPage.swift
//  Recipes
//
//  Created by Hugo Alonso on 26/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import WebKit
import SnapKit
import UIKit

final class DetailWebPage: UIViewController {

    private lazy var webView: WKWebView = createWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
    }

    private func setupInterface() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func loadDetails(for recipe: ModelRecipe) {
        title = recipe.title
        if let url = URL(string: recipe.href) {
            //webView.tale
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - initialisers
extension DetailWebPage {
    private func createWebView() -> WKWebView {
        return WKWebView()
    }
}
