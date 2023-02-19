//
//  WatchlistViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import UIKit

class WatchlistViewController: UIViewController {
    var showStore: ShowStore!
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var collectionDataSource = UICollectionViewDiffableDataSource<Section,TVShow>(collectionView: collectionView){
        collection, indexPath, show in
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "watchlistShow", for: indexPath) as! WatchlistCell
        
        cell.shortDesc.text = self.showStore.watchlist[indexPath.item].shortDescription
        cell.advisoryRating.text = self.showStore.watchlist[indexPath.item].contentAdvisoryRating
        
        return cell
    }
    
    
    func loadSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,TVShow>()
        snapshot.appendSections([.main])
        snapshot.appendItems(showStore.watchlist, toSection: .main)
        collectionDataSource.apply(snapshot)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSnapshot()
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
