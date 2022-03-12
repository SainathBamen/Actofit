//
//  ViewController.swift
//  ActofitApp
//
//  Created by Apple on 10/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeView()
    }
    
    func initializeView() {
        parentView.dropShadow()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        if (nameTextField.text?.count ?? 0) > 0 && (mobileTextField.text?.count ?? 0) > 0 {
            
            UserDefaults.standard.setLoggedIn(value: true)
            UserDefaults.standard.setMobileNumner(value: mobileTextField.text ?? "")
            UserDefaults.standard.setUserName(value: nameTextField.text ?? "")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            self.view.window?.rootViewController = controller
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter name and Mobile Number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

