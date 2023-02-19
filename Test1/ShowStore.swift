//
//  ShowStore.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import Foundation

class ShowStore{
    var watchlist = [TVShow]()
    
    func removeShow(show: TVShow){
        guard let index = watchlist.firstIndex(of: show) else { return }
        watchlist.remove(at: index)
    }
    
}
