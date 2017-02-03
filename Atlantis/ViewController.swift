//
//  ViewController.swift
//  Atlantis
//
//  Created by Andrew Aquino on 6/29/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let string: String = "Proper Text Alignment!"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    Atlantis.Configuration.coloredLogLevels = [.Verbose, .Error]
//    Atlantis.Configuration.hasColoredLogs = true

//    log.verbose("Hello, World")
//    log.info("Hello, World")
//    log.warning("Hello, World")
//    log.debug("Hello, World")
//    log.error("Hello, World")
    
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
      "Hello": "World" as AnyObject,
      "World": 1000 as AnyObject
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
    
//    log.debug(UIColor())
    
//    log.debug(object2)
//    log.debug([object, object2, object3])
    
//    let user2 = User2()
//    user2.age = 42
//    user2.name = "Bob"
//    user2.id = "54321"
    
//    log.debug(User2()) // any
    
//    struct Struct {
//      var name: String = "Bob the Builder"
//      var skills: [String] = ["structures, buildings"]
//    }
//    
//    let this = Struct()
//    
//    log.debug(this)
    
    enum This {
      case isCool
      case isNotCool
    }
    
//    let this: This = .IsCool
//    let thiz: This = .IsCool
//    
//    log.debug(This.IsCool)
//    log.debug(This.IsNotCool)
//    log.debug(this)
//    log.debug(thiz)
    
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
//    log.error(error2)
//    log.error(error3)

//    log.verbose(string)
//    log.info(string)
//    log.warning(string)
//    log.debug(string)
//    log.error(string)
//
    aaaaaaafseaelieshfashif()
    faeoifhieahflsfjseifseilfjiasefjlasej()
    faeoifhie()
    aaaaaaafseaelieshfashif()
    faeoifhie()
    awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej()
    aaaaaaafseaelieshfashif()
    faeoifhie()
    faeoifhie()
    faeoifhie()
    faeoifhie()
    faeoifhie()
    faeoifhie()
    faeoifhie()
    aaaaaaafseaelieshfashif()
    faeoifhie()
    awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej()
    aaaaaaafseaelieshfashif()
    faeoifhie()
    faeoifhie()
    faeoifhie()
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
    log.info(string)
  }
  
  func faeoifhieahflsfjseifseilfjiasefjlasej() {
    log.info(string)
  }
  
  func awfawfawfawfaeoifhieahflsfjseifseilfjiasefjlasej() {
    log.verbose(string)
  }
  
  func faeoifhie() {
    log.info(string)
  }
}

open class Object {
  open var number: Int?
  open var numberArray: [Int]?
  open var string: String?
  open var stringArray: [String]?
  open var float: Float?
  open var floatArray: [Float]?
  open var double: Double?
  open var doubleArray: [Double]?
  open var bool: Bool?
  open var boolArray: [Bool]?
  open var dictionary: [String: AnyObject]?
  open var object: Object?
  open var objectArray: [Object]?
}

open class User2 {
  open var name: String?
  open var id: String?
  open var age: Int?
  open var user: User2?
}










