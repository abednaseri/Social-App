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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CoolField!
    @IBOutlet weak var passwordField: CoolField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }

    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("ABED: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true{
                print("ABED: User cancelled authentication")
            } else{
                print("ABED: Successfuly authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
        }
        
    }

    func firebaseAuth(credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil{
                print("ABED: Unable to authenticate with Firebase. - \(error)")
            } else {
                print("ABED: Successfully authenticated with FireBase.")
                if let user = user{
                    self.completeSignInWithKeyChain(id: user.uid)
                }
            }
            
        })
    }
    
    
    @IBAction func SignInPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil{
                    print("Abed: User successfull loging with Email Firebase")
                    if let user = user{
                        self.completeSignInWithKeyChain(id: user.uid)
                    }
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil{
                            print("Abed: unable to authenticate Email with Firebase")
                        }else{
                            print("Abed: Successfully authenticated with Firebase using Email")
                            if let user = user{
                                self.completeSignInWithKeyChain(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignInWithKeyChain(id: String){
        let KeychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ABED: Data saved to keycchain - \(KeychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    
    
    
    
    
    
    
    
}

