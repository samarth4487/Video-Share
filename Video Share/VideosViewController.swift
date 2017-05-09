//
//  VideosViewController.swift
//  Video Share
//
//  Created by Samarth Paboowal on 24/03/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class VideosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleUpload))
        
        navigationItem.title = ""
        
        collectionView?.register(VideosViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        observeVideos()
    }
    
    func observeVideos() {
    
        videos = []
        
        let ref = FIRDatabase.database().reference().child("videos")
        
        ref.observe(.childAdded, with: {
            ( snapshot ) in
            
            if let dict = snapshot.value as? [String:Any] {
                let video = Video()
                video.title = dict["title"] as? String
                video.imageURL = dict["imageURL"] as? String
                video.videoURL = dict["videoURL"] as? String
                video.commentID = dict["comments"] as? String
                
                self.videos.append(video)
                //print("jhghjghghjgh")
                
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
        
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideosViewCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        
        cell.video = videos[indexPath.item]
        cell.titleLabel.text = videos[indexPath.item].title
        
        if let profileImageUrl = videos[indexPath.item].imageURL {
            cell.image.downloadImageAndCache(imageURL: profileImageUrl as NSString)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let commentsViewController = CommentsViewController(collectionViewLayout: layout)
        commentsViewController.commentID = videos[indexPath.item].commentID
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 200)
    }
    
    let sampleView = UIView()
    let uploadButton = UIButton(type: .system)
    let titleTextField = UITextField()
    var videoTitle = ""
    
    func handleUpload() {
        
        view.addSubview(sampleView)
        sampleView.translatesAutoresizingMaskIntoConstraints = false
        sampleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sampleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sampleView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        sampleView.backgroundColor = UIColor.lightGray
        sampleView.layer.masksToBounds = true
        sampleView.layer.cornerRadius = 10
        
        sampleView.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.setTitle("Upload Video", for: .normal)
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadButton.leftAnchor.constraint(equalTo: sampleView.leftAnchor, constant: 10).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: sampleView.bottomAnchor, constant: -30).isActive = true
        uploadButton.addTarget(self, action: #selector(upload), for: .touchUpInside)
        
        sampleView.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Enter title for your video"
        titleTextField.borderStyle = .roundedRect
        titleTextField.widthAnchor.constraint(equalToConstant: 180).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: sampleView.leftAnchor, constant: 10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: sampleView.topAnchor, constant: 40).isActive = true
        
        collectionView?.isHidden = true
    }
    
    func upload() {
        
        videoTitle = titleTextField.text!
        sampleView.isHidden = true
        collectionView?.isHidden = false
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoFile = info["UIImagePickerControllerMediaURL"] as? NSURL {
            
            uploadVideo(videoURL: videoFile)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // 1
    func uploadVideo(videoURL: NSURL) {
        
        let fileName = NSUUID().uuidString
        let uploadTask = FIRStorage.storage().reference().child("Videos").child("\(fileName).mov").putFile(videoURL as URL, metadata: nil) { (metadata, error) in
            
            if let error = error as NSError? {
                
                print(error.localizedDescription)
                return
            }
            
            let thumbnailImage: UIImage?
            
            if let uploadURL = metadata?.downloadURL()?.absoluteString {
                
                let asset = AVAsset(url: videoURL as URL)
                let assetGenerator = AVAssetImageGenerator(asset: asset)
                do {
                    let thumbnailCGImage = try assetGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                    thumbnailImage = UIImage(cgImage: thumbnailCGImage)
                    
                } catch let err {
                    print(err)
                    thumbnailImage = nil
                }
                
                let imageName = NSUUID().uuidString
                let ref = FIRStorage.storage().reference().child("Images").child("\(imageName).png")
                let uploadData = UIImageJPEGRepresentation(thumbnailImage!, 0.2)
                ref.put(uploadData!, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                        print("Failed to upload image: \(String(describing: error?.localizedDescription))")
                    }
                    
                    if let imageURL = metadata!.downloadURL()?.absoluteString {
                        
                        self.sendMessageWithVideoAndImage(thumbnailImage: thumbnailImage!, uploadURL: uploadURL, imageURL: imageURL)
                    }
                }
                
            }
            
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            
            if let completedBytes = snapshot.progress?.completedUnitCount {
                
                self.navigationItem.title = "\(completedBytes) bytes uploaded"
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            
            self.fetchUserNameAndDisplayNavBarTitle()
        }
    }
    
    // 2
    func sendMessageWithVideoAndImage(thumbnailImage: UIImage, uploadURL: String, imageURL: String) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://video-share-af1b2.firebaseio.com/")
        let usersReference = ref.child("videos")
        let childReference = usersReference.childByAutoId()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        let commentsID = NSUUID().uuidString
        
        let values = ["videoURL": uploadURL,
                      "imageURL": imageURL,
                      "title": videoTitle,
                      "views": 0,
                      "comments": commentsID] as [String : Any]
        
        childReference.updateChildValues(values, withCompletionBlock: {
            (errUpdate, ref) in
            
            if errUpdate != nil {
                print(errUpdate!.localizedDescription)
                return
            }
        })
        
        //videos = []
        //observeVideos()
    }
    
    func checkIfUserIsLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            fetchUserNameAndDisplayNavBarTitle()
        }
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        let loginViewController = LoginViewController()
        loginViewController.videosViewController = self
        present(loginViewController, animated: true, completion: nil)
    }
    
    func fetchUserNameAndDisplayNavBarTitle() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                self.navigationItem.title = dict["name"] as? String
            }
            
        }, withCancel: nil)
    }
}
