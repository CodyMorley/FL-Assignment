//
//  ImageHandler.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class ImageHandler {
    var imageCache = Cache<String, Data>()
    var largeImageCache = Cache<String, UIImage>()
    var operations = [String : Operation]()
    var imageFetchQueue = OperationQueue()
}
