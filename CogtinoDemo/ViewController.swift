//
//  ViewController.swift
//  CogtinoDemo
//
//  Created by Peter Yo on Mar/30/21.
//

import UIKit
import Amplify
import AmplifyPlugins



class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //    let fview = UIApplication.shared.windows.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登入"
        // Do any additional setup after loading the view.
//        let cognitoAuth = AWSCognitoAuth.default()
//        cognitoAuth.getSession(self)  { (session:AWSCognitoAuthUserSession?, error:Error?) in
//          if(error != nil) {
//            print((error! as NSError).userInfo["error"] as? String)
//           }else {
//           //Do something with session
//          }
//        }
        fetchCurrentAuthSession()
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signIn(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    func signIn(username: String, password: String) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let nextStep):
                print(nextStep)
                print("Sign in succeeded")
                DispatchQueue.main.async {
                    let alert = UIAlertController.init(title: "Sign in succeeded", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    @IBAction func resetPasswordBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Your Account to Reset Password", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Your UserName"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else { return }
            print("Text field: \(textField.text ?? "")")
            self.resetPassword(username: textField.text ?? "")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetPassword(username: String) {
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(info)")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmResetPasswordVC") as! ConfirmResetPasswordVC
                        vc.userName = username
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    @IBAction func googleSiginButtonPressed(_ sender: UIButton) {
        socialSignInWithWebUI()
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        facebookSignInWithWebUI()
    }
    
    
    func socialSignInWithWebUI() {
        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: self.view.window!) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    func facebookSignInWithWebUI() {
        Amplify.Auth.signInWithWebUI(for: .facebook, presentationAnchor: self.view.window!) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                let cogSession = session as? AWSAuthCognitoSession
                cogSession?.getCognitoTokens()
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
}

