//
//  FeedFetcher.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation
class ChannelFetcher {
    //MARK: - Types -
    enum NetworkError: Error {
        case badResponse
        case badDecode
        case noData
        case otherError
    }
    
    typealias ErrorHandler = (Result<Bool, NetworkError>) -> Void

    
    //MARK: - Properties -
    static let shared = ChannelFetcher()
    private(set) var channels: [Channel] = []
    private(set) var imageHandler = ImageHandler()
    
    //MARK: - Public Methods -
    public func getChannels(completion: @escaping ErrorHandler = { _ in }) {
        let channelsURL: URL = URL(string: "https://raw.githubusercontent.com/jvanaria/jvanaria.github.io/master/channels.json")!
        var request = URLRequest(url: channelsURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Encountered an unknown error when fetching channels from remote host.\nError: \(error) \nDescription: \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                NSLog("Bad response from remote host. Check connections and authentication before reattampting.")
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                NSLog("Recieved no data from remote host.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedChannels = try decoder.decode(ChannelsList.self, from: data)
                self.channels = decodedChannels.channels
                completion(.success(true))
            } catch {
                NSLog("Error decoding raw JSON data into Channel. \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
}
