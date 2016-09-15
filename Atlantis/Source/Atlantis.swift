//
//  Atlantis.swift
//  Atlantis
//
//  Created by Andrew Aquino on 9/29/15.
//  Copyright © 2015 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBeaver

public struct Atlantis {
  
  private static let sbLog = SwiftyBeaver.self
  
  public enum LogLevel: Int {
    case Verbose  = 5
    case Info     = 4
    case Warning  = 3
    case Debug    = 2
    case Error    = 1
    case None     = 0
  }
  
  public struct Configuration {
    
    // Reserved Variables
    private struct Reserved {
      private static let ESCAPE = "\u{001b}["
      private static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
      private static let RESET_BG = ESCAPE + "bg;" // Clear any background color
      private static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    }
    
    // Color Configurations
    public struct logColors {
      
      private static var _verbose: XCodeColor = XCodeColor.purple
      public static var verbose: XCodeColor? {
        get { return _verbose }
        set {
          if let newValue = newValue {
            _verbose = newValue
          } else {
            _verbose = XCodeColor.purple
          }
        }
      }
      
      private static var _info: XCodeColor = XCodeColor.green
      public static var info: XCodeColor? {
        get { return _info }
        set {
          if let newValue = newValue {
            _info = newValue
          } else {
            _info = XCodeColor.green
          }
        }
      }
      
      private static var _warning: XCodeColor = XCodeColor.yellow
      public static var warning: XCodeColor? {
        get { return _warning }
        set {
          if let newValue = newValue {
            _warning = newValue
          } else {
            _warning = XCodeColor.yellow
          }
        }
      }
      
      private static var _debug: XCodeColor = XCodeColor.blue
      public static var debug: XCodeColor? {
        get { return _debug}
        set {
          if let newValue = newValue {
            _debug = newValue
          } else {
            _debug = XCodeColor.blue
          }
        }
      }
      
      private static var _error: XCodeColor = XCodeColor.red
      public static var error: XCodeColor? {
        get { return _error}
        set {
          if let newValue = newValue {
            _error = newValue
          } else {
            _error = XCodeColor.red
          }
        }
      }
    }
    
    // configured log level
    public static var logLevel: LogLevel = .Verbose
    
    public static var hasWhiteBackground: Bool = false
    
    public static var hasColoredLogs: Bool = false
    
    public static var hasColoredPrints: Bool = false
    
    public static var showExtraInfo: Bool = true
    
    public static var filteredErrorCodes: [Int] = [-999]
    
    public static var highlightsErrors: Bool = false
    
    public static var coloredLogLevels: [Atlantis.LogLevel] = [.Verbose, .Info, .Warning, .Debug, .Error]
    
    public static var alignmentThreshold: Int = 5
    
    public static func integrateWithSwiftyBeaver(appID: String, appSecret: String, encryptionKey: String) {
      let cloud = SBPlatformDestination(appID: appID, appSecret: appSecret, encryptionKey: encryptionKey)
      switch Atlantis.Configuration.logLevel {
      case .Verbose:
        cloud.minLevel = .Verbose
        break
      case .Info:
        cloud.minLevel = .Info
        break
      case .Warning:
        cloud.minLevel = .Warning
        break
      case .Debug:
        cloud.minLevel = .Debug
        break
      case .Error:
        cloud.minLevel = .Error
        break
      case .None: // skip integration if log level is none
        return
      }
      Atlantis.sbLog.addDestination(cloud)
      Atlantis.Configuration._integrateWithSwiftyBeaver = true
      Atlantis.Configuration.appID = appID
      Atlantis.Configuration.appSecret = appSecret
      Atlantis.Configuration.encryptionKey = encryptionKey
    }
    
    private static var appID: String?
    private static var appSecret: String?
    private static var encryptionKey: String?
    private static var _integrateWithSwiftyBeaver: Bool = false
  }
  
