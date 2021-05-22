//
//  FavoriteChannelsHandler.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

class FavoriteChannelsHandler {
    private(set) var ids: [String] {
        get {
            UserDefaults.standard.array(forKey: .favoritesKey) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .favoritesKey)
        }
    }
    
    private func saveIDs() {
        UserDefaults.standard.set(ids, forKey: .favoritesKey)
    }
    
    public func addFavorite(_ id: String) {
        guard !ids.contains(id) else { return }
        ids.append(id)
        saveIDs()
    }
    
    public func removeFavorite(_ id: String) {
        guard ids.count != 0 else { return }
        for checkedID in ids {
            if checkedID == id {
                if let index = ids.firstIndex(of: checkedID) {
                    ids.remove(at: index)
                }
            }
        }
        saveIDs()
    }
}
