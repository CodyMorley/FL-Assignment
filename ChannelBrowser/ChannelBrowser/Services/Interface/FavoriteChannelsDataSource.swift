//
//  FavoriteChannelsDataSource.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class FavoriteChannelsDataSource: NSObject, UITableViewDataSource {
    private var favorites = FavoriteChannelsHandler() {
        didSet {
            dataChanged?()
        }
    }
    var channelFetcher = ChannelFetcher.shared
    var favoriteChannels: [Channel] = [] {
        didSet {
            dataChanged?()
        }
    }
    var dataChanged: (() -> Void)?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .channelCell,
                                                       for: indexPath) as? ChannelTableViewCell else {
            NSLog("Unable to return ChannelTableViewCell from given parameters.")
            return UITableViewCell()
        }
        
        let channel = favoriteChannels[indexPath.row]
        cell.djTextLabel.text = channel.dj
        cell.titleTextLabel.text = channel.title
        cell.infoTextLabel.text = channel.description
        loadImage(forCell: cell, forItemAt: indexPath)
        return cell
    }
    
    
    public func starChannel(_ channel: Channel) {
        if favorites.ids.contains(channel.id) {
            favorites.removeFavorite(channel.id)
            dataChanged?()
        } else {
            favorites.addFavorite(channel.id)
            dataChanged?()
        }
    }
    
    
    private func getFavorites() {
        favoriteChannels = channelFetcher.channels.filter({ favorites.ids.contains($0.id) })
        dataChanged?()
    }
    
    
    private func loadImage(forCell cell: ChannelTableViewCell, forItemAt indexPath: IndexPath) {
        let channel = favoriteChannels[indexPath.row]
        let id = channel.id
        
        if let cachedData = channelFetcher.imageHandler.imageCache.value(for: id) {
            cell.channelImageView.image = UIImage(data: cachedData)
            return
        }
        
        let fetchPhoto = FetchPhotoOperation(channel)
        let cachePhoto = BlockOperation {
            if let fetchedPhoto = fetchPhoto.imageData {
                self.channelFetcher.imageHandler.imageCache.cache(for: id, value: fetchedPhoto)
            }
        }
        let completePhotoOperation = BlockOperation {
            if let fetchedPhoto = fetchPhoto.imageData {
                cell.channelImageView.image = UIImage(data: fetchedPhoto)
            }
        }
        
        cachePhoto.addDependency(fetchPhoto)
        completePhotoOperation.addDependency(fetchPhoto)
        channelFetcher.imageHandler.imageFetchQueue.addOperations([fetchPhoto, cachePhoto], waitUntilFinished: false)
        OperationQueue.main.addOperation(completePhotoOperation)
        channelFetcher.imageHandler.operations[id] = fetchPhoto
    }
}
