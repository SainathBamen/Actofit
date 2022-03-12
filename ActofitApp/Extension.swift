//
//  Extension.swift
//  ActofitApp
//
//  Created by Apple on 10/03/22.
//

import Foundation
import UIKit

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.systemGroupedBackground.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

extension UserDefaults{

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }

    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    //MARK: Save User Data
    func setUserName(value: String){
        set(value, forKey: UserDefaultsKeys.name.rawValue)
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getUserName() -> String{
        return string(forKey: UserDefaultsKeys.name.rawValue) ?? ""
    }
    
    //MARK: Save User Data
    func setMobileNumner(value: String){
        set(value, forKey: UserDefaultsKeys.name.rawValue)
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getMobileNumber() -> String{
        return string(forKey: UserDefaultsKeys.name.rawValue) ?? ""
    }
}
