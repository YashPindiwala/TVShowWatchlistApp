//
//  WatchlistViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import UIKit

class WatchlistViewController: UIViewController {
    //MARK: - Properties
    var showStore: ShowStore!
    
    //MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var totalShows: UILabel!
    
    // datasource for the collection-view
    private lazy var collectionDataSource = UICollectionViewDiffableDataSource<Section,TVShow>(collectionView: collectionView){
        collection, indexPath, show in
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "watchlistShow", for: indexPath) as! WatchlistCell
        
        cell.shortDesc.text = self.showStore.watchlist[indexPath.item].shortDescription
        cell.advisoryRating.text = self.showStore.watchlist[indexPath.item].contentAdvisoryRating
        cell.image.tintColor = UIColor.white
        if (self.showStore.watchlist[indexPath.item].contentAdvisoryRating == "TV-MA"){
            cell.image.image = UIImage(systemName: "person.crop.circle.fill.badge.xmark")
        }
        let showImageURL = self.showStore.watchlist[indexPath.item].artworkUrl100
        self.fetchImage(for: showImageURL, in: cell)        
        
        return cell
    }
    
    //MARK: - Methods
    func loadSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,TVShow>()
        snapshot.appendSections([.main])
        snapshot.appendItems(showStore.watchlist, toSection: .main)
        collectionDataSource.apply(snapshot)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting 4 cells in row
        let width = (self.view.frame.width - 30) / 4
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        showStore.retrieveWatchlist() // if the watchlist is available then load the shows
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
        destinationVC.selectedShow = selectedShow // sending data to show on detail screen
        destinationVC.showStore = showStore // sending the reference so it can be deleted from the detail screen
    }

    // the method below will fetch image from the server
    func fetchImage(for path: String, in cell: WatchlistCell){

        guard let imageUrl = URL(string: path) else {
            return
        }

        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in

            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    cell.showImage.image = image
                }
            }
        }

        imageFetchTask.resume()
    }

}
