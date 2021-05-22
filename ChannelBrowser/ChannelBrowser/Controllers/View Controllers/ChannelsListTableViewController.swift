//
//  ChannelsListTableViewController.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class ChannelsListTableViewController: UIViewController, UITableViewDelegate {
    //MARK: - Properties -
    ///Interface Outlets
    @IBOutlet weak var channelSearchBar: UISearchBar!
    @IBOutlet weak var searchToolBar: UIToolbar!
    @IBOutlet weak var channelsTableView: UITableView!
    
    var dataSource = AllChannelsDataSource()
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegateAndDataSource()
        setUpSearch()
    }
    
   
    //MARK: - User Actions -
    @IBAction func removeFilter(_ sender: Any) {
        dataSource.changeFilter(filterType: .none)
        dataSource.dataChanged?()
        channelSearchBar.placeholder = getPlaceHolder()
        
    }
    
    @IBAction func filterByDJ(_ sender: Any) {
        dataSource.changeFilter(filterType: .dj)
        dataSource.dataChanged?()
        channelSearchBar.placeholder = getPlaceHolder()
        
    }
    
    @IBAction func filterByTitle(_ sender: Any) {
        dataSource.changeFilter(filterType: .title)
        dataSource.dataChanged?()
        channelSearchBar.placeholder = getPlaceHolder()
    }
    
    
    //MARK: - Table View Delegate -
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let channel = dataSource.channels[indexPath.row]
        dataSource.channelFetcher.imageHandler.operations[channel.id]?.cancel()
    }

    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = channelsTableView.indexPathForSelectedRow else {
            NSLog("No row selected or no index path for row.")
            return
        }
        if segue.identifier == .searchToDetailSegue {
            if let detailVC = segue.destination as? ChannelDetailViewController {
                detailVC.channel = dataSource.filteredChannels[indexPath.row]
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
    }
    
    private func getPlaceHolder() -> String {
        switch dataSource.filter {
        case .none:
            return "* Showing all channels *"
        case .dj:
            return "* Search By DJ name *"
        case .title:
            return "* Search by channel title *"
        }
    }
    
    private func setUpSearch() {
        channelSearchBar.placeholder = getPlaceHolder()
        channelSearchBar.delegate = self
    }
}


//MARK: - Extensions -
extension ChannelsListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataSource.changeFilterText(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource.changeFilterText(nil)
        searchBar.placeholder = getPlaceHolder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dataSource.changeFilterText(searchBar.text)
    }
}
