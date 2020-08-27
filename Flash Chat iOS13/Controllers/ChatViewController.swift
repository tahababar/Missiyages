//
//  ChatViewController.swift
//  Flash Chat iOS13
//

//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore();    //important to add
    
    var messages: [Message] = []  //an array of message objects
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self; //compulsory to add with the extension under the page, to deal with table views
        navigationItem.hidesBackButton = true;   //to remove back button in navigation bar
        navigationItem.title = K.appName; //to nadd title on navigation
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: K.cellIdentifier)  //to register the xib file and new view contoller for table cells we created in views folder
        
        loadMessages(); //using firebase documentation read data sectio to display all previous messges on nscreen when scene loads
       }
    
    func loadMessages(){
       /*
        db.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, err) in   //addSnapshotlistener added using another feature from fire documentation to add messages constyantly whhen we press send button
            //.order is another feature of fireball to order our incoming messages by date order
            self.messages = []; //added this to make the array empty otherwise all the messages will be displayed againa and again... we only need the latest one
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    for doc in querySnapshot!.documents{
                        let data = doc.data();
                        if (data.count != 0)
                        {
                        let newMessage = Message(sender: data["sender"] as! String, body: data["body"] as! String)
                        self.messages.append(newMessage);
                            
                            DispatchQueue.main.async{
                                self.tableView.reloadData();
                            }   //added these three lines to load the table faster
                }
                    }
                }
            }
        }
        */
        db.collection(K.FStore.collectionName)
                  .order(by: K.FStore.dateField)
                  .addSnapshotListener { (querySnapshot, error) in
                  
                  self.messages = []
                  
                  if let e = error {
                      print("There was an issue retrieving data from Firestore. \(e)")
                  } else {
                      if let snapshotDocuments = querySnapshot?.documents {
                          for doc in snapshotDocuments {
                              let data = doc.data()
                              if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                  let newMessage = Message(sender: messageSender, body: messageBody)
                                  self.messages.append(newMessage)
                                  
                                  DispatchQueue.main.async {
                                         self.tableView.reloadData()  //to increase speed
                                    /////to scroll down if messages increase screen height
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                                                   self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                  }
                              }
                          }
                      }
                  }
              }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if (messageTextfield.text != "" && Auth.auth().currentUser?.email != ""){
         var ref: DocumentReference? = nil
         ref = db.collection("messages").addDocument(data: [
            "sender": Auth.auth().currentUser?.email,
            "body": messageTextfield.text,
            "date": Date().timeIntervalSince1970
       ]) { err in
           if let err = err {
               print("Error adding document: \(err)")
           } else {
               print("Document added with ID: \(ref!.documentID)")
           }
       }
        
    }
        messageTextfield.text = "";
    }
    
    @IBAction func logOffPressed(_ sender: UIBarButtonItem) {
           let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            //the mwthod belopw is added to take it back to home screen on logging off
            navigationController?.popToRootViewController(animated: true);
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        //to add number of cells we need in terms of rows
    {
       return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
            cell.label.text = messages[indexPath.row].body
            
            //This is a message from the current user.
            if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            

                cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
                cell.label.textColor = UIColor(named: K.BrandColors.purple)
            }
            
            //This is a message from another sender.
            else {
                
                cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
                cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            }
          
            return cell
        }
    }

    //a new protocol to help arrange our table view
        //we use extension to introduce a new class/protocol to be inherited sometimes
        //always create this extension when we deal with table view and its cell
    //when we add fix, it automatically adds the neceaasary functions to edit
        
   //



/*
 Prototype calls in table view..evemn if we use 1..will be used over and over again
 
 
 */
