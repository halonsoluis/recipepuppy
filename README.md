# Building a Recipes Book

<p align="center">
<img src="images/all_recipes_list_plus_favorites_option.png" width="230">
<img src="images/favorite_recipes_list.png" width="230">
</p>

- [Building a Recipes Book](#building-a-recipes-book)
  - [The challenge](#the-challenge)
  - [Implicit requiments of the task](#implicit-requiments-of-the-task)
- [Development Story](#development-story)
  - [Initial API Analysis](#initial-api-analysis)
    - [Observations](#observations)
  - [Documentation of the process](#documentation-of-the-process)
    - [Project architecture (**VIPER**)](#project-architecture-viper)
    - [UI (**Snapkit**)](#ui-snapkit)
    - [Networking](#networking)

## The challenge

This challenge should be done by using the free to use RecipePuppy API. We would like you to retrieve some recipes from there, display the recipes and perform certain operations on those recipes. Hereby the details:

1. API connection, you should use their search endpoint and perform recipe searches with one or multiple ingredients (ie: http://www.recipepuppy.com/api/?i=onions,garlic&p=1) and parse the results. We would like you to use the networking tools iOS provides and not an external library.
2. Use a searchbar as user input for the first point and show the results in a collection view with a layout like the following. Each recipe should show the image on top, the recipe name, ingredients (this one could have multiple lines so the layouts should support dynamic heights) and a label in a 45% angle that would show only if it contains lactose (to simplify consider that only milk and cheese contain lactose).

<p align="center">
<img src="images/main_search_sketch.png" width="230">
</p>

3. Add pagination to the list whenever the user scrolls,this should be as seamless as possible.
4. Each recipe has an href parameter that is an URL pointing to a website with the recipe details. Whenever the user clicks on a recipe use this parameter to open the website in a new view without leaving the app.
5. Offline functionality, each recipe should have a favorite button and clicking it should save the full recipe offline. Create a separate screen and a way to access it to show the favorite recipes.

## Implicit requiments of the task

- [x] Use latest Swift code.
- [x] Project architecture
  - [x] VIPER encouraged, but don’t enforced
  - [x] Good project structure
  - [x] Clear responsibilities of each component.
- [x] Code quality:
  - [x] Appropriate data structures
  - [x] Typical programming patterns
  - [x] Good practices.
- [ ] Documentation: while we don’t document all our code we do want to have clear documentation of key, complex or reusable components of our projects.
  - [x] Some really important edge cases.
  - [ ] Reusable components are not completely documented
- [ ] Testing
  - [ ] Unit Test
  - [ ] UI Test
  - [ ] Integration
  - [ ] Every kind of test you can imagine
  - [x] Testable code.
- [x] UI: 
  - [x] Use Nibs -not enforced
    - Used programmatically interfaces - Snapkit
  - [x] Avoid fixed sizes (in cases that it's possible)
- [x] Git history
  - [x] Add a local git repository
  - [x] Use a good git flow
    - I'll mark it as done as it's something I can demostrate in other ways, but I forgot to start using it from the beginning.
- [ ] Reason about your choices and defend your opinions and decisions
  - [ ] Why have you used a certain data structure?
  - [ ] Which alternatives did you consider?
  - [ ] what would you improve if you had more time?

# Development Story

## Initial API Analysis

> For the analysis of the API has been used the vscode extension **Rest Client** and the app **Insomnia**

- Base Search API
**GET** http://www.recipepuppy.com/api/

Optional Parameters:

- `i`: comma delimited ingredients
- `q` : normal search query
- `p` : page


**GET** http://www.recipepuppy.com/api/?i=onions,garlic&p=2

Example Result

```json
{
  "title": "Recipe Puppy",
  "version": 0.1,
  "href": "http:\/\/www.recipepuppy.com\/",
  "results": [ 
        {
            "title": "Roasted Garlic Grilling Sauce \r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\r\n\r\n",
            "href": "http:\/\/www.kraftfoods.com\/kf\/recipes\/roasted-garlic-grilling-sauce-56344.aspx",
            "ingredients": "garlic, onions, hot sauce",
            "thumbnail": "http:\/\/img.recipepuppy.com\/634118.jpg"
        }
   ]
}
```

### Observations

- String content received needs to be trimmed. (`"Roasted Garlic Grilling Sauce\r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\r\n\r\n"`)
- Result

```json
    {
       "title": String,
        "href": String,
        "ingredients": String,
        "thumbnail": String,
    }
```

- The API is not stable, for some cases, for example, asking for the second page produces a **500** error and returns a **404 File Not Found** html
**GET** http://www.recipepuppy.com/api/?i=onions,garlic&q=&p=2

But, while asking for the 3 page, it produces results:

 **GET** http://www.recipepuppy.com/api/?i=onions,garlic&q=&p=101

- Pagination
  - In some cases empty result sets are received for one page and for the next one, actual results are returned.
  - There's no documented way to know for the amount of pages available. The API just return:
  - It would be needed to try to fetch a couple of pages in advance before reporting as finished the list of recipes

## Documentation of the process

### Project architecture (**VIPER**) 

   **Why choosing to use it even if it's not enforced?**

| PROS                                                     | CONS
| -------------------------------------------------------  | -----------------------------------------------------------------------------------|
| It's used by many of the recent companies in the field   | Extra Boilerplate.                                                                 |
| It's seen as an improvement over MVVM.                   | It would take some research time to master.                                        |
|It could solve some of the problems I'm facing with MVVM. | I may make several mistakes                                                        |
| Personal opportunity to learn with a hands on strategy.  | Some degree of uncertainty regarding being able to finish in time the task in hand |

  **The takeaways:**

- I found [VIPERA](https://github.com/CoreKit/VIPERA) and [this blogpost](https://theswiftdev.com/2019/09/18/how-to-build-swiftui-apps-using-viper/) as the most valuable assets for getting into it. The structure can be a bit messy when you fill pressure to learn it fast and you find that there are many ways to do it.
- It would have been easier to use MVVM as I have previous experience with it. But I would have lost the oportunity to learn something with a real goal/application in mind. At the end, from my experience, we really get to learn something **well** when we have an inmediate application for it.
- Some degree of expertise is required to handle some of the cases. I found myself not using one of the interfaces. I'll need to dig into it and figure it out which was the intention of that one.
- I must attempt to use other types of implementations of VIPER, using modules more intensively.
- As soon as it's used for a couple of use cases, then it feels natural.
- It makes a lot more clear how to make the code testable.

### UI (**Snapkit**)

   **Why choosing to use it over Storyboards?**

| PROS                                                     | CONS                                                        |
| -------------------------------------------------------  | -----------------------------------------------------------------------------------| 
| Less conflicts when merging code from several sources (team work)   | Need to add everything UI related manually                                                                 |
| The intention is clear and readable at any moment                  | No visual editor
| Finding an offensive Autolayout rule is easier | Needed to run the project to see the changes reflected and compare with desired result                                                      |
| The developer tends to think more about what it writes  | It takes more time |
| Easier to review in a Pull Request (team work)  | The file containing the view gets bigger

### Networking

At the beginning, and as in many examples around the web, the Networking was placed inside the **Interactor**. This is not a good idea for big projects, or in general, it's good to have a facade over it to allow changes in the API and separation of concerns.

For example, in this case, the API was not reliable enough, so, some considerations had to be made in order to remove that concern from the **Interactor** which intention is to obtain/process/prepare the data for the presenter.

```swift
typealias APIResponse = (Result<[RecipeData], Error>) -> Void
protocol APIServiceInterface {
    func fetchRecipes(ingredients: String, page: String, completionHandler: @escaping APIResponse)
}
```

Adding responsabilities of the Network layer in the **Interactor** was smelling really bad 😷, a really *lightweight* **Services** approach was used instead. Injecting the needed dependencies in every case making the code as easily testable and single responsability as posible.

Why *lightweight*? There are several examples of using Services in VIPER, going trough all the process of registering them in a **ServicesBuilder**, and it **sounds awesome**, but for only two services that I was planning to use in this constrained exercise, it was not worthed to add that complexity and to maintain those new classes and boilerplate needed.

```swift
protocol ServicesCatalog: class {
    var api: APIServiceInterface { get }
    var persistence: PersitenceServiceInterface { get }
}
```

In a project aiming to production, I see it as the way to go, to make Services and to register them via a centralized Injection. Or Services Builder as called in some places.

For this case, I used just a Factory for it, no rigid schemas of what a Service should include or extra added rules, those are better in other kind of projects.

```swift
final class ServiceFactory: ServicesCatalog {
    var api: APIServiceInterface { RecipeAPIService(session: URLSession.shared) }
    var persistence: PersitenceServiceInterface { LocalPersistenceService() }
}
```

The networking service handles:

- Avoids parallel request to the API
  - Due to the way pagination had to be implemented.
- Error handling
  - Error ignoring for special error cases
- Data Parsing into `RecipeData` removing `RecipeEnvelope` from the request results received.
- Semi-stateless, it only remember if a fetch is ongoing.

The `RecipesListInteractor` handles then:

- Translates data into `ModelRecipe` to be used in the rest of the app
- Reacts to errors
- Keep track of received items for avoiding any possible duplicates
- Remembers which page to request next.
  - This could have been moved into the **Networking Service** but it would have gotten complexer and the Single Responsability principle would had gone away. It would have required to remember there the last ingredients terms used.
- Curate the ingredients string to pass to the network service, removing spaces, extra commas, etc.
  - The same as before applies. The interactor knows what it can find in that string, the `APIServiceInterface` should not be aware of that. With more time I would have changed the implementation in a way that the ingredients could have been passed one by one as part of a `[String]`, as this reduces a lot of the current problems in the usage of the API.