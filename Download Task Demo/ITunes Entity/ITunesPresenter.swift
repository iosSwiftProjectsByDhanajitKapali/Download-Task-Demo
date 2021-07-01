//
//  ITunesPresenter.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 30/06/21.
//

import Foundation

protocol ITunesPresenterDelegate : AnyObject {
    func presentAlert(withTitle : String, message : String)
    func presentSongs(songs: [Track])
    func updateSongs(downloadLocation : URL)
    func updateProgressBar(withProgress : Float)
}

class ITunesPresenter : NSObject{
    weak var delegate : ITunesPresenterDelegate!
    
//    let defaultSession = URLSession(configuration: .default)
//    var dataTask: URLSessionDataTask?
    
    private var downloadUrl : URL!
    private var destinationPath : URL!
    private var task : URLSessionDownloadTask!
    private var resumeData : Data?
    private var isDownloading = false
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        //let configuration = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
      //let configuration = URLSessionConfiguration.background(withIdentifier: "com.dhanajitkapali")

      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: OperationQueue())
    }()

    init(withDelegate : ITunesPresenterDelegate) {
        self.delegate = withDelegate
    }
    
    ///Function to fetch list of longs accroding to the song title
    func searchSongs(withTitle : String){
        let urlString = "https://itunes.apple.com/search"
        
        if var urlComponents = URLComponents(string: urlString){
            urlComponents.query = "media=music&entity=song&term=\(withTitle)"
            
            guard let url = urlComponents.url else { return }
            //print(url)
            NetworkManager().downloadFile(url: url, fileName: "JSON.txt") { (result) in
                switch result{
                case .success(let downloadFileLocation):
                    //print(downloadFileLocation)
                    let jsonData = self.readLocalFile()
                    let dict = self.decodeJSONtoDict(data: jsonData!)
                    let tracks = self.getTrackDataArray(dict)
                    self.delegate.presentSongs(songs: tracks)
                case .failure(let error):
                    self.delegate.presentAlert(withTitle: "Alert", message: error.localizedDescription)
                }
            }
        }
    }
    
    func downloadSong(atUrl : URL?){
        if let url = atUrl{
            downloadUrl =  url
            //let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            //task = urlSession.downloadTask(with: url)
            task = downloadsSession.downloadTask(with: url)
            task.resume()
            //isDownloading = true
        }
    }
}

//MARK: - Private Functions
extension ITunesPresenter {
    
    ///Function to create a Array Of Tracks from the Dictionary
    private func getTrackDataArray(_ dict : Dictionary<String,Any>) -> [Track]{
        let songsDetails = dict["results"] as! [Any]
        var tracks = [Track]()
        for i in 0...songsDetails.count-1{
            let songDetail = songsDetails[i] as! Dictionary<String,Any>
            let artist = songDetail["artistName"] as! String
            let index = songDetail["trackId"] as! Int
            let name = songDetail["trackName"] as! String
            let previewURL = URL(string: songDetail["previewUrl"] as! String)
            let temp = Track(artist: artist, index: index, name: name, previewURL: previewURL!)
            
            tracks.append(temp)
        }
        return tracks
    }
    
    ///Function to extract contents from the text file
    private func getTextFileContent(withFileName : String) -> String{
        var fileData = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(withFileName)
            //reading
            do {
                fileData = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        return fileData
    }
    
    ///Function to locate and convert the contents of the text file into JSON data
    private func readLocalFile() -> Data? {
        do {
            let tempFolderPath = getTempDirectoryPath()
            let bundlePath = tempFolderPath.appendingPathComponent("JSON.txt")
            let urlString = try String(contentsOf: bundlePath)
            
            //conver the data to JSON
            return Data(urlString.utf8)
        } catch {
            print(error)
        }
        return nil
    }
    
    ///Function to convert the JSON data to a Dictionary
    private func decodeJSONtoDict(data : Data) -> Dictionary<String,Any>{
        // make sure this JSON is in the format we expect
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dict = json as! [String : Any]
        return dict
    }
    
    /// Get user's temp directory path
     func getTempDirectoryPath() -> URL {
       let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
       return tempDirectoryPath
     }
}


//MARK: - Methods for downloading PDF
extension ITunesPresenter : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //print("File Downloaded in location ->", location)
    
        //print("check 1")
        guard let url = downloadTask.originalRequest?.url else{ return }
        //print(url)
        //print("check 2")
        
        //setting the cache folder as the desitnation folder
        let cacheFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        destinationPath = cacheFolder.appendingPathComponent(url.lastPathComponent)

        //remove the file if its already at cache folder
        try? FileManager.default.removeItem(at: destinationPath)
        
        //copy the downloaded file from to temp, and change the name as its in the server
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            print(destinationPath!)
            //print("Boom")
            self.delegate.updateSongs(downloadLocation : destinationPath)
            //self.delegate.previewAndShareFile(atLocation: destinationPath) //present the file downloaded
        
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
