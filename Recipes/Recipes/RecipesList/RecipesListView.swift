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
import Kingfisher

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
            .bind(to: tableView.rx.items(cellIdentifier: "RecipeCell")) { (_, recipe: ModelRecipe, cell: RecipeCell) in
                cell.setTitle(recipe.title)
                cell.setIngredients(recipe.ingredients)
                cell.setHasLactose(recipe.hasLactose)
                cell.setImage(recipe.image)
        }.disposed(by: disposeBag)
    }
}

extension RecipesListView: RecipesListViewPresenterInterface {
    func showRecipes(recipes: Array<ModelRecipe>) {
        self.recipes.accept(recipes)
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    func showError() {

    }
}

extension RecipesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard recipes.value.count > indexPath.row,
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeCell
            else { return UITableViewCell() }

        let recipe = recipes.value[indexPath.row]

        cell.setTitle(recipe.title)
        cell.setIngredients(recipe.ingredients)
        cell.setHasLactose(recipe.hasLactose)
        cell.setImage(recipe.image)

        return cell
    }
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
        let tableView = UITableView()
        tableView.allowsMultipleSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 225
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "RecipeTableView"
        //tableView.dataSource = self
        //        tableView.delegate = self
        //        tableView.prefetchDataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        return tableView
    }
}

class RecipeCell: UITableViewCell {

    private lazy var titleLabel: UILabel = self.createTitleLabel()
    private lazy var ingredients: UILabel = self.createIngredientsLabel()
    private lazy var hasLactose: UILabel = self.hasLactoseLabel()
    private lazy var recipeImage: UIImageView = self.createRecipeImageView()
    private lazy var makeFavorite: UIButton = self.createMakeFavoriteButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        addSubview(recipeImage)
        addSubview(makeFavorite)
        addSubview(titleLabel)
        addSubview(ingredients)
        addSubview(hasLactose)

        recipeImage.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview()
            make.height.equalTo(200)
        }

        makeFavorite.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(44)
            make.right.equalTo(makeFavorite.snp.left)
        }

        ingredients.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.height.greaterThanOrEqualTo(44)
            make.bottom.equalToSuperview().inset(8)
        }

        hasLactose.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(60)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }

        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    func setIngredients(_ ingredients: String) {
        self.ingredients.text = ingredients
    }

    func setFavorited(_ favorited: Bool) {
        self.makeFavorite.isHidden = favorited
    }

    func setHasLactose(_ hasLactose: Bool) {
        self.hasLactose.isHidden = !hasLactose
    }

    func setImage(_ image: URL?) {
        self.recipeImage.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.recipeImage.kf.setImage(with: image!)
        }

    }
}

// MARK: Initialisers
extension RecipeCell {
    private func createRecipeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "recipeImage"
        imageView.backgroundColor = .clear
        return imageView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.accessibilityIdentifier = "title"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func createIngredientsLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.accessibilityIdentifier = "ingredients"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func hasLactoseLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .red
        label.textAlignment = .center
        label.text = "Has Lactose"
        label.accessibilityIdentifier = "lactose"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1

        let radians = CGFloat.pi * CGFloat(45) / CGFloat(180.0)
        label.transform = CGAffineTransform(rotationAngle: radians)
        return label
    }

    private func createMakeFavoriteButton() -> UIButton {
        let favorite = UIButton()
        favorite.titleLabel?.text = "Make favorite"
        return favorite
    }
}
