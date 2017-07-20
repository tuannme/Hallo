//
//  MsgOutGoingCell.swift
//  Up+
//
//  Created by Dreamup on 3/9/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit

class MsgOutGoingCell: UITableViewCell {


    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubbleView.layer.cornerRadius = 10
        bubbleView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
