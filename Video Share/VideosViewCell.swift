//
//  VideosViewCell.swift
//  Video Share
//
//  Created by Samarth Paboowal on 09/04/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit
import AVFoundation

class VideosViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    let mainView = UIView()
    let videoView = UIView()
    let image = UIImageView()
    let playButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let likesLabel = UILabel()
    let commentsLabel = UILabel()
    let line = UIView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupUI() {
        
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainView.backgroundColor = UIColor.lightGray
        
        mainView.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        videoView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -40).isActive = true
        
        videoView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        image.backgroundColor = UIColor.black
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        //image.backgroundColor = UIColor.brown
        image.clipsToBounds = true
        
        let playImage = UIImage(named: "play")
        playButton.setImage(playImage, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = UIColor.white
        videoView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        
        mainView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 4).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 4).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -4).isActive = true
        titleLabel.text = ""
        titleLabel.textAlignment = .center
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        videoView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var video: Video?
    
    func playVideo() {
        
        if let videoURL = video?.videoURL {
            
            let url = URL(string: videoURL)
            player = AVPlayer(url: url!)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoView.bounds
            videoView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicator.startAnimating()
            playButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        activityIndicator.stopAnimating()
    }
    
        required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
