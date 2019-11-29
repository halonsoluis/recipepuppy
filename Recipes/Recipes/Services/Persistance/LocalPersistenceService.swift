//
//  LocalPersistenceService.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// This can be changed to use RealmSwift, wich is much more readable and easy to use.
final class LocalPersistenceService: PersitenceServiceInterface {

    private weak var context: NSManagedObjectContext?

    init() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    func save(recipe: ModelRecipe) -> Bool {
        guard
            let context = context,
            let recipeDescription = NSEntityDescription.entity(forEntityName: "Recipe", in: context) else {
                return false
        }

        guard loadItem(href: recipe.href) == nil else {
            //Block attempts to introduce duplicated recipes
            return false
        }

        let storedRecipe = NSManagedObject(entity: recipeDescription, insertInto: context)
        storedRecipe.setValue(recipe.href, forKey: "href")
        storedRecipe.setValue(recipe.ingredients, forKey: "ingredients")
        storedRecipe.setValue(recipe.thumbnail, forKey: "thumbnail")
        storedRecipe.setValue(recipe.title, forKey: "title")

        if let url = URL(string: recipe.href) {
            storedRecipe.setValue(try? Data(contentsOf: url), forKey: "webContent")
        }

        do {
           try context.save()
            return true
          } catch {
           print("Failed saving")
            return false
        }
    }

    func remove(recipe: ModelRecipe) -> Bool {

        guard let item = loadItem(href: recipe.href) else {
            //Not found
            return false
        }
        context?.delete(item)

        do {
            try context?.save()
            return true
        } catch {
            print("Failed")
        }
        return false
    }

    // TODO: Implement some kind of pagination for not loading it all at once
    func loadAll() -> [ModelRecipe] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context?.fetch(request) as? [Recipe] {
                return parseResult(recipes: result)
            }
        } catch {
            print("Failed")
        }
        return []
    }

    private func loadItem(href: String) -> Recipe? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.predicate = NSPredicate(format: "href = %@", href)
        request.returnsObjectsAsFaults = false
        return try? context?.fetch(request).first as? Recipe
    }

    private func parseResult(recipes: [Recipe]) -> [ModelRecipe] {
        return recipes
            .map {
                ModelRecipe(
                    data: RecipeData(
                        title: $0.title ?? "",
                        href: $0.href ?? "",
                        ingredients: $0.ingredients ?? "",
                        thumbnail: $0.thumbnail ?? ""
                    ),
                    favorited: true,
                    webContent: $0.webContent
                )
        }
    }
}
