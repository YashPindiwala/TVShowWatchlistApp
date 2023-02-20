//
//  DetailViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-20.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var trackName: UILabel!
    @IBOutlet var collectionName: UILabel!
    @IBOutlet var advisoryRating: UILabel!
    @IBOutlet var collectionPrice: UILabel!
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var longDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
