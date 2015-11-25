

# Atlantis
*a  Swift logger framework*

I was inspired by [Dave Wood's](https://www.cerebralgardens.com/) [XCGLogger](https://github.com/DaveWoodCom/XCGLogger), but felt that it was lacking in utility. I took some of his code and added a couple of things and came up with this framework.

#### Installation

Download the ```Atlantis.swift``` file and drop it anywhere in your project folder. Here's the [link](https://github.com/DrewKiino/Atlantis/blob/master/Source/Atlantis/Atlantis.swift), sorry (I know all ya'll are all about that cocoapods tipppp, once I figure that out, I'll get to that asap)

So as of now, I don't really know how to create a cocoapods link using only swift files. I tried for like a whole day but I couldn't get it to work. I heard it's much easier with objective-c. So if anyone can point me to the right direction, I would greatly appreciate it. Please email me at ```andrewaquino118@yahoo.com```.

### What can this do for me?

Let's start of with the basics,

##### Differentiated logging types along with source file, trace, and line number

```swift
log.verose("Hello, World!")

log.info("Hello, World!")

log.warning("Hello, World!")

log.error("Hello, World!")

// 'none' logging type also available
```

Which prints the following...

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-colors.png?raw=true)

Note: the logging framework doesn't print in colors by default, you will have to set as early as you can (preferably in the AppDelegate) like so...

```swift
Atlantis.Configuration.hasColoredLogs = true
```

However, for you to enable colors you will have to firs download the xcode package manager [Alcatraz](http://alcatraz.io/), then after you enable it inside xcode, pull up the package manager itself and install [XCodeColors](https://github.com/robbiehanson/XcodeColors)

#### Customization

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

// using UIColor using only the foreground

Atlantis.Configuration.logColors.debug = Atlantis.XCodeColor(fg: UIColor)

// or using UIColor with both the foreground and background

Atlantis.Configuration.logColors.debug = Atlantis.XCodeColor(fg: UIColor, bg: UIColor)
```





#### 

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