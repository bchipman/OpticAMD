//
//  PreviousTestsTableViewCell.swift
//  OpticAMD
//
//  Created by Brian on 11/13/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class PreviousTestsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftWavy: UILabel!
    @IBOutlet weak var leftBlurry: UILabel!
    @IBOutlet weak var leftBlind: UILabel!
    @IBOutlet weak var leftDark: UILabel!

    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightWavy: UILabel!
    @IBOutlet weak var rightBlurry: UILabel!
    @IBOutlet weak var rightBlind: UILabel!
    @IBOutlet weak var rightDark: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
