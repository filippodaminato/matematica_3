//
//  Cella.swift
//  matematica_3
//
//  Created by Leonardo Lazzarin on 13/10/2018.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

class Cella: UITableViewCell {

    @IBOutlet weak var numeratore: UILabel!
    @IBOutlet weak var denominatore: UILabel!
    @IBOutlet weak var risulatato: UILabel!
    @IBOutlet weak var resto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
