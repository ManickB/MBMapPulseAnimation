//
//  DatingPersonCell.swift
//  MeetMe
//
//  Created by ViVID on 4/6/17.
//  Copyright © 2017 ViVID. All rights reserved.
//

import UIKit

class DatingPersonCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var Profileimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Profileimage.layer.cornerRadius = Profileimage.frame.size.height / 2
        Profileimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
