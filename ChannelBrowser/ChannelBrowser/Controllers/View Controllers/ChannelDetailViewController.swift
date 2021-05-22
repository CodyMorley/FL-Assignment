//
//  ChannelDetailViewController.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class ChannelDetailViewController: UIViewController {
    //MARK: - Properties -
    ///Outlets
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var currentlyListeningTextLabel: UILabel!
    @IBOutlet weak var djContactTextLabel: UILabel!
    @IBOutlet weak var channelDetailsTextView: UITextView!
    @IBOutlet weak var channelImageView: UIImageView!
    
    
    ///Properties
    var channel: Channel?
    var favorites = FavoriteChannelsHandler()
    var isFavorite: Bool {
        if let channel = channel {
            return favorites.ids.contains(channel.id)
        }
        return false
    }
    var channelFetcher = ChannelFetcher.shared
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let channel = channel, isViewLoaded else { return }
        if let largeImage = channelFetcher.imageHandler.largeImageCache.value(for: channel.id) {
            channelImageView.image = largeImage
        } else {
            if channel.largeImageURL != nil {
                getLargeImage(url: channel.largeImageURL!)
            } else if channel.xlImageURL != nil {
                getLargeImage(url: channel.xlImageURL!)
            }
        }
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Actions -
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let channel = channel else { return }
        
        if favorites.ids.contains(channel.id) {
            favorites.removeFavorite(channel.id)
        } else {
            favorites.addFavorite(channel.id)
        }
        DispatchQueue.main.async {
            self.setupViews()
        }
    }
    
    
    //MARK: - Private Methods -
    private func getLargeImage(url: URL) {
        guard let channel = channel else {
            NSLog("No channel initialized to fetch large image. Operation aborted.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("There was an unexpected error fetching a large photo: \(error) \n \(error.localizedDescription)")
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                NSLog("Bad or no status code sent from remote host.")
                return
            }
            
            guard
                let imageData = data,
                let largeImage = UIImage(data: imageData)
            else {
                NSLog("No data was returned from photo fetch or image could not be initialized from data at source.")
                return
            }
            self.channelFetcher.imageHandler.largeImageCache.cache(for: channel.id, value: largeImage)
            DispatchQueue.main.async {
                self.channelImageView.image = largeImage
            }
        }.resume()
    }
    
    private func setupViews() {
        guard let channel = channel, isViewLoaded else { return }
        titleTextLabel.text = (channel.dj) + " - " + channel.title
        currentlyListeningTextLabel.text = "Current Listeners: " + channel.listeners
        djContactTextLabel.text = "Contact: " + channel.djMail
        channelDetailsTextView.text = channel.description
        favoriteButton.imageView?.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
}
