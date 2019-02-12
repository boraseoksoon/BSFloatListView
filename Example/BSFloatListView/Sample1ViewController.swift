//
//  ViewController.swift
//  BSFloatListView
//
//  Created by boraseoksoon@gmail.com on 02/11/2019.
//  Copyright (c) 2019 boraseoksoon@gmail.com. All rights reserved.
//

import UIKit
import BSFloatListView

class Sample1ViewController: UIViewController {
  // MARK: - IBOutlet, IBActions -
  @IBAction func backAction(_ sender: Any) {
    self.dismiss(animated: true, completion: {})
  }
  
  @IBOutlet var imageView: UIImageView! {
    didSet {
      imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
      imageView.isUserInteractionEnabled = true
    }
  }
  
  @IBOutlet var focus0Label : UILabel! {
    didSet {
      focus0Label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.focus0LabelTapped(_:))))
      focus0Label.isUserInteractionEnabled = true
    }
  }
  
  @IBOutlet var focus1Button: UIButton!
  @IBAction func focus1Action(_ sender: Any) {
    print("focus1Action!")
    floatListView.setFocusingView(at: focus1Button)
    self.drawBorder(for: self.focus1Button)
  }
  
  // MARK: - Instance Variables -
  /**
   * initiating BSFloatListView instance with setup here...
   * Mind isSticky is false here to dynamically follow along touch area.
   */
  private lazy var floatListView: BSFloatListView = { [unowned self] in
    let floatListView = BSFloatListView.initialization(
      on:
        self.view,
      with:
        GLOBAL_DUMMY_DATA_LIST,
      touchDetectionMode:
        .short,
      isSticky:
        false
    )
    
    /// a closure for which list to choose.
    floatListView.didSelectRowAtClosure = { [unowned self] indexPath in
      guard GLOBAL_DUMMY_DATA_LIST.count - 1 >= indexPath.row,
        case let targetData = GLOBAL_DUMMY_DATA_LIST[indexPath.row]
        else {
          return
      }
      
      print("clicked indexPath.row at : ", indexPath.row)

      let targetViewController = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier:"Sample2ViewController") as! Sample2ViewController
      _ = targetViewController.view
      targetViewController.targetLabel.text = targetData
      self.present(targetViewController, animated: true, completion: {})
    }

    return floatListView
  }()
  
  // MARK: - ViewController LifeCycle Methods -
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     * Ready to use BSFloatListView
     */
    floatListView.readyToUse()
    
    
    

    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:))))
    floatListView.setFocusingView(at: self.view)
    self.drawBorder(for: self.view)
    
    NotifyUser(message: "You can use BSFloatListView dynamically.\nCheck example codes.",
               baseVC:self,
               complete: {}
    )
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - Target, Action Methods -
extension Sample1ViewController {
  @objc func imageViewTapped(_ sender: Any) -> Void {
    print("imageViewTapped touched!!")
    floatListView.setFocusingView(at: imageView)
    
    self.drawBorder(for: imageView)
  }
  
  @objc func focus0LabelTapped(_ sender: Any) -> Void {
    print("focus0Label touched!!")
    
    floatListView.setFocusingView(at: focus0Label)
    
    self.drawBorder(for: focus0Label)
  }
  
  @objc func touchTapped(_ sender: Any) -> Void {
    floatListView.setFocusingView(at: self.view)
    self.drawBorder(for: self.view)
  }
}

// MARK: - Utility Methods -
extension Sample1ViewController {
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

/// Alert Utility Function
func NotifyUser(_ title: String = "Info",
                message: String,
                baseVC: UIViewController,
                complete: @escaping (() -> Void)) -> Void {
  DispatchQueue.main.async {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    let okayAction = UIAlertAction(title: "Okay",
                                   style: .cancel, handler: { _ in
                                    complete()
    })
    
    alert.addAction(okayAction)
    
    baseVC.present(alert, animated: true, completion: {
      //
    })
  }
}

