Zttp is HTTP client wrapper on top of `URLSession`, entirely develop in swift for iOS.

This docs was taken of the [Laravel HTTP Client](https://laravel.com/docs/7.x/http-client), that is a first package inspired on [Zttp](https://github.com/kitetail/zttp) created by [Adam Watham](https://twitter.com/adamwathan).

# Making request

To make requests you may use `get`, `post`, `put`, `patch`, and `delete`, you can make a basic `GET` request:

```swift
let response = try Zttp.get("http://test.com")
```

The `get` method returns and instance of `ZttpResponse`, which provide a variety of methods that may be used to inspect the response:
```swift
response.body() -> Data?
response.asDictionary() -> NSDictionary?
response.header(key : String) -> String?
response.headers() -> [String : Any]?
response.status() -> Int
response.isSuccess() -> Bool
response.isOk() -> Bool
response.isRedirect() -> Bool
response.isClientError() -> Bool
response.isUnauthorized() -> Bool
response.isForbidden() -> Bool
response.isServerError() -> Bool
response.toString() -> String?
```

# Request Data

Of course, it is common when using `POST`, `PUT` and `PATCH` to send additional data with you request. So these methods accept an `Dictionary<String, Any>` of data as their second argument. By default, data will be sent using `application/json` content type.

```swift
let response = try Zttp.post("http://test.com/users", params: [
    "name": "Natasha",
    "role": "Designer"
])
```

### GET Request Query Parameters

When making a `GET` request, you may either append a query string to the URL directly or pass and array of key / value pairs as the second argument to the `get` method:

```swift
let response = Zttp.get("http://test.com/users", queryParams: [
    "name": "Alfredo",
    "page": 1
])
```

### Sending Form URL Encoded Requests

If you would like to send data using the `application/z-www-form-urlenconded` content type, you should call the `asFormParams` mehtod before making your request.

```swift
let response = Zttp.asFormParams().post("http://test.com/users", params: [
    "name": "Natasha",
    "role": "CTO"
])
```

### Decode response
You may prefer to decode the response into a `struct` or `Dictionary`, the `struct` need conform the `Decodable` protocol.

```swift
struct User : Codable {
    let uuid: String
    let name: String
}

let response = Zttp.get("http://test.com/users")

// decode the response directly
let users : [User] = try response.decode()
```

# Headers

Headers may be added to requests using the `withHeaders` method, This `withHeaders` method accepts an dictionary of key / value pairs.

```swift
let response = Zttp.withHeaders(headers: [
    "X-Foo": "bar",
    "X-Baz": "quz"
]).post("http://test.com/users", queryParams: [
    "name": "Alfredo",
])
```

# Error Handling

Zttp client wrapper does not throw exceptions on client or server erros (`400` and `500` level responses from servers). You may determine if one of these error was returned using the `isSuccess`, `isClientError` or `isServerError` methods:

```swift
// Determine the actual status code
response.status() -> Int

// Determine if the status code was >= 200 and <300...
response.isSuccess() -> Bool

// Determine if the status code was >= 200 and <300...
response.isOk() -> Bool

// Determine if the response has a 400 level status code...
response.isClientError() -> Bool

// Determine if the response was a 401
response.isUnauthorized() -> Bool

// Determine if the response was a 403
response.isForbidden() -> Bool

// Determine if the response has a 500 level status code...
response.isServerError() -> Bool
```

### Trowing Exceptions

If you have a response instance  and would like to throw an instance of `ZttpException` if the response is a client or server error, you may use the `throw` method:

```swift
let response = Zttp::post(...)

// Throw an exception if a client or server error occurred....
response->throw()
```
# Options

You may specify additional options using the different helpers method.

### URLSession

As developer you may use a custom `URLSession` for you application, you just need to specify the `withSession` method and send you custom `URLSession` as an argument before call the request.

```swift
let session = URLSession.shared

//Do your customization here before send the session as an argument.
let response = Zttp.withSession(session).get("http://test.com")

// The console will get above output.
curl -k -X GET \
-H "Content-Type: application/json" \
http://test.com
```

### Debug current request

Something you would like a cURL of the request that you application are trying to perform, with the `debug` method the request will be printed on the console.

```swift
let response = Zttp.debug().get("http://test.com")

// The console will get above output.
curl -k -X GET \
-H "Content-Type: application/json" \
http://test.com
```

### Accept Header shortcut

You may  specify the `Accept` header for you current request making use of the `accept` method. The Zttp would merge this header with other that you may specify later.

```swift
let response = Zttp.accept(header: "application/json").get("http://test.com")

// The console will get above output.
curl -k -X GET \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
http://test.com
```
