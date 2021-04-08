//
//  ConfirmResetPasswordVC.swift
//  CogtinoDemo
//
//  Created by Peter Yo on Apr/1/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class ConfirmResetPasswordVC: UIViewController {
    var userName: String?
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Reset a new password"
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        guard let userName = self.userName else { return }
        self.confirmResetPassword(username: userName, newPassword: newPasswordTextField.text ?? "", confirmationCode: confirmationCodeTextField.text ?? "")
    }
    
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
                DispatchQueue.main.async {
                    let alert = UIAlertController.init(title: "SUCCESS", message: "", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }
    

}
