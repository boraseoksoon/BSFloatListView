//
//  ViewController.swift
//  BSFloatListView
//
//  Created by boraseoksoon@gmail.com on 02/11/2019.
//  Copyright (c) 2019 boraseoksoon@gmail.com. All rights reserved.
//

import UIKit
import BSFloatListView

class ViewController: UIViewController {
  private lazy var floatListView: BSFloatListView = { [unowned self] in
    return BSFloatListView.initialization(
      frame:
        CGRect(
          x: 100,
          y: 100,
          width: UIScreen.main.bounds.width * 0.834,
          height: 229
        ),
      with:
        ["Java", "Swift", "Scala", "Kotlin", "C++", "Clojure", "Javascript", "Python", "Haskell"]
    )
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.setUpFlatListView()
  }
  
  public func setUpFlatListView() -> Void {
    self.view.addSubview(floatListView)

    floatListView.didSelectRowAtClosure = { [unowned self] indexPath in
      //
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
