//
//  BSFloatListTableViewCell.swift
//  Sidekick
//
//  Created by Seoksoon Jang on 2018. 6. 19..
//  Copyright © 2018년 boraseoksoon. All rights reserved.
//

import UIKit

class BSFloatListTableViewCell: UITableViewCell {
    // MARK: - IBOutlet, IBActions -
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var btCheck: UIButton!
    @IBAction func actionBtCheck(_ sender: Any) {
        print("check 클릭시 실행됩니다.(서비스상 쓰이진 않을것 같음)")
    }
    
    // MARK: - UITableViewCell LifeCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
