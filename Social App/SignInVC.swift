//
//  SignInVC.swift
//  Social App
//
//  Created by Abed on 18/01/2017.
//  Copyright © 2017 Webiaturist. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("JESS: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true{
                print("JESS: User cancelled authentication")
            } else{
                print("JESS: Successfuly authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
        }
        
    }

    func firebaseAuth(credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil{
                print("JESS: Unable to authenticate with Firebase. - \(error)")
            } else {
                print("JESS: Successfully authenticated with FireBase.")
            }
            
        })
    }
}

