//
//  RecipesListView.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//

import Foundation
import VIPER
import UIKit
import SnapKit

final class RecipesListView: UIViewController, ViewInterface {

    var presenter: RecipesListPresenterViewInterface!

    private lazy var searchBar: UISearchBar = createSearchBar()
    private lazy var tableView: UITableView = createTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()

        self.presenter.start()
    }

    private func setupInterface() {

        title = "Recipes"

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(4)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}

extension RecipesListView: RecipesListViewPresenterInterface {

}

// MARK: Initializers
extension RecipesListView {
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Insert ingredients here separated by comma"

        return searchBar
    }

    private func createTableView() -> UITableView {
        let view = UITableView()
        view.allowsMultipleSelection = false

        return view
    }
}
