//
//  MapPopupViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 14/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit
import AVFoundation


class MapPopupViewController: UIViewController {

    @IBOutlet weak var soundTitleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mapPopupView: UIView!
    @IBOutlet weak var audioCurrent: UILabel!

    @IBOutlet weak var playButton: UIButton!

    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    var timer: Timer!
    
    // Sound info
    @IBOutlet weak var soundTitle: UILabel!
    @IBOutlet weak var soundDescript: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    var tmpOwner: String?
    var tmpDescript: String?
    var tmpTitle: String?
    var tmpImage: UIImage?
    var soundURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set design attributes
        mapPopupView.layer.cornerRadius = 10
        mapPopupView.layer.masksToBounds = true
        soundTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)

        // Set image to circle
        //profileImage.frame = CGRect(x: 85, y: 124, width: 150, height: 150) ; // set as you want
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 86/255, green: 86/255, blue: 1/255, alpha: 1).cgColor
        
        // Set data
        soundTitle.text = tmpTitle
        soundDescript.text = tmpDescript
        owner.text = tmpOwner
        ownerImage.image = tmpImage
        
        // Look for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapPopupViewController.dismissPopup))
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Initialize audio
        self.isPaused = false;
        do {
            let playerItem = AVPlayerItem(url: URL(string: soundURL!)!)
            try self.remotePlayer = AVPlayer(playerItem: playerItem)
            self.remotePlayer.volume = 1.0
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Close popup
    func dismissPopup() {
        //remotePlayer.pause()
        dismiss(animated: true, completion: nil)
    }

    
    /****** Audio ******/
    @IBAction func playAudioPressed(_ sender: Any) {
        if ( self.isPaused == false ) {
            remotePlayer.play()
            playButton.setImage(UIImage(named: "music-pause2"), for: .normal)
            self.isPaused = true
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        } else {
            remotePlayer.pause()
            playButton.setImage(UIImage(named: "music-play2"), for: .normal)
            self.isPaused = false
            timer.invalidate()
        }
    }
    
    /*@IBAction func slide(_ sender: Any) {
        player.currentTime = TimeInterval(audioSlider.value)
    }*/
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stringFromFloatCMTime(time: Double) -> String {
        let intTime = Int(time)
        let seconds = intTime % 60
        let minutes = ( intTime / 60 ) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateTime(_ timer: Timer) {
        let currentTimeInSeconds = CMTimeGetSeconds((remotePlayer.currentItem?.currentTime())!)
        audioCurrent.text = stringFromFloatCMTime(time: currentTimeInSeconds)
    }


}
