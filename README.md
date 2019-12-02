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
      - [Data Persistence](#data-persistence)
      - [Other choices](#other-choices)
    - [What would I have done better with more time](#what-would-i-have-done-better-with-more-time)
  - [Final takeaway](#final-takeaway)

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

### Implicit requiments of the task

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
- [x] Reason about your choices and defend your opinions and decisions
  - [x] Why have you used a certain data structure?
  - [x] Which alternatives did you consider?
  - [x] What would you improve if you had more time?

## Development Story

### Initial API Analysis

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

#### Observations

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

### Documentation of the process

#### Project architecture (**VIPER**)

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

#### UI (**Snapkit**)

   **Why choosing to use it over Storyboards?**

| PROS                                                     | CONS                                                        |
| -------------------------------------------------------  | -----------------------------------------------------------------------------------|
| Less conflicts when merging code from several sources (team work)   | Need to add everything UI related manually                                                                 |
| The intention is clear and readable at any moment                  | No visual editor
| Finding an offensive Autolayout rule is easier | Needed to run the project to see the changes reflected and compare with desired result                                                      |
| The developer tends to think more about what it writes  | It takes more time |
| Easier to review in a Pull Request (team work)  | The file containing the view gets bigger

#### Networking

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

#### Data Persistence

Since the very beginning I was thinking on using Realm for Data Persistence. But, where's the fun on it? Using CoreData is a good oportunity to showcase threading management and enjoy some nice headaches 🤕.

As it was intended only to save favorites, the entity `Recipe` would save the data needed for reconstructing the full object and the contents of the saved webpage. Maybe it would have be better to naming it as `FavoritedRecipe`.

The protocol defines some of the base use cases of a CRUD:

```swift
protocol PersitenceServiceInterface {
    func save(recipe: ModelRecipe) -> Bool
    func remove(recipe: ModelRecipe) -> Bool
    func loadAll() -> [ModelRecipe]
}
```

And includes, an extension for handling threading. That guarantees that all calls are made on the same thread, in an async way, with a high priority and that it returns with a completion handler executed in the Main Thread.

>Maybe I could have moved this logic into an unique private `func`, working with generics and higher order functions. Something like:

```swift
extension PersitenceServiceInterface {
    private var persistenceThread: DispatchQueue { DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated) }

    func save(recipe: ModelRecipe, completionHandler: @escaping (Bool) -> Void) {
        threadSafe(action: { self.save(recipe: recipe) }) { completionHandler($0) }
    }

    func remove(recipe: ModelRecipe, completionHandler: @escaping (Bool) -> Void) {
        threadSafe(action: { self.remove(recipe: recipe) }) { completionHandler($0) }
    }

    func loadAll(completionHandler: @escaping ([ModelRecipe]) -> Void) {
        threadSafe(action: { self.loadAll() }) { completionHandler($0) }
    }

    private func threadSafe<ResultType>(action: @escaping () -> ResultType, completionHandler: @escaping (ResultType) -> Void) {
        persistenceThread.async {
            let result = action()
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
```

>But this is something I just got out of my head now, from here the importance of revisiting code and refactor when needed. This reduces the amounts of duplicated code and hence, the chances of commiting errors, and, of course, is suuuper *swifty* 🚀

This service is injected via the constructor of the Interactor, as well as it's done and explained before with the API Service. So, no need to repeat myself in this matter.

#### Other choices

There are other choices that I made but to explain it here it would be, maybe too obvious/tedious and I guess it would be wasting space and time, I'll just point some of them out and I'm open to discuss them.

- Why Reactive Programming (RxSwift)?
- Why I decided to use some technologies/patterns for the first time for the realisation of this project?
- More details regardings the views (`RecipesListView`, `RecipeCell`, `DetailWebPage`)
- Why I did not create modules for `DetailWebPage` & `RecipeCell?`
- External Library for handling Image caching and presentation (KingFisher)
- Swift Package Manager and why `DEAD_CODE_STRIPPING = NO;` had to be set this way for current version of XCode.
- Why SPM over Cocoapods?
- Why Quick & Nimble are added to the project since the beginning?
- Why I did not attempted to do TDD?
- etc.

### What would I have done better with more time

- I would have figured out a way to layout the content differently, I tried to keep myself as close to the sketch as possible, but the low resolution of the images received by the API was hurting my eyes all the time.
- I would have considered to set the Image of the cells to adjust in height automatically, but with square images, that would have been something not nice to see for the end-user.
- Error handling
  - There's no message presented to the user at any moment
  - Some error cases could need to be revisited
- Test coverage
  - Not even one test made 😫
- Pagination for loading data from the database of favorites, or avoid mapping it until needed for avoiding extra memory consumption in large datasets.
- Some more in-depth details into how to actually use some of the interfaces. For example, only the functions in the extension of `PersitenceServiceInterface` should be used by the interactor.
- Icons & LaunchScreen (Not required, but nice to have)
- I would have added compatibility with older versions of iOS, as using [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) blocks the compatibility into only iOS 13+. Also, I would have probably made a better use of SF SYmbols, as this was the first time I used them.
- Split into more VIPER modules and sparse a bit more the code inside the **Interactor**
- I would have figured out what was actually supposed to go into:
  
```swift
protocol RecipesListPresenterRouterInterface: PresenterRouterInterface {}
```

## Final takeaway

I have learned a lot, and I feel like.. as that is always part of my objectives, that this is a total success. 

I'll continue working on this in my spare time, from time to time, as it can be a good point for mentoring, training, or just experiment with some crazy ideas. And, of course, those tests will be added ✅