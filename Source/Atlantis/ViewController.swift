//
//  ViewController.swift
//  Atlantis
//
//  Created by Andrew Aquino on 9/29/15.
//  Copyright © 2015 Andrew Aquino. All rights reserved.
//

import UIKit
import PromiseKit

public let log = Atlantis.Logger()



class ViewController: UIViewController {
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // init Atlantis
    Atlantis.Configuration.hasColoredLogs = true
    
    print("\n\n\n\n\n")
    
    log.verbose("Hello, World!")
    log.info("Hello, World!")
    log.warning("Hello, World!")
    log.debug("Hello, World!")
    log.error("Hello, World!")
    
    private let error = NSError(domain: "this is an error", code: 404, userInfo: nil)
    
    private var null: Int? = nil
    
    var array: [String?] = ["Hello", "World", nil, "Null"]

    let doIExist: String? = nil
    
    log.warning(doIExist)
    

    log.debug(["Hello", "World!"])
    
    log.error(["Hello": 0])
    
    log.info("Hello, World!")
    
    log.error(error, "bad")
    
    longgggggggggggggggggeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrFunctionName()
    longggggggggggggggggggggggggggggggggggggFunctionName()

    promiseTest()
    .then { log.debug($0) }
    .error { log.error($0) }
    
    promiseTest2()
    .then { log.debug($0) }
    .error { log.error($0) }

    enum x: ErrorType {
      case HelloThisIsAnErrorType(String)
    }

    promiseTest2()
    .then { res -> Bool in
      throw x.HelloThisIsAnErrorType("with a string argument")
    }
    .then { log.tap.info($0) }
    .error { log.error($0) }
    
    promiseTest2()
    .then { res -> Bool in
      throw NSError(domain: "an error", code: 404, userInfo: nil)
    }
    .then { log.tap.info($0) }
    .error { log.error($0) }
  }
  
  private func longggggggggggggggggggggggggggggggggggggFunctionName() {
    log.debug(error, null, ViewController())
    
    log.info("Hello, World!")
    
    log.verbose(290123123213, 0.3432432, "34344", ["Hello", "World"], [1: 23232], [2232: ""])
    
    log.info(ViewController())
    
    log.verbose("VERY VERBOSE!!", [0, 1], ["Hello, 0"], "World")
    
    log.debug("Hello, World!")
  }
  
  private func test() -> Int {
    return 3
  }
  
  private func longgggggggggggggggggeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrFunctionName() {
    log.info(
      "This is an argument",
      ["this is a dictionary", "argument"],
      [
        "nested": [
          "root": 10,
          "five": "Yes"
        ],
        "not nested": 1000
      ]
    )
    
    let dict: [String: AnyObject] = [
      "cat": [
        "dog": "pet",
        "five": 5
      ],
      "numbers": [
        "this": true,
        "hello": false
      ]
    ]
    
    log.info(dict, dict)
    
    let errorType = NSError(domain: "error type", code: 404, userInfo: nil) as ErrorType
    
    log.error(errorType)
    
    let tapped = log.tap.warning(errorType)
    log.error(tapped)
  }
  
  private func promiseTest() -> Promise<Bool> {
    return Promise { fulfill, reject in
      dispatch_after(UInt64(3.0), dispatch_get_main_queue()) {
        reject(NSError(domain: "username was not set", code: 404, userInfo: nil))
      }
    }
  }
  
  private func promiseTest2() -> Promise<Bool> {
    return Promise { fulfill, reject in
      dispatch_after(UInt64(3.0), dispatch_get_main_queue()) {
        fulfill(true)
      }
    }
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}