//
//  ViewController.swift
//  Atlantis
//
//  Created by Andrew Aquino on 6/29/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let string: String = "Hello, World!"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    Atlantis.Configuration.highlightsErrors = true
//    Atlantis.Configuration.hasColoredLogs = true
//    Atlantis.Configuration.coloredLogLevels = [.Verbose, .Error]
    
    let user1 = User()
    user1.age = 24
    user1.name = "Cindy"
    user1.id = "123345"
    
    let user2 = User2()
    user2.age = 24
    user2.name = "Cindy"
    user2.id = "123345"
    
    log.debug(user2)
    log.debug(user1)
    log.debug([user1, user2, 1, "Hello"])
    log.debug(1)
    log.debug([1])
    log.debug(1.0 as Float)
    log.debug([1.0 as Float])
    log.debug(1.0 as Double)
    log.debug([1.0 as Double])
    log.debug("")
    log.debug([""])
    
    let dictionary: [String: AnyObject] = [
      "": 1,
      "1": "World"
    ]
    
    log.debug(dictionary)
    
    let nothing: String? = nil
    log.debug(nothing)
    
    let error = NSError(domain: "Hello, World!", code: 404, userInfo: nil)
    let error2 = NSError(domain: "Hello, World!", code: 404, userInfo: ["Hello": "World", "Number": 0])
    let error3 = NSError(domain: "Hello, World!", code: -999, userInfo: nil)

    log.error(error)
    log.error(error2)
    log.error(error3)

    log.verbose(string)
    log.info(string)
    log.warning(string)
    log.debug(string)
    log.error(string)
    
    aaaaaaafseaelieshfashif()
    faeoifhieahflsfjseifseilfjiasefjlasej()
    faeoifhie()
    aaaaaaafseaelieshfashif()
    faeoifhie()
    awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej()
    aaaaaaafseaelieshfashif()
    aaaaaaafseaelieshfashif()
    
    log.verbose(string)
    log.info(string)
    log.warning(string)
    log.debug(string)
    log.error(string)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func aaaaaaafseaelieshfashif() {
    log.verbose(string)
  }
  
  func faeoifhieahflsfjseifseilfjiasefjlasej() {
    log.info(string)
  }
  
  func awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej() {
    log.info(string)
  }
  
  func faeoifhie() {
    log.warning(string)
  }
  
  private func reflect(object: Any) -> [String: AnyObject] {
    
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
        
        // dictionaries
      else if let key = label, value = value as? [String: AnyObject] { dictionary.updateValue(value, forKey: key) }
    }
    
    return dictionary
  }
}


public class User: NSObject {
  public var name: String?
  public var id: String?
  public var age: Int?
}

public class User2 {
  public var name: String?
  public var id: String?
  public var age: Int?
}










