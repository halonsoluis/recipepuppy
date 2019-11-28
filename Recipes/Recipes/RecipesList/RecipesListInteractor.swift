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

    init(api: APIServiceInterface = ServiceFactory().api,
         persistence: PersitenceServiceInterface = ServiceFactory().persistence) {
        self.api = api
        self.persistence = persistence
    }
}

extension RecipesListInteractor: RecipesListInteractorPresenterInterface {

    func toggleFavorite(recipe: ModelRecipe) {
        var favorited: Bool = false
        if let index = recipes.lastIndex(where: { $0.href == recipe.href }) {
            recipes[index].favorited = !recipe.favorited
            favorited = recipes[index].favorited
        }
        presenter.recipeFetchedSuccess(recipes: recipes)

        favorited ? persistence.save(recipe: recipe) : persistence.remove(recipe: recipe)
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

    private func handleResponse(newRecipes: [RecipeData]?) {
        if let newRecipes = newRecipes {
            lastPageLoaded = lastPageLoaded + 1
            print("Fetched page \(lastPageLoaded) for ingredients: \(ingredients)")

            recipes.append(contentsOf: prepareData(newRecipes))
            presenter.recipeFetchedSuccess(recipes: recipes)
        } else {
            presenter.recipeFetchFailed()
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
                return recipe
        }
    }

    func fetchRecipes() {
        api.fetchRecipes(ingredients: ingredients, page: (lastPageLoaded + 1).description, completionHandler: handleResponse)
    }
}
