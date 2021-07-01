//
//  Download.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 01/07/21.
//

import Foundation

class Download {
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
}
