//
//  AudioFormat.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation


enum AudioFormat: String {
    case mp3 = "mp3"
    case aac = "aac"
    case aacp = "aacp"
    
    var strRepresentable: String { return "." + self.rawValue }
}
