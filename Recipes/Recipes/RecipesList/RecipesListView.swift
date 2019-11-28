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

    private var recipes = BehaviorRelay<[ModelRecipe]?>(value: nil)

    private var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()

        //Needed for circumvent the issue:
        //    https://github.com/ReactiveX/RxSwift/issues/2081
        //    https://github.com/RxSwiftCommunity/RxDataSources/issues/331
        // Once it's solved, it's safe to move the call to setupRX back into viewDidLoad() without the async.
        DispatchQueue.main.async {
            self.setupRx()
        }

        self.presenter.start()
    }

    private func setupInterface() {

        title = "Recipes"
        view.backgroundColor = .white

        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
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
            .distinctUntilChanged()
            .flatMap { Observable.from(optional: $0) } //unwrap
            .bind(to: self.tableView.rx.items(cellIdentifier: "RecipeCell")) { [weak self] (_, recipe: ModelRecipe, cell: RecipeCell) in
                self?.prepareCell(recipe: recipe, cell: cell)
        }.disposed(by: self.disposeBag)

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

        tableView.rx.modelSelected(ModelRecipe.self)
            .asDriver()
            .drive(onNext: { [weak self] item in
                self?.presenter.openDetail(recipe: item)
            }).disposed(by: disposeBag)
    }

    private func prepareCell(recipe: ModelRecipe, cell: RecipeCell) {
        cell.setTitle(recipe.title)
        cell.setIngredients(recipe.ingredients)
        cell.setHasLactose(recipe.hasLactose)
        cell.setImage(recipe.image)
        cell.setFavorited(recipe.favorited)

        cell.toggleFavorite = { [weak self] in
            self?.presenter.toggleFavorite(recipe: recipe)
        }
    }
}

extension RecipesListView: RecipesListViewPresenterInterface {
    func showRecipes(recipes: Array<ModelRecipe>) {
        self.recipes.accept(recipes)
    }
    
    func showError() {
        // TODO
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
