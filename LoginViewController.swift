//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by Maksim Halubko on 06.02.22.

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let segueIdentifier = "tasksSegue"
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference(withPath: "users")
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        warnLabel.alpha = 0
        
        FIRAuth.auth()?.addStateDidChangeListener({ [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
        
    }
    
    func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        })
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in

            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.uid)!)
            userRef?.setValue(["email": user?.email])
          
        })
    }

}
