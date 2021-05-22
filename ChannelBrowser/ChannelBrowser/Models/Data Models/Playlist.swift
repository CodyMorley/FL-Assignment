//
//  Playlist.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

struct Playlist: Decodable {
    //MARK: - Types & Keys -
    enum PlaylistKeys: String, CodingKey {
        case url
        case format
        case quality
    }
    
    
    //MARK: - Properties -
    let url: URL
    let format: AudioFormat
    let quality: AudioQuality
    
    
    //MARK: - Initialization -
    init(from decoder: Decoder) throws {
        let playlistContainer = try decoder.container(keyedBy: PlaylistKeys.self)
        
        let urlString = try playlistContainer.decode(String.self, forKey: .url)
        let formatString = try playlistContainer.decode(String.self, forKey: .format)
        let qualityString = try playlistContainer.decode(String.self, forKey: .quality)
        
        let playlistURL = URL(string: urlString)!
        let playlistFormat = AudioFormat(rawValue: formatString)!
        let playlistQuality = AudioQuality(rawValue: qualityString)!
        
        url = playlistURL
        format = playlistFormat
        quality = playlistQuality
    }
    
    init(audioURL: String, audioFormat: String, audioQuality: String) {
        let playlistURL = URL(string: audioURL)!
        let playlistFormat = AudioFormat(rawValue: audioFormat)!
        let playlistQuality = AudioQuality(rawValue: audioQuality)!
        
        url = playlistURL
        format = playlistFormat
        quality = playlistQuality
    }
}
