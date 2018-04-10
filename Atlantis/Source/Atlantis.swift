//
//  Atlantis.swift
//  Atlantis
//
//  Created by Andrew Aquino on 9/29/15.
//  Copyright © 2015 Andrew Aquino. All rights reserved.
//
import Foundation
import UIKit
import CoreData

public let log = Atlantis.Logger()

@objc
public class Atlantis: NSObject {
  
  @objc
  public static var logger: Atlantis.Logger { get { return log } }
  
  public enum LogLevel: Int {
    case verbose  = 5
    case info     = 4
    case warning  = 3
    case debug    = 2
    case error    = 1
    case none     = 0
  }
  
  @objc
  public class Configuration: NSObject {
    
    // Reserved Variables
    fileprivate struct Reserved {
      fileprivate static let ESCAPE = "\u{001b}["
      fileprivate static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
      fileprivate static let RESET_BG = ESCAPE + "bg;" // Clear any background color
      fileprivate static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    }
    
    // Color Configurations
    public struct logColors {
      
      fileprivate static var _verbose: XCodeColor = XCodeColor.purple
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
      
      fileprivate static var _info: XCodeColor = XCodeColor.green
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
      
      fileprivate static var _warning: XCodeColor = XCodeColor.yellow
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
      
      fileprivate static var _debug: XCodeColor = XCodeColor.blue
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
      
      fileprivate static var _error: XCodeColor = XCodeColor.red
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
    public static var logLevel: LogLevel = .verbose
    
    public static var hasWhiteBackground: Bool = false
    
    public static var hasColoredLogs: Bool = false
    
    public static var hasColoredPrints: Bool = false
    
    public static var showExtraInfo: Bool = true
    
    public static var filteredErrorCodes: [Int] = [-999]
    
    public static var highlightsErrors: Bool = false
    
    public static var coloredLogLevels: [Atlantis.LogLevel] = [.verbose, .info, .warning, .debug, .error]
    
    public static var alignmentThreshold: Int = 5
  }
  
  fileprivate struct Singleton {
    fileprivate static let LogQueue = DispatchQueue(label: "Atlantis.LogQueue")
  }
  
  public struct XCodeColor {
    
    fileprivate static let escape = "\u{001b}["
    fileprivate static let resetFg = "\u{001b}[fg;"
    fileprivate static let resetBg = "\u{001b}[bg;"
    fileprivate static let reset = "\u{001b}[;"
    
    fileprivate var fg: (Int, Int, Int)? = nil
    fileprivate var bg: (Int, Int, Int)? = nil
    
    fileprivate mutating func whiteBG() -> XCodeColor {
      if Configuration.hasWhiteBackground {
        bg = (255, 255, 255)
      }
      return self
    }
    
    fileprivate mutating func forceWhiteBG() -> XCodeColor {
      bg = (255, 255, 255)
      return self
    }
    
