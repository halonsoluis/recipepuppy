#### For the analysis of the API has been used the vscode extension "Rest Client" and the app Insomnia

# Base Search API
**GET** http://www.recipepuppy.com/api/

## Optional Parameters:

- `i`: comma delimited ingredients
- `q` : normal search query
- `p` : page

###
**GET** http://www.recipepuppy.com/api/?i=onions,garlic&p=2

## Example Result
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

## Observations

- String content received needs to be trimmed. (`"Roasted Garlic Grilling Sauce\r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\t\r\n\t\r\n\t\r\n\r\n"`)
- Result is with the form
    {
       "title": String,
        "href": String,
        "ingredients": String (comma separated),
        "thumbnail": String,
    }

- The API is not stable, for some cases, for example, asking for the second page produces a 500 error and returns a "404 File Not Found" html file
    
###
**GET** http://www.recipepuppy.com/api/?i=onions,garlic&q=&p=2

   While asking for the 3 page produces results:
    
###
**GET** http://www.recipepuppy.com/api/?i=onions,garlic&q=&p=101

- Pagination
    - In some cases empty result sets are received for one page and for the next one, actual results are returned.
    - There's no documented way to know for the amount of pages available. The API just return:
    - It would be needed to try to fetch a couple of pages in advance before reporting as finished the list of recipes
  ```json
    {
    "title": "Recipe Puppy",
    "version": 0.1,
    "href": "http:\/\/www.recipepuppy.com\/",
    "results": []
    }
    ```

# Suggested SWIFT code generated by Insomnia:

```Swift
import Foundation

let headers = ["cookie": "kohanasession=e909dfa8c2c276ce600b12741d2a4b51; kohanasession_data=c2Vzc2lvbl9pZHxzOjMyOiJlOTA5ZGZhOGMyYzI3NmNlNjAwYjEyNzQxZDJhNGI1MSI7dG90YWxfaGl0c3xpOjg7X2tmX2ZsYXNoX3xhOjA6e311c2VyX2FnZW50fHM6MTQ6Imluc29tbmlhLzcuMC4zIjtpcF9hZGRyZXNzfHM6MTQ6Ijg0LjE5NC4yMjMuMjM2IjtsYXN0X2FjdGl2aXR5fGk6MTU3NDYyODExMjs%253D"]

let postData = NSData(data: "".data(using: String.Encoding.utf8)!)

let request = NSMutableURLRequest(url: NSURL(string: "http://www.recipepuppy.com/api/?i=onions%2Cgarlic&p=1")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
request.httpMethod = "GET"
request.allHTTPHeaderFields = headers
request.httpBody = postData as Data

let session = URLSession.shared
let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    if (error != nil) {
        print(error)
    } else {
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse)
    }
})

dataTask.resume()
```