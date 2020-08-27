//
//  LoginViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if (emailTextfield.text != "" && passwordTextfield.text != ""){
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authResult, error in if let e = error{
                    print(e);
                    
                    let alert = UIAlertController(title: "Try Again!", message: "Either your email adddress is not registered or your password/email address is incorrect!", preferredStyle: .alert)
                         let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                         })
                         alert.addAction(cancel)
                         DispatchQueue.main.async(execute: {
                            self.present(alert, animated: true)
                    })
                }
                else{
            self.performSegue(withIdentifier: K.loginSegue, sender: self);
                }
                    }
            }
                
            
        }
        }

  