    fileprivate func format() -> String {
      
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
  
  @objc
  public class Logger: NSObject {
    
    fileprivate let logQueue = Singleton.LogQueue
    fileprivate
    typealias closure = () -> Void
    fileprivate typealias void = Void
    fileprivate static var maxCharCount: Int = 0
    fileprivate static var smallerCountOccurances: Int = 0
    
    fileprivate struct LogSettings {
      
      fileprivate var logLevel: LogLevel
      fileprivate var functionName: String
      fileprivate var fileName: String
      fileprivate var lineNumber: Int
      
      init(logLevel: LogLevel, _ functionName: String, _ fileName: String, _ lineNumber: Int) {
        self.logLevel = logLevel
        self.functionName = functionName
        self.fileName = fileName
        self.lineNumber = lineNumber
      }
      
      fileprivate func sourceString() -> String {
        if Configuration.showExtraInfo {
          
          let array = fileName.components(separatedBy: "/")
          var name: String = ""
          if let string = array.last {
            name = string
          }
          
          // date
          let date = Date()
          let formatter = DateFormatter()
          formatter.dateStyle = .short
          formatter.timeStyle = .short
          formatter.timeZone = TimeZone(identifier: "PT")
          let dateString = formatter.string(from: date)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "@")
          
          let string = "\(dateString)/\(name)/\(functionName)/line:\(lineNumber)"
          
          return string
        }
        return ""
      }
    }
    
    fileprivate static func acceptableLogLevel(_ logSettings: Atlantis.Logger.LogSettings) -> Bool {
      return logSettings.logLevel.rawValue <= Atlantis.Configuration.logLevel.rawValue
    }
    
    public let tap = Tap()
    
    public struct Tap {
      
      public func verbose(_ arg: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Any {
        Singleton.LogQueue.async {
          let logSettings = LogSettings(logLevel: .verbose, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func info(_ arg: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Any {
        Singleton.LogQueue.async {
          let logSettings = LogSettings(logLevel: .info, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func warning(_ arg: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Any {
        Singleton.LogQueue.async {
          let logSettings = LogSettings(logLevel: .warning, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func debug(_ arg: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Any {
        Singleton.LogQueue.async {
          let logSettings = LogSettings(logLevel: .debug, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
      
      public func error(_ arg: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Any {
        Singleton.LogQueue.async {
          let logSettings = LogSettings(logLevel: .error, functionName,fileName, lineNumber)
          if Logger.acceptableLogLevel(logSettings) {
            Logger.log(arg, logSettings)
          }
        }
        return arg
      }
    }
    
    public func verbose(_ args: Any?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      logQueue.async {
        let logSettings = LogSettings(logLevel: .verbose, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func info(_ args: Any?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      logQueue.async {
        let logSettings = LogSettings(logLevel: .info, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func warning(_ args: Any?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      logQueue.async {
        let logSettings = LogSettings(logLevel: .warning, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func debug(_ args: Any?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      logQueue.async {
        let logSettings = LogSettings(logLevel: .debug, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    public func error(_ args: Any?..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      logQueue.async {
        let logSettings = LogSettings(logLevel: .error, functionName,fileName, lineNumber)
        if Logger.acceptableLogLevel(logSettings) {
          for arg in args {
            Logger.log(arg, logSettings)
          }
        }
      }
    }
    
    fileprivate static func getEscapeString() -> String {
      if Configuration.hasColoredLogs { return Configuration.Reserved.ESCAPE }
      else { return "" }
    }
    
    fileprivate static func getResetString() -> String {
      if Configuration.hasColoredLogs { return Configuration.Reserved.RESET }
      else { return "" }
    }
    
    fileprivate static func getRGBString(_ logLevel: LogLevel) -> String {
      if Configuration.hasColoredLogs {
        switch logLevel {
        case .verbose:
          if Atlantis.Configuration.coloredLogLevels.contains(.verbose) {
            return Configuration.logColors._verbose.whiteBG().format()
          }
          break
        case .info:
          if Atlantis.Configuration.coloredLogLevels.contains(.info) {
            return Configuration.logColors._info.whiteBG().format()
          }
          break
        case .warning:
          if Atlantis.Configuration.coloredLogLevels.contains(.warning) {
            return Configuration.logColors._warning.whiteBG().format()
          }
          break
        case .debug:
          if Atlantis.Configuration.coloredLogLevels.contains(.debug) {
            return Configuration.logColors._debug.whiteBG().format()
          }
          break
        case .error:
          if Atlantis.Configuration.coloredLogLevels.contains(.error) {
            return Configuration.logColors._error.whiteBG().format()
          }
          break
        case .none:
          break
        }
      } else if Configuration.highlightsErrors {
        switch logLevel {
        case .error:
          return Configuration.logColors._error.whiteBG().format()
        default:
          break
        }
      }
      return ""
    }
    
    fileprivate static func getLogLevelString(_ logLevel: LogLevel) -> String {
      let level: String = "\(logLevel)"
      let tab1: String = ": "
      let tab2: String = ":    "
      let tab3: String = ":   "
      switch logLevel {
      case .verbose:  return level + tab1
      case .info:     return level + tab2
      case .warning:  return level + tab1
      case .debug:    return level + tab3
      case .error:    return level + tab3
      case .none:     return level
      }
    }
    
    
    fileprivate static func toPrettyJSONString(_ object: Any?) -> String? {
      guard let object = object else { return nil }
      do {
        if JSONSerialization.isValidJSONObject(object) {
          let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
          if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
            return "\n" + string
          }
        }
        throw NSError(domain: "unable to parse json object", code: 400, userInfo: nil)
      }
      catch { return nil }
    }
    
    fileprivate static func addDash(_ value: Any?) -> String {
      var string = "nil"
      if let value = value { string = "\(value)" }
      if Configuration.showExtraInfo { return "- " + (string.isEmpty ? "\"\"" : string) }
      return string
    }
    
    fileprivate static func calculateLegibleWhitespace(_ log: String, startString: String, endString: String, logLevel: LogLevel) -> String {
      
      let charCount = startString.debugDescription.count
      
      maxCharCount = maxCharCount > charCount ? maxCharCount : charCount
      
      smallerCountOccurances = (charCount < maxCharCount) ? (smallerCountOccurances + 1) : 0
      
      if smallerCountOccurances > Atlantis.Configuration.alignmentThreshold {
        
        maxCharCount = 0 // reset the max char count
        
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
    
    fileprivate static func log(_ value: Any?, _ logSettings: LogSettings) {
      // get the type name
      var type: String!; if let value = value {
        type = String(describing: Mirror(reflecting: value).subjectType).trimmingCharacters(in: CharacterSet.letters.inverted)
      }; type = type ?? ""
      
      let logLevel = logSettings.logLevel
      var jsonString: String? = nil
      
      if let value = value {
        switch value {
        // regular data types
        case _ as Int: break
        case _ as Double: break
        case _ as Float: break
        case _ as String: break
        case _ as Bool: break
        // arrays
        case let array as NSArray: jsonString = toPrettyJSONString(NSObject.reflect(objects: array)); break
        // dictionaries
        case let dict as NSDictionary: jsonString = toPrettyJSONString(dict) ?? "\n\(dict)"; break
        // errors
        case let error as NSError:
          
          // filter out errors based in filtered error code configurations
          if Atlantis.Configuration.filteredErrorCodes.contains(error.code) { return }
          
          let properties: [String: Any] = [
            "domain": error.domain,
            "code": error.code,
            "localizedDescription": error.localizedDescription,
            "userInfo": error.userInfo
          ]
          
          jsonString = toPrettyJSONString(properties)
          
          break
        // objects
        case let object as NSObject:
          let dictionary = NSObject.reflect(object: object)
          if !dictionary.isEmpty { jsonString = toPrettyJSONString(dictionary) }
          break
        default:
          break
        }
      }
      
      let string = jsonString ?? addDash(value)
      
      let color = getRGBString(logLevel)
      let reset = getResetString()
      let level = getLogLevelString(logLevel)
      let source = "[\(logSettings.sourceString())/type:\(type ?? "nil")] "
      let coloredString: String = Atlantis.Configuration.hasColoredPrints ? (color + string + reset) : string
      
      let log: String = "\(color)\(level)\(reset)\(source)"
      
      let prettyLog: String = calculateLegibleWhitespace(log, startString: "\(level)\(source)", endString: coloredString, logLevel: logLevel)
      
      DispatchQueue.main.async { print(prettyLog) }
    }
  }
}

extension NSObject {
  
  public class func reflect(objects: NSArray?) -> [Any] {
    guard let objects = objects else { return [] }
    return objects.map { value -> Any in
      
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
        
        // arrays
      else if let value = value as? NSArray { return NSObject.reflect(objects: value) }
        
        // objects
      else { return NSObject.reflect(object: value) }
    }
  }
  
  public class func reflect(object: Any?) -> [String: Any] {
    guard let object = object else { return [:] }
    
    var dictionary: [String: Any] = [:]
    
    Mirror(reflecting: object).children.forEach { label, value in
      
      // strings
      if let key = label, let value = value as? String { dictionary.updateValue(value, forKey: key) }
      else  if let key = label, let value = value as? [String] { dictionary.updateValue(value, forKey: key) }
        
        // numbers
      else if let key = label, let value = value as? Int { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? [Int] { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? Float { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? [Float] { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? Double { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? [Double] { dictionary.updateValue(value, forKey: key) }
        
        // booleans
      else if let key = label, let value = value as? Bool { dictionary.updateValue(value, forKey: key) }
      else if let key = label, let value = value as? [Bool] { dictionary.updateValue(value, forKey: key) }
        
        // dictionaries
      else if let key = label, let value = value as? NSDictionary { dictionary.updateValue(value, forKey: key) }
        
        // objects
      else if let key = label, let value = value as? NSArray {
        let objects = NSObject.reflect(objects: value)
        if objects.isEmpty { dictionary.updateValue("null", forKey: key) }
        else { dictionary.updateValue(objects, forKey: key) }
      } else if let key = label, let value = value as? NSObject {
        let object = NSObject.reflect(object: value)
        if object.isEmpty { dictionary.updateValue(value, forKey: key) }
        else { dictionary.updateValue(object, forKey: key) }
      } else if let key = label {
        let object = NSObject.reflect(object: value)
        if object.isEmpty { dictionary.updateValue("null", forKey: key) }
        else { dictionary.updateValue(object, forKey: key) }
      }
    }
    
    return dictionary
  }
}
