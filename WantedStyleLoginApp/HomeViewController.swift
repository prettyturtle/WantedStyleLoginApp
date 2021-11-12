//
//  HomeViewController.swift
//  WantedStyleLoginApp
//
//  Created by yc on 2021/11/13.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var currentUserNameLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let docRef = db.collection("Users").document(currentUser.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dataDescription = document.data() as? [String: String] else { return }
                self.currentUserNameLabel.text = "\(dataDescription["name"]!)님! "

                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
                self.currentUserNameLabel.text = "\(currentUser.email!)님! "

            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true

    }
    
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: sign out \(signOutError.localizedDescription)")
        }
        
    }
}
