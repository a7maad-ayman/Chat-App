//
//  MessageTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Ahmad Ayman Mansour on 09/04/2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var avtarImage: UIImageView!
    @IBOutlet weak var youAvatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = messageBackground.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib{
        return UINib(nibName: Constants.cellNibName, bundle: nil)
    }
    
}
