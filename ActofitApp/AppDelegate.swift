//
//  AppDelegate.swift
//  ActofitApp
//
//  Created by Apple on 10/03/22.
//

import UIKit
import MapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var timer: Timer?
    var bgTaskId = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let isLoggedIn = UserDefaults.standard.isLoggedIn()
        if isLoggedIn == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let app = UIApplication.shared
        bgTaskId = app.beginBackgroundTask(expirationHandler: { [self] in
             app.endBackgroundTask(self.bgTaskId)
            bgTaskId = .invalid
        })

        DispatchQueue.main.async(execute: { [self] in
            timer = nil
            initTimer()
            app.endBackgroundTask(bgTaskId)
            bgTaskId = .invalid
        })
    }

    func initTimer() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        if timer == nil {
            timer = Timer.scheduledTimer(
                timeInterval: 5.0,
                target: self,
                selector: Selector("checkUpdates:"),
                userInfo: nil,
                repeats: true)
        }
    }

    func checkUpdates(_ timer: Timer?) {
        let app = UIApplication.shared
        let remaining = app.backgroundTimeRemaining
        if remaining < 580.0 {
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let locationString = String(location.coordinate.latitude) + String(location.coordinate.longitude)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent("LocationData.txt")
        if let handle = try? FileHandle(forWritingTo: fileURL) {
           handle.seekToEndOfFile() // moving pointer to the end
           handle.write(locationString.data(using: .utf8)!) // adding content
           handle.closeFile() // closing the file
       }
       
    }
    
    
    
    
}

