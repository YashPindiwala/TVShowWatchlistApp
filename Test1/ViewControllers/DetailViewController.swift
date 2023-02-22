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
    
    //MARK: - Outlets
    
    @IBOutlet var trackName: UILabel!
    @IBOutlet var collectionName: UILabel!
    @IBOutlet var advisoryRating: UILabel!
    @IBOutlet var collectionPrice: UILabel!
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var longDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedShow = selectedShow else { return }
        trackName.text = selectedShow.trackName
        collectionName.text = selectedShow.collectionName
        advisoryRating.text = selectedShow.contentAdvisoryRating
        collectionPrice.text = "\(selectedShow.collectionPrice)"
        longDescription.text = selectedShow.longDescription
        loadImage()
        
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
