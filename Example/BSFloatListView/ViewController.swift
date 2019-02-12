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
  @IBAction func backAction(_ sender: Any) {
    self.dismiss(animated: true, completion: {})
  }
  @IBOutlet var imageView: UIImageView! {
    didSet {
      imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
      imageView.isUserInteractionEnabled = true
    }
  }
  
  @objc func imageViewTapped(_ sender: Any) -> Void {
    print("imageViewTapped touched!!")
    floatListView.setFocusingView(at: imageView)
    
    self.drawBorder(for: imageView)
  }
  
  @IBOutlet var focus0Label : UILabel! {
    didSet {
      focus0Label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.focus0LabelTapped(_:))))
      focus0Label.isUserInteractionEnabled = true
    }
  }
  
  @objc func focus0LabelTapped(_ sender: Any) -> Void {
    print("focus0Label touched!!")
    
    floatListView.setFocusingView(at: focus0Label)
    
    self.drawBorder(for: focus0Label)
  }
  
  @IBOutlet var focus1Button: UIButton!
  @IBAction func focus1Action(_ sender: Any) {
    print("focus1Action!")
    floatListView.setFocusingView(at: focus1Button)
    
    self.drawBorder(for: self.focus1Button)
  }
  
  private lazy var floatListView: BSFloatListView = { [unowned self] in
    return BSFloatListView.initialization(
      on:
        self.view,
      with:
        ["Java", "Swift", "Scala", "Kotlin", "C++", "Clojure", "Javascript", "Python", "Haskell"],
      touchDetectionMode:
        .short
    )
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.setUpFlatListView()
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:))))
    floatListView.setFocusingView(at: self.view)
    self.drawBorder(for: self.view)
  }
  
  @objc func touchTapped(_ sender: Any) -> Void {
    floatListView.setFocusingView(at: self.view)
    self.drawBorder(for: self.view)
  }
  
  public func setUpFlatListView() -> Void {
    self.view.addSubview(floatListView)

    floatListView.didSelectRowAtClosure = { [unowned self] indexPath in
      print("clicked indexPath.row : ", indexPath.row)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController {
  func drawBorder(for targetView: UIView) -> Void {
    self.view.layer.borderColor = UIColor.clear.cgColor
    self.view.layer.borderWidth = 0.0
    self.view.subviews.forEach {
      $0.layer.borderColor = UIColor.clear.cgColor
      $0.layer.borderWidth = 0.0
    }
    targetView.layer.borderColor = UIColor.red.cgColor
    targetView.layer.borderWidth = 5.0
  }
}
