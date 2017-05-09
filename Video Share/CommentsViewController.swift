//
//  CommentsViewController.swift
//  Video Share
//
//  Created by Samarth Paboowal on 09/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var commentID: String?
    var comments: [Comment] = []
    
    let bottomView = UIView()
    let messageTextField = UITextField()
    let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: "comment")
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 68, 0)
        setupViews()
        observeComments()
    }
    
    func setupViews() {
        
        view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.clear
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        bottomView.addSubview(messageTextField)
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4).isActive = true
        messageTextField.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 4).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -4).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -68).isActive = true
        messageTextField.placeholder = "Enter comment"
        
        bottomView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -4).isActive = true
        sendButton.leftAnchor.constraint(equalTo: messageTextField.rightAnchor, constant: 4).isActive = true
        sendButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -4).isActive = true
        sendButton.addTarget(self, action: #selector(addComment), for: UIControlEvents.touchUpInside)
    }
    
    func addComment() {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://video-share-af1b2.firebaseio.com/")
        let usersReference = ref.child("comments")
        let childRef = usersReference.child(commentID!)
        let r = childRef.childByAutoId()
        
        let values = ["comment": messageTextField.text!] as [String : Any]
        
        r.updateChildValues(values, withCompletionBlock: {
            (errUpdate, ref) in
            
            if errUpdate != nil {
                print(errUpdate!.localizedDescription)
                return
            }
        })
        
        messageTextField.text = ""
        
        //observeComments()
    }
    
    func observeComments() {
        
        comments = []
        
        let ref = FIRDatabase.database().reference().child("comments").child(commentID!)
        
        ref.observe(.childAdded, with: {
            ( snapshot ) in
            
            if let dict = snapshot.value as? [String:Any] {
                let comment = Comment()
                comment.comment = dict["comment"] as? String
                
                self.comments.append(comment)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
            
        }, withCancel: nil)

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comment", for: indexPath) as! CommentsCell
        
        cell.textLabel.text = comments[indexPath.item].comment
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 38)
    }

}
