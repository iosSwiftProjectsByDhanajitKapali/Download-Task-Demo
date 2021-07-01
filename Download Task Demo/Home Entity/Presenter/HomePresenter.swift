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
    func stopDownloadAnimations()
}

class HomePresenter : NSObject{
    weak var delegate : HomePresenterDelegate!
    
    private var task : URLSessionDownloadTask!
    private var resumeData : Data?
    private var isDownloading = false
    private var downloadUrl : URL!
    private var destinationPath : URL!
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        //let configuration = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
      //let configuration = URLSessionConfiguration.background(withIdentifier: "com.dhanajitkapali")

      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: OperationQueue())
    }()
    
    init(withDelegate : HomePresenterDelegate ) {
        self.delegate = withDelegate
    }
    
    public func getFile(){
        //to download the a file
        let urlString = "https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf"
            //"https://www.cmu.edu/blackboard/files/evaluate/tests-example.xls"
            //"https://homepages.cae.wisc.edu/~ece533/images/arctichare.png"
            //"https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        guard let url = URL(string: urlString) else {return}
        downloadUrl =  url
        //let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        //task = urlSession.downloadTask(with: url)
        task = downloadsSession.downloadTask(with: url)
        task.resume()
        isDownloading = true
    }
    
    public func pauseDownload(){
        if isDownloading{
            task.cancel { (data) in
                self.resumeData = data
            }
            isDownloading = false
        }
    }
    
    public func resumeDownload(){
        if !isDownloading{
            //let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            if let data = resumeData{
                //task = urlSession.downloadTask(withResumeData: data)
                task = downloadsSession.downloadTask(withResumeData: data)
                    //downloadsSession.downloadTask(withResumeData: resumeData)
            }else{
                //task = urlSession.downloadTask(with: downloadUrl)
                task = downloadsSession.downloadTask(with: downloadUrl)
            }
        }
        task.resume()
        isDownloading = true
//        guard let resumeData = resumeData else {
//            // inform the user the download can't be resumed
//            return
//        }
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        let downloadTask = urlSession.downloadTask(withResumeData: resumeData)
//        downloadTask.resume()
//        self.downloadTask = downloadTask
    }
    
    public func cancelDownload(){
        task.cancel { resumeDataOrNil in
            guard let resumeData = resumeDataOrNil else {
              // download can't be resumed; remove from UI if necessary
              return
            }
            self.resumeData = resumeData
        }
        self.delegate.stopDownloadAnimations()
    }
}

//MARK: - Methods for downloading PDF
extension HomePresenter : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded in location ->", location)
    
        print("check 1")
        guard let url = downloadTask.originalRequest?.url else{ return }
        print(url)
        print("check 2")
        
        //setting the cache folder as the desitnation folder
        let cacheFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        destinationPath = cacheFolder.appendingPathComponent(url.lastPathComponent)

        //remove the file if its already at cache folder
        try? FileManager.default.removeItem(at: destinationPath)
        
        //copy the downloaded file from to temp, and change the name as its in the server
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            print(destinationPath!)
            print("Boom")
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
    
    //to pause the download
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            // Handle success case.
            return
        }
        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            self.resumeData = resumeData
        }
        // Perform any other error handling.
    }
    
    
}

