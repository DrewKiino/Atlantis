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
    
    Atlantis.Configuration.highlightsErrors = true
    Atlantis.Configuration.hasColoredLogs = true
    Atlantis.Configuration.coloredLogLevels = [.Verbose, .Error]
    
    let user = User()
    user.age = 24
    user.name = "Cindy"
    user.id = "123345"
    
    log.debug(user)
    
//    let error = NSError(domain: "Hello, World!", code: 404, userInfo: nil)
//    let error2 = NSError(domain: "Hello, World!", code: 404, userInfo: ["Hello": "World", "Number": 0])
//    let error3 = NSError(domain: "Hello, World!", code: -999, userInfo: nil)
//    
//    log.error(error)
//    log.error(error2)
//    log.error(error3)
//    
//    log.verbose(string)
//    log.info(string)
//    log.warning(string)
//    log.debug(string)
//    log.error(string)
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










