//
//  ViewController.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import UIKit

class ViewController: UIViewController {
    
    var shows = [TVShow]()
    
    //MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