  private struct Singleton {
    private static let LogQueue = dispatch_queue_create("Atlantis.LogQueue", nil)
  }
  
  public struct XCodeColor {
    
    private static let escape = "\u{001b}["
    private static let resetFg = "\u{001b}[fg;"
    private static let resetBg = "\u{001b}[bg;"
    private static let reset = "\u{001b}[;"
    
    private var fg: (Int, Int, Int)? = nil
    private var bg: (Int, Int, Int)? = nil
    
    private mutating func whiteBG() -> XCodeColor {
      if Configuration.hasWhiteBackground {
        bg = (255, 255, 255)
      }
      return self
    }
    
    private mutating func forceWhiteBG() -> XCodeColor {
      bg = (255, 255, 255)
      return self
    }
    
    private func format() -> String {
      
      var format = ""
      
      if fg == nil && bg == nil {
        // neither set, return reset value
        return XCodeColor.reset
      }
      
      if let fg = fg {
        format += "\(XCodeColor.escape)fg\(fg.0),\(fg.1),\(fg.2);"
      }
      else {
        format += XCodeColor.resetFg
      }
      
      if let bg = bg {
        format += "\(XCodeColor.escape)bg\(bg.0),\(bg.1),\(bg.2);"
      }
      else {
        format += XCodeColor.resetBg
      }
      
      return format
    }
    
    public init(fg: (Int, Int, Int)? = nil, bg: (Int, Int, Int)? = nil) {
      self.fg = fg
      self.bg = bg
    }
    
