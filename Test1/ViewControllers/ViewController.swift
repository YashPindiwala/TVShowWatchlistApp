//
//  ViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    var shows = [TVShow]()
    var showStore: ShowStore!
    
    //MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // datasource for the table-view
    private lazy var tableDataSource = UITableViewDiffableDataSource<Section, TVShow>(tableView: tableView){
        tableview, index, show in
        let cell = tableview.dequeueReusableCell(withIdentifier: "tvShow", for: index) as! TVShowCell

        cell.trackName.text = show.trackName
        cell.collectionName.text = show.collectionName
        cell.shortDesc.text = show.shortDescription
        cell.trackPrice.text = "$\(show.trackPrice)"

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
    }
    
    //MARK: - Methods
    func createDataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shows, toSection: .main)
        tableDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    // this method will create the URL with search term
    func createUrl(from: String) -> URL?{
        guard let cleanURL = from.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { fatalError("Cannot make URL!.") }
        
        var urlString = "https://itunes.apple.com/search"
        urlString = urlString.appending("?term=\(cleanURL)")
        urlString = urlString.appending("&media=tvShow")
        
        return URL(string: urlString)
    }
    
    // the method below will fetch the shows from the server asynchronously
    func fetchShows(from: URL){
        let dataTask = URLSession.shared.dataTask(with: from){
            data, response, error in
            if let dataError = error{
                print("Could not fetch Shows \(dataError.localizedDescription)")
            } else {
                do {
                    guard let someData = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(Result.self, from: someData)
                    self.shows = result.results
                } catch DecodingError.keyNotFound(let key, let context){
                    //key that does not exist
                    print("Decoding Error - missing key [\(key)] - for context: \(context)")
                }catch DecodingError.typeMismatch(let type, let context){
                    //type doesnot math to the class properties
                    print("Decoding Error - type does not match [\(type)] - for context:\(context)" )
                }
                catch DecodingError.valueNotFound(let value, let context){
                    //there is no associated value - nil returned
                    print("Decoding Error - value not found [\(value)] - for context: \(context)")
                } catch {
                    print("Problem decoding: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.createDataSnapshot()
                }
            }
        }
        dataTask.resume()
    }

}

//MARK: - Extensions
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //make sure there is some text - if not just return
        guard let searchText = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        //if we can create a movie url with the text, fetch the movies using it
        if let show = createUrl(from: searchText){
            fetchShows(from: show)
        }
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDelegate{
    // the method below will add the show to the watchlist
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShow = shows[indexPath.row]
        var title: String = ""
        var message: String = ""
        
        if !showStore.watchlist.contains(selectedShow){// if the watchlist already has the show it will not add to the watchlist and will notify user
            showStore.watchlist.append(selectedShow)
                title = "Show Added"
                message = "\(selectedShow.trackName)"
                showStore.saveToWatchlist()
        } else {
            title = "\(selectedShow.trackName) is already in your watch list"
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
    }
}

enum Section {
    case main
}
