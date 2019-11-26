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

    private var fetching: Bool = false

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

}

extension RecipesListInteractor: RecipesListInteractorPresenterInterface {

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
        lastPageLoaded = 0
        recipes = []

        return true
    }

    func fetchRecipes() {
        guard !fetching else { return }
        fetching = true
        
        lastPageLoaded = lastPageLoaded + 1
        print("Fetching page \(lastPageLoaded) for ingredients: \(ingredients)")

        var components = URLComponents()
        components.scheme = "http"
        components.host = "recipepuppy.com"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "i", value: ingredients),
            //URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "p", value: lastPageLoaded.description)
        ]

        guard let url = components.url else { return }

        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"

        let dataTask = session
            .dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in

                if (error != nil) {
                    self?.presenter.recipeFetchFailed()
                } else {
                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200,
                        let data = data,
                        let jsonString = String(data: data, encoding: .utf8),
                        let jsonData = jsonString.data(using: .utf8)
                        else {
                            print("---    Fetching attempt has failed")
                            self?.fetching = false
                            return
                    }

                    guard let response = try? JSONDecoder().decode(RecipeEnvelope.self, from: jsonData) else { return }

                    guard let strongSelf = self else { return }

                    let newRecipes = strongSelf.prepareData(newRecipes: Array(Set(response.results)))

                    strongSelf.recipes.append(contentsOf: newRecipes)
                    strongSelf.presenter.recipeFetchedSuccess(recipes: strongSelf.recipes)
                }

                self?.fetching = false
            })

        dataTask.resume()
    }

    func prepareData(newRecipes: [ModelRecipe]) -> [ModelRecipe] {
        return newRecipes
            .filter { !recipes.contains($0) }
            .map {
                var recipe = $0
                recipe.title = recipe.title.trimmingCharacters(in: .whitespacesAndNewlines)
                recipe.ingredients = recipe.ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
                return recipe
        }
    }

}
