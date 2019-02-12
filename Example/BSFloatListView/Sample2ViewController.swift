//
//  Sample2ViewController.swift
//  BSFloatListView_Example
//
//  Created by Seoksoon Jang on 12/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class Sample2ViewController: UIViewController {
  @IBOutlet var targetLabel: UILabel!
  @IBAction func backAction(_ sender: Any) {
    print("dismiss!")
    self.dismiss(animated: true, completion: {})
  }
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
