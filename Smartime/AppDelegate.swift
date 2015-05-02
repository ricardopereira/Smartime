//
//  AppDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = start()
        
        let socket = SocketIO(url: "http://localhost:8000/");
        
        socket.on("myevent") { (arg: SocketIOArg) -> (SocketIOResult) in
            //println("Event: \(arg)")
            return SocketIOResult.Success(status: 0)
        }.on(.ConnectError) { (arg: SocketIOArg) -> (SocketIOResult) in
            switch arg {
            case .Failure(let error):
                println(error)
            default:
                return SocketIOResult.Success(status: 0)
            }
            return SocketIOResult.Success(status: 0)
        }.on(.Connected) { (arg: SocketIOArg) -> (SocketIOResult) in
            //println("Teste 2: \(arg)")
            
            // Connected
            // Emit "connect" not possible!
            socket.emit("myevent", withMessage: "sdflkaskdçfjwe")
            socket.off()
            socket.emit("myevent", withMessage: "aaaa")
            
            return SocketIOResult.Success(status: 0)
        }
        
        socket.connect()
        
        // Teste
        
        //socket.emit("connect", withMessage: "200")

        return true
    }
    
    func test() {
        /*
        struct JSONValidator<T> {
        
            typealias ValidationClosure = (JSON) -> Bool
        
            let validator: ValidationClosure
        
            init(validator: ValidationClosure) {
               self.validator = validator
            }
        
            func isValid(json: JSON) -> Bool {
                return validator(json)
            }
        
        }
        
        struct MyModel {
            let name: String
            let number: Int
            let date: NSDate
        
            init(name: String, number: Int, date: NSDate)
        }
        
        protocol JSONParserType {
            typealias T
            func parseJSON(json: JSON) -> T
        }
        
        struct MyModelParser: JSONParserType {
        
            func parseJSON(json: JSON) -> MyModel {
                // parse json and construct MyModel
                return MyModel(name: "name", number: 1, date: NSDate())
            }
        
        }
        
        let json = JSON(data: dataFromServer)
        
        let validator = JSONValidator<MyModel> { (json) -> Bool in
            // validate the json
            return true
        }
        
        if !validator.isValid(json) {
            // handle bad json
            return
        }
        
        let parser = MyModelParser()
        
        let myModel = parser.parseJSON(json)
        */
    }

    func start() -> UIViewController {
        let mainView = UIViewController()
        mainView.view.backgroundColor = UIColor.greenColor()
        return mainView
    }
}
