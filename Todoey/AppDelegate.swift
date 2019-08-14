//
//  AppDelegate.swift
//  Todoey
//
//  Created by Malik Smith on 8/5/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      
        
        
        
        do {
        let realm = try Realm()
          
        } catch {
            print("Error initalising new realm")
        }
        return true
    }
   


    func applicationWillTerminate(_ application: UIApplication) {
    
       
    }
    
    // MARK: - Core Data stack

    
    // MARK: - Core Data Saving support
    
    



}

