//
//  FavoritesTableViewController.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class FavoritesTableViewController: UIViewController, UITableViewDelegate {
    //MARK: - Properties -
    ///Interface Outlets
    @IBOutlet weak var channelsTableView: UITableView!
    ///Properties
    var dataSource = FavoriteChannelsDataSource()

    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegateAndDataSource()
    }
    
    
    //MARK: - Table View Delegate -
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let channel = dataSource.favoriteChannels[indexPath.row]
        dataSource.channelFetcher.imageHandler.operations[channel.id]?.cancel()
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = channelsTableView.indexPathForSelectedRow else {
            NSLog("No row selected or no index path for row.")
            return
        }
        if segue.identifier == .favoritesToDetailSegue {
            if let detailVC = segue.destination as? ChannelDetailViewController {
                detailVC.channel = dataSource.favoriteChannels[indexPath.row]
            }
        }
    }
    
    
    //MARK: - Private Methods -
    private func setupDelegateAndDataSource() {
        dataSource.dataChanged = { [weak self] in
            self?.channelsTableView.reloadData()
        }
        dataSource.channelFetcher.getChannels()
        channelsTableView.dataSource = dataSource
        channelsTableView.delegate = self
        dataSource.dataChanged?()
    }
}
