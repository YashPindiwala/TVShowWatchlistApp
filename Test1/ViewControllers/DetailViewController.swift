//
//  DetailViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-20.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Property
    var selectedShow: TVShow!
    var showStore = ShowStore()
    
    //MARK: - Outlets
    @IBOutlet var trackName: UILabel!
    @IBOutlet var collectionName: UILabel!
    @IBOutlet var advisoryRating: UILabel!
    @IBOutlet var collectionPrice: UILabel!
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var longDescription: UITextView!
    
    //MARK: - Action
    // the method below will ask user if they want to delete the current show
    @IBAction func deleteShow(_ sender: UIBarButtonItem) {
        let message = "Do you want to remove \(selectedShow.trackName)"
        let ac = UIAlertController(title: "Delete TV Show?", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            [weak self] _ in
            guard let showToRemove = self?.selectedShow else { return }
            self?.showStore.removeShow(show: showToRemove) // this statement will delete the show from the list as well from the watchlist.json file
            self?.navigationController?.popViewController(animated: true)
        }
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        present(ac, animated: true)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedShow = selectedShow else { return }
        trackName.text = selectedShow.trackName
        collectionName.text = selectedShow.collectionName
        advisoryRating.text = selectedShow.contentAdvisoryRating
        collectionPrice.text = "$\(selectedShow.collectionPrice)"
        longDescription.text = selectedShow.longDescription
        loadImage()
        
    }
    
    //MARK: - Methods
    // the method below will fetch image from the server
    func loadImage(){
        guard let imageUrl = URL(string: selectedShow.artworkUrl100) else {
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in

            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.trackImage.image = image
                }
            }
        }

        imageFetchTask.resume()
    }
}
