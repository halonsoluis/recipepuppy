//
//  Model.swift
//  Recipes
//
//  Created by Hugo Alonso on 29/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

struct ModelRecipe: Codable {

    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String

    var favorited: Bool = false

    init(data: RecipeData) {
        title = data.title
        href = data.href
        ingredients = data.ingredients
        thumbnail = data.thumbnail
    }
}

extension ModelRecipe {
    var hasLactose: Bool {
       return ingredients.lowercased().contains("milk") || ingredients.lowercased().contains("cheese")
    }

    var image: URL? {
        return URL(string: thumbnail)
    }
}

extension ModelRecipe: Equatable, Hashable {
    static func ==(lhs: ModelRecipe, rhs: ModelRecipe) -> Bool {
        return lhs.href == rhs.href
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(href)
    }
}
