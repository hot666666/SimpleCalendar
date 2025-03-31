# SimpleCalendar

![image](/assets/image.png)

**SimpleCalendar** is a SwiftUI library that provides a simple calendar view to display data associated with specific dates.

The data must conform to the **Itemable** protocol and is passed to the **SimpleCalendar** view using an object that conforms to the **ItemProviderType** protocol.

## Installation

1. Open Xcode, select File > Add Packages.
2. Add the repository URL:
   ```plain
   https://github.com/hot666666/SimpleCalendar.git
   ```

## Usage Example

1. Create a model that conforms to the **Itemable** protocol.
2. Create an object that conforms to the **ItemProviderType** protocol.
3. Instantiate the **SimpleCalendar** view.

```swift
// Implementing a model that conforms to the Itemable protocol
struct MyItem: Itemable {
	let id: String = UUID().uuidString
	var date: Date
	var content: String
	var color: Color

	init(date: Date, content: String, color: Color) {
		self.date = date
		self.content = content
		self.color = color
	}
}

// Implementing an object that conforms to the ItemProviderType protocol
class MyItemProvider<T: Itemable>: ItemProviderType {
	func read(from: Date, to: Date) -> [Date: [T]] {
        // Implement logic to fetch data and return it
        // ...


// Creating the SimpleCalendar view
struct ContentView: View {
    @StateObject var itemProvider = MyItemProvider<MyItem>()

    var body: some View {
        SimpleCalendar(itemProvider: itemProvider)
    }
}
```

The **read(from:to:)** method in MyItemProvider must return data corresponding to the date range currently displayed in the calendar.

This method is called by the **SimpleCalendar** view, and the data should be returned as a dictionary with dates as keys.

## Supported Platforms

iOS 16.0+

## License

SimpleCalendar is available under the MIT license. See the [LICENSE](LICENSE) file for more information.
