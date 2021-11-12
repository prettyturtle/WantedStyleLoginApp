//
//  ViewController.swift
//  WantedStyleLoginApp
//
//  Created by yc on 2021/11/12.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLoginButton: UIButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [kakaoLoginButton, facebookLoginButton, googleLoginButton, appleLoginButton].forEach { btn in
            btn?.layer.cornerRadius = CGFloat((btn?.frame.width)! / 2)
        }
        self.googleLoginButton.layer.borderWidth = 1
        self.googleLoginButton.layer.borderColor = UIColor.lightGray.cgColor

        self.emailLoginButton.layer.cornerRadius = 27
        self.emailLoginButton.isEnabled = false
        
        self.emailTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    
    @IBAction func tapEmailLoginButton(_ sender: UIButton) {
        guard let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        guard let signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
        
        let email = self.emailTextField.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { res, error in
            if let result = res {
                // 성공
                signInViewController.currentUserEmail = email
                self.navigationController?.pushViewController(signInViewController, animated: true)
                
            } else if let error = error {
                // 이메일 형식이 안맞거나 또 다른 에러
                let code = (error as NSError).code
                switch code {
                case 17008:
                    self.errorMessageLabel.text = "\(error.localizedDescription)"
                default:
                    self.errorMessageLabel.text = "\(error.localizedDescription)"
                }
                
            } else {
                // 가입한 회원이 아닐때 회원가입 view로 연결
                signUpViewController.currentUserEmail = email
                self.navigationController?.pushViewController(signUpViewController, animated: true)
            }
        })
        
        
    }
}




extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailTextFieldEmpty = self.emailTextField.text == ""
        self.emailLoginButton.isEnabled = !isEmailTextFieldEmpty
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
