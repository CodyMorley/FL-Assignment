//
//  Channel.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

struct ChannelsList: Decodable {
    enum CodingKeys: CodingKey {
        case channels
    }
    var channels: [Channel]
    
    init(from decoder: Decoder) throws {
        let channelsListContainer = try decoder.container(keyedBy: CodingKeys.self)
        let allChannels = try channelsListContainer.decode([Channel].self, forKey: .channels)
        
        channels = allChannels
    }
}

struct Channel: Decodable {
    //MARK: - Types & Keys -
    enum ChannelKeys: String, CodingKey {
        case id
        case title
        case description
        case dj
        case djMail = "djmail"
        case genre
        case imageURL = "image"
        case largeImageURL = "largeimage"
        case xlImageURL = "xlimage"
        case twitter
        case updated
        case listeners
        case playlists
        case lastPlaying
    }
    
    
    
    //MARK: - Properties -
    let id: String
    let title: String
    let description: String
    let dj: String
    let djMail: String
    let genre: String
    let imageURL: URL
    let largeImageURL: URL?
    let xlImageURL: URL?
    let twitter: String
    let updated: Date
    let listeners: String
    let lastPlaying: String
    let playlists: [Playlist]
    
    
    //MARK: - Initialization -
    init(from decoder: Decoder) throws {
        //Spin up tools and containers.
        let channelContainer = try decoder.container(keyedBy: ChannelKeys.self)
        let dateFormatter = DateFormatter()
        
        // Decoding the simple strings
        let channelID = try channelContainer.decode(String.self, forKey: .id)
        let channelTitle = try channelContainer.decode(String.self, forKey: .title)
        let channelDescription = try channelContainer.decode(String.self, forKey: .description)
        let channelDJ = try channelContainer.decode(String.self, forKey: .dj)
        let channelDJMail = try channelContainer.decode(String.self, forKey: .djMail)
        let channelGenre = try channelContainer.decode(String.self, forKey: .genre)
        let channelTwitter = try channelContainer.decode(String.self, forKey: .twitter)
        let channelListeners = try channelContainer.decode(String.self, forKey: .listeners)
        let channelLastPlaying = try channelContainer.decode(String.self, forKey: .lastPlaying)
        // Decoding strings for more complex types
        let imageString = try channelContainer.decode(String.self, forKey: .imageURL)
        let largeImageString = try? channelContainer.decode(String?.self, forKey: .largeImageURL)
        let XLImageString = try? channelContainer.decode(String?.self, forKey: .xlImageURL)
        let updatedDateString = try channelContainer.decode(String.self, forKey: .updated)
        
        let channelImage = URL(string: imageString)!
        let channelLargeImage: URL? = URL(string: largeImageString ?? .noImage) ?? nil
        let channelXLImage: URL? = URL(string: XLImageString ?? .noImage) ?? nil
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let channelLastUpdate = dateFormatter.date(from: updatedDateString)
        // Getting playlists
        let channelPlaylists = try channelContainer.decode([Playlist].self, forKey: .playlists)
        
        id = channelID
        title = channelTitle
        description = channelDescription
        dj = channelDJ
        djMail = channelDJMail
        genre = channelGenre
        imageURL = channelImage
        largeImageURL = channelLargeImage
        xlImageURL = channelXLImage
        twitter = channelTwitter
        updated = channelLastUpdate ?? Date()
        listeners = channelListeners
        lastPlaying = channelLastPlaying
        playlists = channelPlaylists
    }
}
