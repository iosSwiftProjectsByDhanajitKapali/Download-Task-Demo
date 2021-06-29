//
//  HomePresenter.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 29/06/21.
//

import Foundation

protocol HomePresenterDelegate : AnyObject {
    func presentAlert(title: String, message: String)
    func previewAndShareFile(atLocation: URL)
    func updateProgressBar(withProgress : Float)
}

class HomePresenter : NSObject{
    weak var delegate : HomePresenterDelegate!
    
    init(withDelegate : HomePresenterDelegate ) {
        self.delegate = withDelegate
    }
    
    public func getFile(){
        //to download the a file
        let urlString = "https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf"
            //"https://homepages.cae.wisc.edu/~ece533/images/arctichare.png"
            //"https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        guard let url = URL(string: urlString) else {return}
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let task = urlSession.downloadTask(with: url)
        task.resume()
    }
}

//MARK: - Methods for downloading PDF
extension HomePresenter : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded in location ->", location)
    
        
        guard let url = downloadTask.originalRequest?.url else{ return }
        
        //setting the cache folder as the desitnation folder
        let cacheFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = cacheFolder.appendingPathComponent(url.lastPathComponent)

        //remove the file if its already at cache folder
        try? FileManager.default.removeItem(at: destinationPath)
        
        //copy the downloaded file from to temp, and change the name as its in the server
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            print(destinationPath)
            self.delegate.previewAndShareFile(atLocation: destinationPath) //present the file downloaded
        
        }catch let error {
            print("Copy Error ->\(error.localizedDescription)")
        }
        
    }
    
    //to get the progress of download
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.delegate.updateProgressBar(withProgress: progress)
    }
}

