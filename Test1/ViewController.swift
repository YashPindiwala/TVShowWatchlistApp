//
//  ViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    var shows = [TVShow]()
    
    //MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private lazy var tableDataSource = UITableViewDiffableDataSource<Section, TVShow>(tableView: tableView){
        tableview, index, show in
        let cell = tableview.dequeueReusableCell(withIdentifier: "tvShow", for: index) as! TVShowCell

        cell.trackName.text = show.trackName
        cell.collectionName.text = show.collectionName
        cell.shortDesc.text = show.shortDescription
        cell.trackPrice.text = "\(show.trackPrice)"

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
    }
    
    func createDataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shows, toSection: .main)
        tableDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    
    func createUrl(from: String) -> URL?{
        guard let cleanURL = from.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { fatalError("Cannot make URL!.") }
        
        var urlString = "https://itunes.apple.com/search"
        urlString = urlString.appending("?term=\(cleanURL)")
        urlString = urlString.appending("&media=tvShow")
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
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
                    //you asked for a key that does not exist
                    print("Decoding Error - missing key [\(key)] - for context: \(context)")
                }catch DecodingError.typeMismatch(let type, let context){
                    //you asked to match one type (i.e. Int) and got back something different (i.e. String)
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

//extension ViewController: UITableViewDelegate{
//    //deselect any selected row
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

enum Section {
    case main
}
