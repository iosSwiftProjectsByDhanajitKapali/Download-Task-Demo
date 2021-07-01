//
//  ITunesTableViewCell.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 30/06/21.
//

import UIKit

protocol ITunesTableViewCellDelegate {
    func downloadButtonPressed(forSongID : Int)
    func cancelDownloadPressed(forSongID : Int)
    func pauseDownloadButtonPressed(forSongID : Int)
    func resumeDownloadButtonPressed(forSongID : Int)
}

class ITunesTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var songNameAndArtistStackView: UIStackView!
    @IBOutlet var songNameTextLabel: UILabel!
    @IBOutlet var songsArtistNameTextLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var cancelDownloadButton: UIButton!
    @IBOutlet var pauseDownloadButton: UIButton!
    @IBOutlet var resumeDownloadButton: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    
    var delegate : ITunesTableViewCellDelegate?
    var trackId : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        songNameAndArtistStackView.trailingAnchor.constraint(equalTo: self.containerView.widthAnchor)
        
        cancelDownloadButton.isHidden = true
        pauseDownloadButton.isHidden = true
        resumeDownloadButton.isHidden = true
        progressBar.progress = 0
        progressBar.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        delegate?.downloadButtonPressed(forSongID: trackId)
    }
    
    @IBAction func cancelDownloadButtonPressed(_ sender: UIButton) {
        delegate?.cancelDownloadPressed(forSongID: trackId)
    }
    
    @IBAction func pauseDownloadButtonPressed(_ sender: UIButton) {
        delegate?.pauseDownloadButtonPressed(forSongID: trackId)
    }
    
    @IBAction func resumeDownloadButtonPressed(_ sender: UIButton) {
        delegate?.resumeDownloadButtonPressed(forSongID: trackId)
    }
    
    
}
