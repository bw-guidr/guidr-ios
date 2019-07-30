//
//  LoginViewController.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let userController = UserController()
    var isLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPasswordButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    

    @IBAction func registerButtonTapped(_ sender: Any) {
        if isLogin {
            login()
        } else {
            register()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if isLogin {
            UIView.animate(withDuration: 0.5) {
                self.nameIcon.alpha = 1
                self.nameLabel.alpha = 1
                self.nameTextField.alpha = 1
                self.forgotPasswordButton.isHidden = true
                self.registerButton.setTitle("Register", for: .normal)
                self.loginButton.setTitle("Login", for: .normal)
            }
            
            isLogin = false
        } else {
            UIView.animate(withDuration: 0.5) {
                self.nameIcon.alpha = 0
                self.nameLabel.alpha = 0
                self.nameTextField.alpha = 0
                self.forgotPasswordButton.isHidden = false
                self.registerButton.setTitle("Log In", for: .normal)
                self.loginButton.setTitle("Register", for: .normal)
            }
            
            isLogin = true
        }
        
    }
    
    func login() {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = UserRepresentation(email: email, password: password, name: nil, imageURL: nil, identifier: nil)
        userController.loginWith(user: user, loginType: .signIn) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowProfileSegue", sender: self)
                }
            } else {
               NSLog("Error logging in with \(result)")
            }
        }
    }
    
    func register() {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let name = nameTextField.text,
            !name.isEmpty else { return }
        
        let user = UserRepresentation(email: email, password: password, name: name, imageURL: nil, identifier: nil)
        userController.signUpWith(user: user, loginType: .signUp) { (error) in
            if let error = error {
                NSLog("Error registering with \(error)")
            }
            self.userController.loginWith(user: user, loginType: .signIn) { (result) in
                if (try? result.get()) != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ShowProfileSegue", sender: self)
                    }
                } else {
                    NSLog("Error logging in with \(result)")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
