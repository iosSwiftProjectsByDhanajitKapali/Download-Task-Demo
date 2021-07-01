////
////  DownloadService.swift
////  Download Task Demo
////
////  Created by unthinkable-mac-0025 on 01/07/21.
////
//
//import Foundation
//
//class DownloadService {
//  //
//  // MARK: - Variables And Properties
//  //
//  // TODO 4
//  var activeDownloads: [URL: Download] = [:]
//
//  
//  /// SearchViewController creates downloadsSession
//  var downloadsSession: URLSession!
//  
//  //
//  // MARK: - Internal Methods
//  //
//  // TODO 9
//  func cancelDownload(_ track: Track) {
//    guard let download = activeDownloads[track.previewURL] else {
//      return
//    }
//
//    download.task?.cancel()
//    activeDownloads[track.previewURL] = nil
//
//  }
//  
//  // TODO 10
//  func pauseDownload(_ track: Track) {
//    guard let download = activeDownloads[track.previewURL], download.isDownloading else { return }
//
//    download.task?.cancel(byProducingResumeData: { data in
//      download.resumeData = data
//    })
//
//    download.isDownloading = false
//
//  }
//  
//  // TODO 11
//  func resumeDownload(_ track: Track) {
//    guard let download = activeDownloads[track.previewURL] else {
//      return
//    }
//
//    if let resumeData = download.resumeData {
//      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
//    } else {
//      download.task = downloadsSession.downloadTask(with: download.track.previewURL)
//    }
//
//    download.task?.resume()
//    download.isDownloading = true
//
//  }
//  
//  // TODO 8
//  func startDownload(_ track: Track) {
//    // 1
//    let download = Download(track: track)
//    // 2
//    download.task = downloadsSession.downloadTask(with: track.previewURL)
//    // 3
//    download.task?.resume()
//    // 4
//    download.isDownloading = true
//    // 5
//    activeDownloads[download.track.previewURL] = download
//
//  }
//}
