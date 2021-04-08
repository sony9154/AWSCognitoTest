//
//  ConfirmSignUpVC.swift
//  CogtinoDemo
//
//  Created by Peter Yo on Mar/31/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class ConfirmSignUpVC: UIViewController {
    
    @IBOutlet weak var verifyTextField: UITextField!
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let userName = self.userName else { return }
        confirmSignUp(for: userName, with: verifyTextField.text ?? "")
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
            }
        }
    }

}
