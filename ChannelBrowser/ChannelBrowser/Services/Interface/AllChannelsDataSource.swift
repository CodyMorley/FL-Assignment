//
//  AllChannelsDataSource.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class AllChannelsDataSource: NSObject, UITableViewDataSource {
    //MARK: - Types -
    enum FilterType {
        case none
        case title
        case dj
    }
    
    
    //MARK: - Properties -
    private(set) var filter: FilterType = .none {
        didSet {
            dataChanged?()
        }
    }
    private(set) var channelFetcher = ChannelFetcher.shared
    private(set) var filterText: String? {
        didSet {
            dataChanged?()
        }
    }
    var channels: [Channel] { channelFetcher.channels }
    var filteredChannels: [Channel] {
        switch filter {
        case .none:
            return channels
        case .title:
            return channels.filter({
                $0.title.lowercased() == filterText?.lowercased()
            })
        case .dj:
            return channels.filter({
                $0.dj.lowercased() == filterText?.lowercased()
            })
        }
    }
    var dataChanged: (() -> Void)?
    
    
    //MARK: - TableView Data Source -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .channelCell,
                                                       for: indexPath) as? ChannelTableViewCell else {
            NSLog("Unable to return ChannelTableViewCell from given parameters.")
            return UITableViewCell()
        }
        
        let channel = filteredChannels[indexPath.row]
        cell.djTextLabel.text = channel.dj
        cell.titleTextLabel.text = channel.title
        cell.infoTextLabel.text = channel.description
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    private func loadImage(forCell cell: ChannelTableViewCell, forItemAt indexPath: IndexPath) {
        let channel = filteredChannels[indexPath.row]
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
    
    public func changeFilterText(_ text: String?) {
        filterText = text
    }
    
    public func changeFilter(filterType: FilterType) {
        filter = filterType
    }
}
