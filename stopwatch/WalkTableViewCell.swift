//
//  WalkTableViewCell.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/6/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit

class WalkTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    //@IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Actions


}
