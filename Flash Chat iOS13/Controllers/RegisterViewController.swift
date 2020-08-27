//
//  RegisterViewController.swift
//  Flash Chat iOS13
//

//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorMessage: UIButton!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if (emailTextfield.text != "" && passwordTextfield.text != "")
        {Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authResult, error in if let e = error{
            print(e);
            
            let alert = UIAlertController(title: "Try Again!", message: "Either your email adddress is not valid or is already in use or your password is less than 6 characters!", preferredStyle: .alert)
                 let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                 })
                 alert.addAction(cancel)
                 DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
            })
        }
        else{
            self.performSegue(withIdentifier: K.registerSegue, sender: self);
        }
            }
    }
        
    
}
}
