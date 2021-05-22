//
//  FetchPhotoOperation.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    //MARK: - Properties -
    let channel: Channel
    var imageData: Data?
    var photoTask: URLSessionDataTask?
    
    init(_ opChannel: Channel) {
        channel = opChannel
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        let photoTaskURL = channel.imageURL
        let fetchPhotos = URLSession.shared.dataTask(with: photoTaskURL) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error getting photo from URL: \(self.channel.imageURL) \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from URL: \(self.channel.imageURL)")
                return
            }
            self.imageData = data
        }
        fetchPhotos.resume()
        photoTask = fetchPhotos
    }
    
    override func cancel() {
        photoTask?.cancel()
        super.cancel()
        print("Photo fetch for \(channel) was canceled.")
    }
}
