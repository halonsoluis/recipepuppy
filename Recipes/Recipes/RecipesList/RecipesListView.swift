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
import RxSwift
import RxCocoa

final class RecipesListView: UIViewController, ViewInterface {

    var presenter: RecipesListPresenterViewInterface!

    private lazy var searchBar: UISearchBar = createSearchBar()
    private lazy var tableView: UITableView = createTableView()

    private var recipes = BehaviorRelay<[ModelRecipe]>(value: [])

    private var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        self.presenter.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRx()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setupRx() {

        searchBar.rx.text
            .asDriver()
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (text) in
                self?.presenter.ingredientsChanged(text ?? "")
            }).disposed(by: disposeBag)

        recipes
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "RecipeCell")) { (_, recipe: ModelRecipe, cell: RecipeCell) in
                cell.setTitle(recipe.title)
                cell.setIngredients(recipe.ingredients)
                cell.setHasLactose(recipe.hasLactose)
                cell.setImage(recipe.image)
                cell.setFavorited(recipe.favorited)
        }.disposed(by: disposeBag)

        tableView.rx.contentOffset
            .asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }

                //Fetch at 80% of the content size
                let tableView = strongSelf.tableView
                let isAtFetchingPosition = tableView.contentOffset.y + tableView.frame.size.height > tableView.contentSize.height * 0.8

                if isAtFetchingPosition {
                    strongSelf.presenter.fetchMore()
                }
            }).disposed(by: disposeBag)

    }
}

extension RecipesListView: RecipesListViewPresenterInterface {
    func showRecipes(recipes: Array<ModelRecipe>) {
        self.recipes.accept(recipes)
    }
    
    func showError() {

    }
}

// MARK: Initializers
extension RecipesListView {
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Ingredients: onion, garlic"
        
        return searchBar
    }

    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 225
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "RecipeTableView"
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")

        return tableView
    }
}
