![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/atlantis-logo.png?raw=true)

# A swift logging framework.

I was inspired by [Dave Wood's](https://www.cerebralgardens.com/) [XCGLogger](https://github.com/DaveWoodCom/XCGLogger), but felt that it was lacking in utility and some key attributes that xcode's native ```print()``` function had. I took some of his code and added a couple of things and came up with this framework. If you liked this framework, please star this repo! It would definitely motivate me to keep adding. Also, anyone willing to contribute please let me know at ```andrewaquino118@yahoo.com```.

### Installation

Here's the [link](https://github.com/DrewKiino/Atlantis/blob/master/Source), right click and save ```Atlantis.swift``` and drop it anywhere in your project folder. Sorry (I know all ya'll are all about that cocoapods tipppp, once I figure that out, I'll get to that asap)

So as of now, I don't really know how to create a cocoapods link using only swift files. I tried for like a whole day but I couldn't get it to work. I heard it's much easier with objective-c. So if anyone can point me to the right direction, I would greatly appreciate it.

## What can this do for me?

###  Log Levels
This includes the stamp trace of the source file, function name, and line number.

```swift

// I suggest initializing this variable in the global instance, 
// it's memory leak free and it won't do anything crazy since 
// I know some of you hate Singleton designs ;) 
// It's a logger framework people.

let log = Atlantis.Logger()

log.verbose("Hello, World!")

log.info("Hello, World!")

log.warning("Hello, World!")

log.debug("Hello, World!")

log.error("Hello, World!")
```

Which prints the following...

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-colors.png?raw=true)

*Note*: ```.None``` log type is also available as a log level configuration, use this when your app goes on production. Atlantis will skip all code execution if need be.

*Note*: the logging framework doesn't print its logs in colors by default, if you want colors, you will need to set the configuration somewhere in your code, preferably during app launch in your ```AppDelegate.swift```, like so...

```swift
Atlantis.Configuration.hasColoredLogs = true
```

However, for you to enable log colors you will have to first download the xcode package manager [Alcatraz](http://alcatraz.io/) and enable it inside xcode. Pull up the package manager afterwards and install [XCodeColors](https://github.com/robbiehanson/XcodeColors)

### Input Agnostic

Besides printing regular data types like ```String``` or ```Int```, with ```Atlantis```, you can do the following: 

* **nil's**

```swift
let doIExist: String? = nil

log.warning(doIExist)
```

```Atlantis``` will safely unwrap any optionals then print as 'nil' if necessary.

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-nil.png?raw=true)

* **objects or classes**

```swift
public class Dog {
  var name = "Doug"
}

log.debug(Dog())
```

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-dog.png?raw=true)

* **arrays**

```swift
let array: [String] = ["Dog", "Cat"]

log.info(array)
```

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-array.png?raw=true)

* **arrays of arrays**

```swift
let arraysOfArrays: [[Int]] = [[0, 1, 2], [3, 4], [5]]

log.info(arrayOfArrays)
```

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-array-of-arrays.png?raw=true)

yes, it pretty prints nested arrays ;)

* **almost anything really**

```swift
log.debug("Hello, World", 010101, 0.001, ["Hello", "World"], ["Cat", ["Mouse", "Rat"]])
```

```Atlantis``` will re-iterate through each input and conveniently print each one, along with pretty printing parsable nested types.

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-agnostic-types.png?raw=true)

### ```.Tap```
An ```Atlantis``` extension that allows you to print like how you would regularly do, but will return the value of the input.

```
func add(x: Int, _ y: Int) -> Int { return x + y }

let addXY = log.tap.debug(add(3, 5))
```

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-tap-print-add.png?raw=true)

Normal extensions such as ```.Verbose``` etc. are also under ```.Tap```

### Compatible with ```Promises```

using [PromiseKit](https://github.com/mxcl/PromiseKit) more specifically...

```swift
func promise() -> Promise<String> {
  return Promise { fulfill, reject in
    // blah blah
    fulfill("Hello from server!")
  }
}

promise()
.then { log.tap($0) }
.then { reply in
  // blah blah
}
.catch { log.error($0) }
```

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-tap-print-promise.png?raw=true)

*Note*: that ```.Tap``` only takes in single inputs.

### Customization

The ```Atlantis.Configuration``` houses configuration variables that allow you change the behaviour of the logger. The following behaviours can be configured and their defaults are as follows...

```swift
.logLevel = .Verbose
.hasColoredLogs = false
.hasWhiteBackground = false
.showExtraInfo = true
.logColors = { .Purple, .Green, .Yellow, .Blue, .Red }
```

Other colors configurations include ```black, blue, darkGreen, darkGrey, lightGrey, orange, white, and whiteOnRed```

You can even create your own colors and specify the foreground and background...

```swift

// using a Tuple initializer

Atlantis.Configuration.logColors.debug = Atlantis.XCodeColor(fg: (Int, Int, Int)>, bg: <(Int, Int, Int)>)

// using UIColor setting only the foreground

Atlantis.Configuration.logColors.debug = Atlantis.XCodeColor(fg: UIColor)

// or using UIColor setting both the foreground and background

Atlantis.Configuration.logColors.debug = Atlantis.XCodeColor(fg: UIColor, bg: UIColor)
```

###To Do
1. ~~create a logging framework~~
2. ~~add color customization~~
3. print to a text file when used on a device
4. pretty print json types from server responses

### License
The MIT License (MIT)

Copyright (c) 2015 Andrew Aquino http://drewkiino.github.io/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.