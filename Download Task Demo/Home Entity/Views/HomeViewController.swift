//
//  ViewController.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 29/06/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var acitvityIndicator: UIActivityIndicatorView!
    
    private var presenter : HomePresenter!
    
    private var documentController : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = HomePresenter(withDelegate: self)
        documentController = UIDocumentInteractionController()
        
        progressBar.progress = 0
        acitvityIndicator.isHidden = true
    }

    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        presenter.getFile()
        downloadButton.isEnabled = false
        acitvityIndicator.isHidden = false
        acitvityIndicator.startAnimating()
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        presenter.pauseDownload()
    }
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        presenter.resumeDownload()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        presenter.cancelDownload()
    }
}

extension HomeViewController : HomePresenterDelegate{
    func stopDownloadAnimations() {
        progressBar.progress = 0
        acitvityIndicator.stopAnimating()
        acitvityIndicator.isHidden = true
        downloadButton.isEnabled = true
    }
    
    func updateProgressBar(withProgress: Float) {
        DispatchQueue.main.async { [self] in
            progressBar.progress = withProgress
        }
    }
    
    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Alert", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func previewAndShareFile(atLocation: URL) {
        DispatchQueue.main.async { [self] in
            acitvityIndicator.stopAnimating()
            acitvityIndicator.isHidden = true
            downloadButton.isEnabled = true
            
            //initiate the shareSheet with its preview
            documentController.url = atLocation
            documentController.delegate = self
            documentController.presentPreview(animated: true)
        }
    }
    
}

extension HomeViewController : UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        progressBar.progress = 0
    }
    
    
}
