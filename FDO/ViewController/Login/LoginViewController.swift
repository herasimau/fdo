//
//  LoginViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoginViewController: UIViewController {

    private let authService: AuthServiceAPI = DIContainer.inject()

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        errorLabel.text = "Ошибка авторизации"
        loginButton?.layer.cornerRadius = 10
        loginButton?.clipsToBounds = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @IBAction func loginPrimaryAction(_ sender: Any) {
        self.loginAction(sender)
    }

    @IBAction func passwordPrimaryAction(_ sender: Any) {
        self.loginAction(sender)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }

    @IBAction func loginAction(_ sender: Any) {
        let usernameText = loginTextField.text
        let passwordText = passwordTextField.text
        if let username = usernameText, let password = passwordText {
            SwiftSpinner.show("Подключение к спутнику...")
            self.authService.authenticate(username: username, password: password) {[weak self] result in
                SwiftSpinner.hide()
                guard let self = self else { return }
                switch result {
                case .success:
                    self.errorLabel.isHidden = true
                    self.performSegue(withIdentifier: "homeSegue", sender: self)
                case .failure:
                    self.errorLabel.isHidden = false
                    print("Error login")
                }
             }
         }
    }

}
