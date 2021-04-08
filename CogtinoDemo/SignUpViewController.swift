//
//  SignUpViewController.swift
//  CogtinoDemo
//
//  Created by Peter Yo on Mar/31/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "註冊"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUp(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", email: emailTextField.text ?? "")
    }
    
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmSignUpVC") as! ConfirmSignUpVC
                        vc.userName = username
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    
    
    

}
