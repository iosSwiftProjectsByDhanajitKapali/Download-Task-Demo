//
//  ITunesViewController.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 30/06/21.
//

import UIKit
import AVFoundation

class ITunesViewController: UIViewController {

    @IBOutlet var searchMusicTextField: UITextField!
    @IBOutlet var musicDetailsTableView: UITableView!
    
    private var presenter : ITunesPresenter!
    private var audioPlayer : AVAudioPlayer?
    
    private var songID : Int?
    private var songsDetails = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ITunesPresenter(withDelegate: self)
        
        //register the xib cell in the tableView
        musicDetailsTableView.register(UINib(nibName:"ITunesTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        musicDetailsTableView.delegate = self
        musicDetailsTableView.dataSource = self
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let songTitle = searchMusicTextField.text, !songTitle.isEmpty{
            presenter.searchSongs(withTitle: songTitle)
        }
    }
    
}

extension ITunesViewController : ITunesPresenterDelegate{
    func updateSongs(downloadLocation : URL) {
        //print(fromLocation)
        DispatchQueue.main.async { [self] in
            for i in 0...songsDetails.count-1{
                if songsDetails[i].index == songID{
                    songsDetails[i].isDownloaded = true
                    songsDetails[i].localURL = downloadLocation
                }
            }
            musicDetailsTableView.reloadData()
        }
    }
    
    
    func presentSongs(songs: [Track]) {
        DispatchQueue.main.async {
            self.songsDetails = songs
            self.musicDetailsTableView.reloadData()
        }
    }
    
   
    func presentAlert(withTitle: String, message: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Alert", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func updateProgressBar(withProgress: Float) {
        DispatchQueue.main.async { [self] in
            //progressBar.progress = withProgress
            print(withProgress)
        }
    }

}

//MARK: - Private Functions
extension ITunesViewController {
    private func playSong(fromLocation : URL){
        if let player = audioPlayer, player.isPlaying{
            //stop playing music
            player.stop()
        }else{
            //set up player, and play song
            do{
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                audioPlayer = try AVAudioPlayer(contentsOf: fromLocation)
                
                guard let player = audioPlayer  else { return }
                player.play()
            }catch{
                presentAlert(withTitle: "Error", message: "Error While Plasying the Song")
                print("Error While Plasying the Song")
            }
        }
        print(fromLocation)
    }
}


extension ITunesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicDetailsTableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ITunesTableViewCell
        cell.delegate = self
       
        cell.songNameTextLabel.text = songsDetails[indexPath.row].name
        cell.songsArtistNameTextLabel.text = songsDetails[indexPath.row].artist
        cell.trackId = songsDetails[indexPath.row].index
        
        ///If song is already downloaded
        if songsDetails[indexPath.row].isDownloaded{
            cell.downloadButton.isHidden = true
            cell.pauseDownloadButton.isHidden = true
            cell.resumeDownloadButton.isHidden = true
            cell.cancelDownloadButton.isHidden = true
        }else{
            cell.downloadButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        musicDetailsTableView.deselectRow(at: indexPath, animated: true)
        
        if songsDetails[indexPath.row].isDownloaded{
            playSong(fromLocation: songsDetails[indexPath.row].localURL!)
        }
    }
    
    
    
    
}

extension ITunesViewController : ITunesTableViewCellDelegate{
    func downloadButtonPressed(forSongID: Int) {
        print("download")
        print(forSongID)
        var songPreviewLink : URL?
        for i in 0...songsDetails.count-1{
            let songDetail = songsDetails[i]
            if songDetail.index == forSongID{
                songPreviewLink = songDetail.previewURL
                break
            }
        }
        presenter.downloadSong(atUrl: songPreviewLink ?? nil)
        songID = forSongID
    }
    
    func cancelDownloadPressed(forSongID: Int) {
        print("cancel")
    }
    
    func pauseDownloadButtonPressed(forSongID: Int) {
        print("pause")
    }
    
    func resumeDownloadButtonPressed(forSongID: Int) {
        print("resume")
    }
    
}