    #if os(iOS)
    public init(fg: UIColor, bg: UIColor? = nil) {
    var redComponent: CGFloat = 0
    var greenComponent: CGFloat = 0
    var blueComponent: CGFloat = 0
    var alphaComponent: CGFloat = 0
    
    fg.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha:&alphaComponent)
    self.fg = (Int(redComponent * 255), Int(greenComponent * 255), Int(blueComponent * 255))
    if let bg = bg {
    bg.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha:&alphaComponent)
    self.bg = (Int(redComponent * 255), Int(greenComponent * 255), Int(blueComponent * 255))
    }
    else {
    self.bg = nil
    }
    }
    #else
    public init(fg: NSColor, bg: NSColor? = nil) {
      if let fgColorSpaceCorrected = fg.colorUsingColorSpaceName(NSCalibratedRGBColorSpace) {
        self.fg = (Int(fgColorSpaceCorrected.redComponent * 255), Int(fgColorSpaceCorrected.greenComponent * 255), Int(fgColorSpaceCorrected.blueComponent * 255))
      }
      else {
        self.fg = nil
      }
      
      if let bg = bg,
        let bgColorSpaceCorrected = bg.colorUsingColorSpaceName(NSCalibratedRGBColorSpace) {
        
        self.bg = (Int(bgColorSpaceCorrected.redComponent * 255), Int(bgColorSpaceCorrected.greenComponent * 255), Int(bgColorSpaceCorrected.blueComponent * 255))
      }
      else {
        self.bg = nil
      }
    }
    #endif
    
    public static let red: XCodeColor = {
      return XCodeColor(fg: (255, 0, 0))
    }()
    
    public static let green: XCodeColor = {
      return XCodeColor(fg: (0, 255, 0))
    }()
    
    public static let blue: XCodeColor = {
      // actual blue is 0, 0, 255
      // dodger blue
      return XCodeColor(fg: (30, 144, 255))
    }()
    
    public static let black: XCodeColor = {
      return XCodeColor(fg: (0, 0, 0))
    }()
    
    public static let white: XCodeColor = {
      return XCodeColor(fg: (255, 255, 255))
    }()
    
    public static let lightGrey: XCodeColor = {
      return XCodeColor(fg: (211, 211, 211))
    }()
    
    public static let darkGrey: XCodeColor = {
      return XCodeColor(fg: (169, 169, 169))
    }()
    
    public static let orange: XCodeColor = {
      return XCodeColor(fg: (255, 165, 0))
    }()
    
    public static let whiteOnRed: XCodeColor = {
      return XCodeColor(fg: (255, 255, 255), bg: (255, 0, 0))
    }()
    
    public static let darkGreen: XCodeColor = {
      return XCodeColor(fg: (0, 128, 0))
    }()
    
    public static let purple: XCodeColor = {
      return XCodeColor(fg: (160, 32, 240))
    }()
    
    public static let yellow: XCodeColor = {
      return XCodeColor(fg: (255, 255, 0))
    }()
  }
  
  public struct Logger {
    
    private let logQueue = Singleton.LogQueue
    private typealias closure = () -> Void
    private typealias void = Void
    private static var maxCharCount: Int = 0
    private static var smallerCountOccurances: Int = 0
    
    public init() {}
    
    private struct LogSettings {
      
      private var logLevel: LogLevel
      private var functionName: String
      private var fileName: String
      private var lineNumber: Int
      
      init(logLevel: LogLevel, _ functionName: String, _ fileName: String, _ lineNumber: Int) {
        self.logLevel = logLevel
        self.functionName = functionName
        self.fileName = fileName
        self.lineNumber = lineNumber
      }
      
      private func sourceString() -> String {
        if Configuration.showExtraInfo {
          
          let array = fileName.componentsSeparatedByString("/")
          var name: String = ""
          if let string = array.last {
            name = string
          }
          
          // date
          let date = NSDate()
          let formatter = NSDateFormatter()
          formatter.dateStyle = .ShortStyle
          formatter.timeStyle = .ShortStyle
          formatter.timeZone = NSTimeZone(name: "PT")
          let dateString = formatter.stringFromDate(date)
          
          let string = "[\(name)/\(functionName)/line:\(lineNumber)] @ \(dateString)"
          return string + " "
        }
        return ""
      }
    }
    
    private static func acceptableLogLevel(logSettings: Atlantis.Logger.LogSettings) -> Bool {
      return logSettings.logLevel.rawValue <= Atlantis.Configuration.logLevel.rawValue
    }
    
    public let tap = Tap()
    
    public struct Tap {
      
      public func verbose<T>(arg: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> T {
        dispatch_async(Singleton.LogQueue) {
          let logSettings = LogSettings(logLevel: .Verbose, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func info<T>(arg: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> T {
        dispatch_async(Singleton.LogQueue) {
          let logSettings = LogSettings(logLevel: .Info, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func warning<T>(arg: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> T {
        dispatch_async(Singleton.LogQueue) {
          let logSettings = LogSettings(logLevel: .Warning, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func debug<T>(arg: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> T {
        dispatch_async(Singleton.LogQueue) {
          let logSettings = LogSettings(logLevel: .Debug, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func error<T>(arg: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> T {
        dispatch_async(Singleton.LogQueue) {
          let logSettings = LogSettings(logLevel: .Error, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
    }
    
    public func verbose<T>(args: T?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      dispatch_async(logQueue) {
        let logSettings = LogSettings(logLevel: .Verbose, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func info<T>(args: T?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      dispatch_async(logQueue) {
        let logSettings = LogSettings(logLevel: .Info, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func warning<T>(args: T?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      dispatch_async(logQueue) {
        let logSettings = LogSettings(logLevel: .Warning, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func debug<T>(args: T?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      dispatch_async(logQueue) {
        let logSettings = LogSettings(logLevel: .Debug, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func error<T>(args: T?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      dispatch_async(logQueue) {
        let logSettings = LogSettings(logLevel: .Error, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    private static func getEscapeString() -> String {
      return Configuration.Reserved.ESCAPE
    }
    
    private static func getResetString() -> String {
      return Configuration.Reserved.RESET
    }
    
    private static func getRGBString(logLevel: LogLevel) -> String {
      if Configuration.hasColoredLogs {
        switch logLevel {
        case .Verbose:
          if Atlantis.Configuration.coloredLogLevels.contains(.Verbose) {
            return Configuration.logColors._verbose.whiteBG().format()
          }
          break
        case .Info:
          if Atlantis.Configuration.coloredLogLevels.contains(.Info) {
            return Configuration.logColors._info.whiteBG().format()
          }
          break
        case .Warning:
          if Atlantis.Configuration.coloredLogLevels.contains(.Warning) {
            return Configuration.logColors._warning.whiteBG().format()
          }
          break
        case .Debug:
          if Atlantis.Configuration.coloredLogLevels.contains(.Debug) {
            return Configuration.logColors._debug.whiteBG().format()
          }
          break
        case .Error:
          if Atlantis.Configuration.coloredLogLevels.contains(.Error) {
            return Configuration.logColors._error.whiteBG().format()
          }
          break
        case .None:
          break
        }
      } else if Configuration.highlightsErrors {
        switch logLevel {
        case .Error:
          return Configuration.logColors._error.whiteBG().format()
        default:
          break
        }
      }
      return ""
    }
    
    private static func getLogLevelString(logLevel: LogLevel) -> String {
      let level: String = "\(logLevel)"
      let tab1: String = ": "
      let tab2: String = ":    "
      let tab3: String = ":   "
      switch logLevel {
      case .Verbose:  return level + tab1
      case .Info:     return level + tab2
      case .Warning:  return level + tab1
      case .Debug:    return level + tab3
      case .Error:    return level + tab3
      case .None:     return level
      }
    }
    
    
    private static func toPrettyJSONString(object: AnyObject) -> String? {
      do {
        if NSJSONSerialization.isValidJSONObject(object) {
          let data = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
          if let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            return "\n" + string
          }
        }
        throw NSError(domain: "unable to parse json object", code: 400, userInfo: nil)
      }
      catch { return nil }
    }
    
    private static func addDash(x: Any) -> String {
      let string = "\(x)"
      if Configuration.showExtraInfo {
        return "- " + (string.isEmpty ? "\"\"" : string)
      }
      return string
    }
    
    private static func calculateLegibleWhitespace(log: String, startString: String, endString: String, logLevel: LogLevel) -> String {
      
      let charCount = startString.debugDescription.characters.count
      
      
      maxCharCount = maxCharCount > charCount ? maxCharCount : charCount
      
      smallerCountOccurances = (charCount < maxCharCount) ? (smallerCountOccurances + 1) : 0
      
      if smallerCountOccurances > Atlantis.Configuration.alignmentThreshold {
        
        return log + endString
        
      } else {
        
        var whitespace: String = ""
        
        if maxCharCount - charCount > 0 {
          for _ in 0 ..< maxCharCount - charCount {
            whitespace += " "
          }
        }
        
        let string: String = log + whitespace + endString
        
        return string
      }
    }
    
    private static func log<T>(x: T?, _ logSettings: LogSettings) {
      let logLevel = logSettings.logLevel
      var jsonString: String? = nil
      switch x {
        // arrays
      case .Some(is NSArray): jsonString = toPrettyJSONString(NSObject.reflect(objects: x as! NSArray)); break
        // dictionaries
      case .Some(is NSDictionary): jsonString = toPrettyJSONString(x as! NSDictionary) ?? "\n\(x!)"; break
      case .Some(is [String: AnyObject]): jsonString = toPrettyJSONString(x as! [String: AnyObject]) ?? "\n\(x!)"; break
        // errors
      case .Some(is NSError):
        let error = x as! NSError
        
        // filter out errors based in filtered error code configurations
        if Atlantis.Configuration.filteredErrorCodes.contains(error.code) { return }
        
        let properties: [String: AnyObject] = [
          "domain": error.domain,
          "code": error.code,
          "localizedDescription": error.localizedDescription,
          "userInfo": error.userInfo
        ]
        
        jsonString = toPrettyJSONString(properties)
        
        break
        // objects
      case .Some(is Any):
        let dictionary = NSObject.reflect(object: x!)
        if !dictionary.isEmpty { jsonString = toPrettyJSONString(dictionary) }
        break
      default: break
      }
      
      var unwrap: Any = x ?? "nil"
      unwrap = jsonString ?? addDash(unwrap)
      
      let color = getRGBString(logLevel)
      let reset = getResetString()
      let level = getLogLevelString(logLevel)
      let source = logSettings.sourceString()
      let string = "\(unwrap)"
      let coloredString: String = Atlantis.Configuration.hasColoredPrints ? (color + string + reset) : string

      let log: String = "\(color)\(level)\(reset)\(source)"
      
      let prettyLog: String = calculateLegibleWhitespace(log, startString: "\(level)\(source)", endString: coloredString, logLevel: logLevel)
      
      // swifty beaver integration
      // https://github.com/SwiftyBeaver/SwiftyBeaver
      if Atlantis.Configuration._integrateWithSwiftyBeaver {
        let sbLog = "\(level)\(source)\(string)"
        switch logLevel {
        case .Verbose:
          Atlantis.sbLog.verbose(sbLog)
          break
        case .Info:
          Atlantis.sbLog.info(sbLog)
          break
        case .Warning:
          Atlantis.sbLog.warning(sbLog)
          break
        case .Debug:
          Atlantis.sbLog.debug(sbLog)
          break
        case .Error:
          Atlantis.sbLog.error(sbLog)
          break
        case .None:
          break
        }
      }
      
      dispatch_async(dispatch_get_main_queue()) { print(prettyLog) }
    }
  }
}

extension NSObject {
  
  private class func reflect(objects objects: NSArray) -> [AnyObject] {
    return objects.map { value -> AnyObject in
      
      // strings
      if let value = value as? String { return value }
      else  if let value = value as? [String] { return value }
        
      // booleans
      else if value is Bool { return value }
        
        // numbers
      else if let value = value as? Int { return value }
      else if let value = value as? [Int] { return value }
      else if let value = value as? Float { return value }
      else if let value = value as? [Float] { return value }
      else if let value = value as? Double { return value }
      else if let value = value as? [Double] { return value }
        
        // dictionaries
      else if let value = value as? NSDictionary { return value }
      else if let value = value as? [String: AnyObject] { return value }
        
        // objects
      else { return NSObject.reflect(object: value) }
    }
  }
  
  private class func reflect<T>(object object: T) -> [String: AnyObject] {
    var dictionary: [String: AnyObject] = [:]
    
    Mirror(reflecting: object).children.forEach { label, value in
      
      // strings
      if let key = label, value = value as? String { dictionary.updateValue(value, forKey: key) }
      else  if let key = label, value = value as? [String] { dictionary.updateValue(value, forKey: key) }
        
        // numbers
      else if let key = label, value = value as? Int { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? [Int] { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? Float { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? [Float] { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? Double { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? [Double] { dictionary.updateValue(value, forKey: key) }
        
        // booleans
      else if let key = label, value = value as? Bool { dictionary.updateValue(value, forKey: key) }
      else if let key = label, value = value as? [Bool] { dictionary.updateValue(value, forKey: key) }
        
        // dictionaries
      else if let key = label, value = value as? [String: AnyObject] { dictionary.updateValue(value, forKey: key) }
        
        // objects
      else if let key = label, value = value as? T { dictionary.updateValue(NSObject.reflect(object: value), forKey: key) }
      else if let key = label, value = value as? [T] { dictionary.updateValue(value.map { NSObject.reflect(object: $0) }, forKey: key) }
      else if let key = label, value = value as? NSArray { dictionary.updateValue(value.map { NSObject.reflect(object: $0) } as [AnyObject] , forKey: key) }
      else if let key = label { dictionary.updateValue(NSObject.reflect(object: value), forKey: key) }
    }
    
    return dictionary
  }
}

