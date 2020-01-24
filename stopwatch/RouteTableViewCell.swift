//
//  RouteTableViewCell.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/6/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var WalkTimeLabel: UILabel!
    @IBOutlet weak var RunTimeLabel: UILabel!
    @IBOutlet weak var SkateboardTimeLabel: UILabel!
    @IBOutlet weak var BikeTimeLabel: UILabel!
    @IBOutlet weak var CarTimeLabel: UILabel!
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
