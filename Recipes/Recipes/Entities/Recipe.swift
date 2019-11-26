//
//  Recipe.swift
//  Recipes
//
//  Created by Hugo Alonso on 25/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

struct ModelRecipe: Codable {

    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String

}

extension ModelRecipe {
    var hasLactose: Bool {
       return ingredients.lowercased().contains("milk") || ingredients.lowercased().contains("cheese")
    }

    var image: URL? {
        return URL(string: thumbnail)
    }

    var curatedTitle: String {
        return title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var curatedIngredients: String {
        return ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var favorited: Bool {
        return false
    }
}
