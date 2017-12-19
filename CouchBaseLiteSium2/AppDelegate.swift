//
//  AppDelegate.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 12/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import CouchbaseLite




private let kDatabaseName = "grocery-sync"

private let kServerDbURL = NSURL(string: "http://193.34.145.251:4984/todo")!



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var _push: CBLReplication!
    private var _pull: CBLReplication!
    private var _syncError: NSError?
    
    let database: CBLDatabase!
    var parse: AnyObject!
    
    override init() {
        database = try? CBLManager.sharedInstance().databaseNamed(kDatabaseName)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        guard database != nil else {
            
            return
        }
        
        
        // Initialize replication:
        print("1")
        _push = setupReplication(replication: database.createPushReplication(kServerDbURL as URL))
        _pull = setupReplication(replication: database.createPullReplication(kServerDbURL as URL))
        _push.start()
        _pull.start()
        return
    }
    
    
    func setupReplication(replication: CBLReplication!) -> CBLReplication! {
        if replication != nil {
            replication.continuous = true
            print("Running")
            
            NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(n:)), name: NSNotification.Name.cblReplicationChange, object: replication)
        }
        return replication
    }
    
    @objc func replicationProgress(n: NSNotification) {
        
        print("jhwdvwtfv")
        //let progressBar = (navigationController.topViewController as! RootViewController).progressBar
        if (_pull.status == CBLReplicationStatus.active || _push.status == CBLReplicationStatus.active) {
            // Sync is active -- aggregate the progress of both replications and compute a fraction:
            let completed = _pull.completedChangesCount + _push.completedChangesCount
            let total = _pull.changesCount + _push.changesCount
            NSLog("SYNC progress: %u / %u", completed, total)
            // Update the progress bar, avoiding divide-by-zero exceptions:
           // progressBar?.progress = Float(completed) / Float(max(total, 1))
            //progressBar?.isHidden = false
        } else {
            // Sync is idle -- hide the progress bar:
            //progressBar?.isHidden = true
        }
        
        // Check for any change in error status and display new errors:
        let error = _pull.lastError ?? _push.lastError
        if (error as NSError? != _syncError)  {
            _syncError = error as NSError?
            if error != nil {
               // self.showAlert(message: "Error syncing", error as NSError?)
            }
        }
    }
    
    
    /*func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        applicationDidFinishLaunching(application)
        return true
    }*/

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

