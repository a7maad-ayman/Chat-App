//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = Constants.appName
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.nib(), forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener{ querySnapShot, error in
            self.messages = []
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let snapShotDocuments = querySnapShot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String , let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(body: messageBody, sender: messageSender)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.bodyField : messageBody , Constants.FStore.senderField : messageSender ,Constants.FStore.dateField : Date().timeIntervalSince1970 ]) { error in
                if let err = error {
                    print(err.localizedDescription)
                }else{
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier , for: indexPath) as! MessageTableViewCell
        cell.messageBody.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.avtarImage.isHidden = false
            cell.youAvatarImage.isHidden = true
            cell.messageBackground.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.messageBody.textColor = UIColor(named: Constants.BrandColors.purple)
        }else{
            cell.avtarImage.isHidden = true
            cell.youAvatarImage.isHidden = false
            cell.messageBackground.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.messageBody.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}
