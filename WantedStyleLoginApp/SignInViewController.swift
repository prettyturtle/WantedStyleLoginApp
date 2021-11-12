//
//  SignInViewController.swift
//  WantedStyleLoginApp
//
//  Created by yc on 2021/11/12.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    var currentUserEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.passwordTextField.delegate = self
        
        self.signInButton.layer.cornerRadius = 27
        self.signInButton.isEnabled = false
        self.emailLabel.layer.borderWidth = 1.5
        self.emailLabel.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        self.emailLabel.layer.cornerRadius = 5
        
        if let currentUserEmail = currentUserEmail {
            self.emailLabel.text = "  \(currentUserEmail)"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "로그인"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
 

        )
    }
    @objc func popToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func tapSignInButton(_ sender: UIButton) {
        guard let email = currentUserEmail else { return }
        Auth.auth().signIn(withEmail: email, password: self.passwordTextField.text ?? "") { _, error in
            if let error = error {
                self.errorMessageLabel.text = "\(error.localizedDescription)"
            } else {
                guard let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                
                self.show(homeViewController, sender: nil)
                
            }
        }
        
    }
    
}


extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isPasswordTextFieldEmpty = self.passwordTextField.text == ""
        
        self.signInButton.isEnabled = !isPasswordTextFieldEmpty
    }
}
