//
//  WelcomeViewController.swift
//  Flash Chat iOS13

//
// used SHOW segue from welcome to login/register...click on log in button and drqag it to login screen in storyboard. This way we dont need identifiers like normal other segues nor do we need onclick button actions!
//navigation bar added by clicking welcome view bar..then using editor tab and selecting navigation
//assign identifiers to segues by clickimng on them on storyboard
import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName;
    }
    
   

}
