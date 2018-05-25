//
//  CustomCell.swift
//  application_MAD
//
//  Created by Jibin George on 13/03/2018.
//  Copyright © 2018 Jibin Kaitholil George. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
