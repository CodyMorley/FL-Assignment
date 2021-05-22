//
//  ChannelTableViewCell.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    //MARK: - Properties -
    @IBOutlet weak var djTextLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var channelImageView: UIImageView!
    
    
    //MARK: - Life Cycles -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    //MARK: - Cocoa Cell Methods -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
