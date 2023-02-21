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
    @IBOutlet var totalShows: UILabel!
    
    private lazy var collectionDataSource = UICollectionViewDiffableDataSource<Section,TVShow>(collectionView: collectionView){
        collection, indexPath, show in
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "watchlistShow", for: indexPath) as! WatchlistCell
        
        cell.shortDesc.text = self.showStore.watchlist[indexPath.item].shortDescription
        cell.advisoryRating.text = self.showStore.watchlist[indexPath.item].contentAdvisoryRating
        cell.image.tintColor = UIColor.white
        if (self.showStore.watchlist[indexPath.item].contentAdvisoryRating == "TV-MA"){
            cell.image.image = UIImage(systemName: "person.crop.circle.fill.badge.xmark")
        }
        
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
        let width = (self.view.frame.width - 30) / 4
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalShows.text = "Total tv shows: \(showStore.watchlist.count)"
        loadSnapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first else {return}
        let selectedShow = collectionDataSource.itemIdentifier(for: selectedIndex)
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.selectedShow = selectedShow
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
