//
//  ShowStore.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import Foundation

class ShowStore{
    var watchlist = [TVShow]()
    
    var documentDirectory: URL?{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path[0])
        return path[0]
    }
    
    func removeShow(show: TVShow){
        guard let index = watchlist.firstIndex(of: show) else { return }
        watchlist.remove(at: index)
        saveToWatchlist()
    }
    
    func saveToWatchlist(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("watchlist.json")
        save(to: fileName)
    }
    
    func save(to url: URL){
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(watchlist)
            try jsonData.write(to: url)
        } catch {
            print("Error encoding - \(error.localizedDescription)")
        }
    }
    
    func retrieveWatchlist(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("watchlist.json")
        retrieve(from: fileName)
    }
    
    func retrieve(from url: URL){
        do{
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            watchlist = try decoder.decode([TVShow].self, from: jsonData)
        } catch {
            print("Error decoding - \(error.localizedDescription)")
        }
    }

    
}
