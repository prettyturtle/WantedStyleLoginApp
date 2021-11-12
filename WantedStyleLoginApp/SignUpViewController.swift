//
//  signUpViewController.swift
//  WantedStyleLoginApp
//
//  Created by yc on 2021/11/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var currentUserEmail: String?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.signUpButton.layer.cornerRadius = 27
        self.signUpButton.isEnabled = false

        [nameTextField, passwordTextField, rePasswordTextField].forEach { textField in
            textField?.delegate = self
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "회원가입"
        
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
    

    
    @IBAction func tapSignUpButton(_ sender: UIButton) {
        guard let email = self.currentUserEmail,
              let password = self.passwordTextField.text,
              let rePassword = self.rePasswordTextField.text else { return }
        
        if password == rePassword {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error = error {
                    let code = (error as NSError).code
                    print("에러 내용은 : \(error.localizedDescription)")
                    print("에러 코드 :  \(code)")
                    switch code {
                    case 17026: // 비밀번호 짧음
                        self.errorMessageLabel.text = "\(error.localizedDescription)"
                    default:
                        self.errorMessageLabel.text = "\(error.localizedDescription)"
                    }
                } else {
                    print("가입 성공!!!!")
                    guard let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
//                    let us = Users(name: self.nameTextField.text ?? "이름 없음", email: self.currentUserEmail ?? "이메일 없음")
                    guard let email = Auth.auth().currentUser?.email,
                          let uuid = Auth.auth().currentUser?.uid else { return }
                    
                    
                    self.db.collection("Users").document(uuid).setData([
                        "uuid": uuid,
                        "name": self.nameTextField.text ?? "이름 없음",
                        "email": email
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    
                    self.show(homeViewController, sender: nil)
                }
            }
        } else {
            self.errorMessageLabel.text = "비밀번호가 일치하지 않습니다."
        }
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isNameTextFieldEmpty = self.nameTextField.text == ""
        let isPasswordTextFieldEmpty = self.passwordTextField.text == ""
        let isRePasswordTextFieldEmpty = self.rePasswordTextField.text == ""
        
        self.signUpButton.isEnabled = !isNameTextFieldEmpty && !isPasswordTextFieldEmpty && !isRePasswordTextFieldEmpty
    }
}
