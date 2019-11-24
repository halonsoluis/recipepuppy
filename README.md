
# The challenge: Build a recipes book

This challenge should be done by using the free to use RecipePuppy API. We would like you to retrieve some recipes from there, display the recipes and perform certain operations on those recipes. Hereby the details:
1. APIconnection, you should use their search endpoint and perform recipe searches with one or multiple ingredients (ie: http://www.recipepuppy.com/api/? i=onions,garlic&p=1) and parse the results. We would like you to use the networking tools iOS provides and not an external library.
2. Use a searchbar as user input for the first point and show the results in a collection view with a layout like the following. Each recipe should show the image on top, the recipe name, ingredients (this one could have multiple lines so the layouts should support dynamic heights) and a label in a 45% angle that would show only if it contains lactose (to simplify consider that only milk and cheese contain lactose).

<p align="center">
<img src="images/main_search_sketch.png" width="230">
</p>

3. Add pagination to the list whenever the user scrolls,this should be as seamless as possible.
4. Each recipe has an href parameter that is an URL pointing to a website with the recipe details. Whenever the user clicks on a recipe use this parameter to open the website in a new view without leaving the app.
5. Offline functionality, each recipe should have a favorite button and clicking it should save the full recipe offline. Create a separate screen and a way to access it to show the favorite recipes.

# Useful links

[Recipe Puppy API Initial Analysis](docs/recipepuppy-api-analysis.md)