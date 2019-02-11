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
    print("actionBtCheck!!")
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
