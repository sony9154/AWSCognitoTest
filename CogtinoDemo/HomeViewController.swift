//
//  HomeViewController.swift
//  CogtinoDemo
//
//  Created by Peter Yo on Apr/1/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首頁"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        signOutGlobally()
    }
    
    
    func signOutGlobally() {
        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
            switch result {
            case .success:
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
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
