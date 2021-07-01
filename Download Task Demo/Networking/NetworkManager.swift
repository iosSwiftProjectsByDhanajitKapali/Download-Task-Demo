//
//  NetworkManager.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 30/06/21.
//

import Foundation

struct NetworkManager{
    func getApiData<T:Codable>(forUrl : URL, resultType:T.Type, completionHandler:@escaping(Result<T, ResponseStatus>)-> Void){
        
        URLSession.shared.dataTask(with: forUrl) { (data, response, error) in
            
            if let _ = error {
                print(K.ErrorMessage.API_CALL_ERROR)
                completionHandler(.failure(.error(err: error!.localizedDescription)))
            }
            guard let _ = data else{
                print(K.ErrorMessage.NO_DATA_RECIEVED)
                completionHandler(.failure(.invalidData))
                return
            }
            guard let _ = response else{
                print(K.ErrorMessage.INVALID_RESPONSE)
                completionHandler(.failure(.invalidResponse))
                return
            }
            do{
                let result = try JSONDecoder().decode(T.self, from: data!)
                completionHandler(.success(result))
               // print(result)
                
            }catch let err{
                print("\(K.ErrorMessage.JSON_PARSING_ERROR) ->\(err.localizedDescription)")
                completionHandler(.failure(.error(err: err.localizedDescription)))
            }
        }.resume()
    }
    
    
    func postApiData<T:Codable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(Result<T, ResponseStatus>)-> Void){
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = K.Networking.HttpMethod.POST_METHOD
        urlRequest.httpBody = requestBody
        urlRequest.addValue(K.Networking.HeaderFieldValue.BODY_DATA_TYPE_IS_JSON, forHTTPHeaderField: K.Networking.HeaderFieldValue.CONTENT_TYPE)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let _ = error{
                print(K.ErrorMessage.API_CALL_ERROR)
                completionHandler(.failure(.error(err: error!.localizedDescription)))
            }
            guard let _ = data else{
                print(K.ErrorMessage.NO_DATA_RECIEVED)
                completionHandler(.failure(.invalidData))
                return
            }
            guard let _ = response else{
                print(K.ErrorMessage.INVALID_RESPONSE)
                return
            }
            do{
                let result = try JSONDecoder().decode(T.self, from: data!)
                completionHandler(.success(result))
               // print(result)
                
            }catch let err{
                print("\(K.ErrorMessage.JSON_PARSING_ERROR) ->\(err.localizedDescription)")
                completionHandler(.failure(.decodingError(err: err.localizedDescription)))
            }
            
        }.resume()
    }
    
    func getFileFrom(url : URL, completionHandler : @escaping(Result<URL,ResponseStatus>)-> Void){
        URLSession.shared.downloadTask(with: url) { (downloadedFileUrl, response, error) in
            if let _ = error{
                print("Error downloading the file")
                completionHandler(.failure(.error(err: error!.localizedDescription)))
            }
            
            if let url = downloadedFileUrl{
                completionHandler(.success(url))
            }
            
        }.resume()
    }
    
    func downloadFile(url : URL, fileName : String, completionHandler : @escaping(Result<URL,ResponseStatus>)-> Void){
     
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data , error == nil else{ return }
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            do{
                try data?.write(to: tempURL)
                completionHandler(.success(tempURL))
            }catch{
                completionHandler(.failure(.error(err: error.localizedDescription)))
            }
            
        }.resume()
    }
    
    
}

enum ResponseStatus : Error{
    case error(err : String)
    case invalidResponse
    case invalidData
    case decodingError(err : String)
}
