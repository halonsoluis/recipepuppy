//
//  RecipesListInteractor.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//

import Foundation
import VIPER

final class RecipesListInteractor: InteractorInterface {

    weak var presenter: RecipesListPresenterInteractorInterface!

    private var lastPageLoaded = 0
    private var recipes: [ModelRecipe] = []
    private var ingredients: String = ""

    private let api: APIServiceInterface
    private let persistence: PersitenceServiceInterface

    private var favorites: [ModelRecipe] = []

    init(api: APIServiceInterface = ServiceFactory().api,
         persistence: PersitenceServiceInterface = ServiceFactory().persistence) {
        self.api = api
        self.persistence = persistence

        loadFavorites()
    }

    private func loadFavorites() {
        DispatchQueue.main.async {
            self.favorites = self.persistence.loadAll()
        }
    }
}

extension RecipesListInteractor: RecipesListInteractorPresenterInterface {
    func toggleFavoritesList() {
    }

    func toggleFavorite(recipe: ModelRecipe) {
        if let index = recipes.lastIndex(where: { $0.href == recipe.href }) {
            let favorited = !recipes[index].favorited
            let success = favorited ? persistence.save(recipe: recipe) : persistence.remove(recipe: recipe)

            if success {
                recipes[index].favorited = favorited
                loadFavorites()
                presenter.recipeFetchedSuccess(recipes: recipes)
            }
        }
    }

    private func curatedIngredients(_ ingredients: String) -> String {
        var ingredientsWithoutSpaces = ingredients.replacingOccurrences(of: ", ", with: ",")

        if ingredientsWithoutSpaces.last == "," {
            _ = ingredientsWithoutSpaces.removeLast()
        }
        return ingredientsWithoutSpaces
    }

    func searchByIngredients(_ ingredients: String) -> Bool {
        let newIngredientsList = curatedIngredients(ingredients)

        guard self.ingredients != newIngredientsList else { return false }
        self.ingredients = newIngredientsList

        prepareForNewSearch()

        return true
    }

    private func prepareForNewSearch() {
        lastPageLoaded = 0
        recipes = []
    }

    private func handleResponse(result: Result<[RecipeData], Error>) {

        switch result {
        case .success(let newRecipes):
            lastPageLoaded = lastPageLoaded + 1
            print("Fetched page \(lastPageLoaded) for ingredients: \(ingredients)")

            recipes.append(contentsOf: prepareData(newRecipes))
            presenter.recipeFetchedSuccess(recipes: recipes)
        case .failure(let error):
            //If we are offline, load data since the beginning
            if (error as NSError).code == -1009 {
                if recipes.isEmpty {
                    DispatchQueue.main.async {
                        self.presenter.recipeFetchedSuccess(recipes: self.favorites)
                    }
                }
            }
            presenter.recipeFetchFailed(error: error)
        }
    }

    private func prepareData(_ newRecipes: [RecipeData]) -> [ModelRecipe] {
        return newRecipes
            .map { ModelRecipe(data: $0) }
            .filter { !recipes.contains($0) }
            .map {
                var recipe = $0
                recipe.title = recipe.title.trimmingCharacters(in: .whitespacesAndNewlines)
                recipe.ingredients = recipe.ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
                recipe.favorited = favorites.contains($0)
                return recipe
        }
    }

    func fetchRecipes() {
        api.fetchRecipes(ingredients: ingredients, page: (lastPageLoaded + 1).description, completionHandler: handleResponse)
    }
}
