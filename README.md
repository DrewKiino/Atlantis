

# Atlantis
*a  Swift logger framework*

I was inspired by [Dave Wood's](https://www.cerebralgardens.com/) [XCGLogger](https://github.com/DaveWoodCom/XCGLogger), but felt that it was lacking in utility. I took some of his code and added a couple of things and came up with this framework.

### What can this do for me?

Let's start of with the basics,

##### Differentiated logging types along with source file, trace, and line number

![alt tag](https://github.com/DrewKiino/Atlantis/blob/master/Images/log-print-colors.png?raw=true)

```swift
log.verose("Hello, World!")

log.info("Hello, World!")

log.warning("Hello, World!")

log.error("Hello, World!")

// none logging type also available
```

Note: the logging framework doesn't print in colors by default, you will have to set as early as you can (preferably in the AppDelegate) like so...
```swift
Atlantis.Configuration.hasColoredLogs = true
```
However, for you to enable colors you will have to firs download the xcode package manager [Alcatraz](http://alcatraz.io/), then after you enable it inside xcode, pull up the package manager itself and install [XCodeColors](https://github.com/robbiehanson/XcodeColors)

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