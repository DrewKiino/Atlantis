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
    
    Atlantis.Configuration.hasColoredLogs = false
//    Atlantis.Configuration.coloredLogLevels = [.Verbose, .Error]
    
    let object = Object()
    object.number = 1
    object.numberArray = [1, 2]
    object.float = 1.0
    object.floatArray = [1.0, 2.0]
    object.double = 2.0
    object.doubleArray = [2.0, 3.0]
    object.string = "Hello"
    object.stringArray = ["Hello", "World"]
    object.bool = true
    object.boolArray = [true, false]
    object.dictionary = [
      "Hello": "World",
      "World": 1000
    ]
    
    let object2 = Object()
    object2.number = 2
    object2.numberArray = [1, 2]
    object2.float = 1.0
    object2.floatArray = [1.0, 2.0]
    object2.double = 2.0
    object2.doubleArray = [2.0, 3.0]
    object2.string = "Hello"
    object2.stringArray = ["Hello", "World"]
    
    let object3 = Object()
    object3.number = 3
    object3.numberArray = [1, 2]
    object3.float = 1.0
    object3.floatArray = [1.0, 2.0]
    object3.double = 2.0
    object3.doubleArray = [2.0, 3.0]
    object3.string = "Hello"
    object3.stringArray = ["Hello", "World"]
    
    object.object = object2
    
    object.objectArray = [object2, object3]
    
    log.debug(UIColor())
    
//    log.debug(object)
//    log.debug([object, object2, object3])
    
//    let user2 = User2()
//    user2.age = 42
//    user2.name = "Bob"
//    user2.id = "54321"
    
//    log.debug(User2()) // any
//    log.debug([object, object2, 1, "Hello"])
//    log.debug(1)
//    log.debug([1])
//    log.debug(1.1 as Float)
//    log.debug([1.2 as Float])
//    log.debug(1.3 as Double)
//    log.debug([1.4 as Double])
//    log.debug("")
//    log.debug([""])
//    log.debug(true)
//    log.debug([true])
    
//    let dictionary: [String: AnyObject] = [
//      "": 1,
//      "1": "World"
//    ]
    
//    log.debug(dictionary)
    
//    let nothing: String? = nil
//    log.debug(nothing)
    
//    let error = NSError(domain: "Hello, World!", code: 404, userInfo: nil)
    let error2 = NSError(domain: "Hello, World!", code: 404, userInfo: ["Hello": "World", "Number": 0])
//    let error3 = NSError(domain: "Hello, World!", code: -999, userInfo: nil)

//    log.error(error)
    log.error(error2)
//    log.error(error3)

    log.verbose(string)
    log.info(string)
    log.warning(string)
    log.debug(string)
    log.error(string)
//
//    aaaaaaafseaelieshfashif()
//    faeoifhieahflsfjseifseilfjiasefjlasej()
//    faeoifhie()
//    aaaaaaafseaelieshfashif()
//    faeoifhie()
//    awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej()
//    aaaaaaafseaelieshfashif()
//    aaaaaaafseaelieshfashif()
//    
//    log.verbose(string)
//    log.info(string)
//    log.warning(string)
//    log.debug(string)
//    log.error(string)
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
}


public class Object {
  public var number: Int?
  public var numberArray: [Int]?
  public var string: String?
  public var stringArray: [String]?
  public var float: Float?
  public var floatArray: [Float]?
  public var double: Double?
  public var doubleArray: [Double]?
  public var bool: Bool?
  public var boolArray: [Bool]?
  public var dictionary: [String: AnyObject]?
  public var object: Object?
  public var objectArray: [Object]?
}

public class User2 {
  public var name: String?
  public var id: String?
  public var age: Int?
  public var user: User2?
}










