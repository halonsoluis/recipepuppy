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
    func save(recipe: ModelRecipe) -> Bool {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        guard let recipeDescription = NSEntityDescription.entity(forEntityName: "Recipe", in: context) else {
            return false
        }

        let storedRecipe = NSManagedObject(entity: recipeDescription, insertInto: context)
        storedRecipe.setValue(recipe.href, forKey: "href")
        storedRecipe.setValue(recipe.ingredients, forKey: "ingredients")
        storedRecipe.setValue(recipe.thumbnail, forKey: "thumbnail")
        storedRecipe.setValue(recipe.title, forKey: "title")

        do {
           try context.save()
            return true
          } catch {
           print("Failed saving")
            return false
        }
    }

    func remove(recipe: ModelRecipe) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.predicate = NSPredicate(format: "href = %@", recipe.href)
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context.fetch(request).first as? Recipe {
                context.delete(result)
                try context.save()
                return true
            }
        } catch {
            print("Failed")
        }
        return false
    }

    // TODO: Implement some kind of pagination for not loading it all at once
    func loadAll() -> [ModelRecipe] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context.fetch(request) as? [Recipe] {
                return parseResult(recipes: result)
            }
        } catch {
            print("Failed")
        }
        return []
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
                    favorited: true
                )
        }
    }
}
