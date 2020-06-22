# Zttp

Zttp is a simple `URLSession` wrapper designed to provide a really pleasant development experience for most common use cases.

Inspired on [Zttp](https://github.com/kitetail/zttp) wrapper creared by [Adam Wathan](https://twitter.com/adamwathan).

Like Adam said, real documentation is in the works, but for now [read the tests](https://github.com/martin3zra/zttp/blob/master/Tests/ZttpTests/ZttpTests.swift)

```swift

do {
	let response = try Zttp.get("https://httpbin.org/status/200")

	response->status()
	// Int

	response->isOk()
	// true / false

	// throws an exception if the response is not ok
	if !response.isOk() {
    	throw response.exception()!
    }

    // decode the response directly
    let users : UserFeed = try response.decode()

} catch let err {
	print(err)
	//or
	print((err as! ZttpException).httpError!)
}
```