//
//  ViewController.swift
//  BSDropper
//
//  Created by Seoksoon Jang on 09/02/2019.
//  Copyright © 2019 JSS. All rights reserved.
//

import UIKit
import BSDropper
import BSFloatListView

public var GLOBAL_DUMMY_DATA_LIST = ["Java", "Swift", "Scala", "Kotlin", "C++", "Clojure", "Javascript", "Python", "Haskell"]

class Sample0ViewController: UIViewController {
  // MARK: - IBOutlet, IBAction Methods -
  @IBOutlet var tvPost: UITableView! {
    didSet {
      tvPost.delegate = self
      tvPost.dataSource = self
      
      tvPost.separatorStyle = .none
      tvPost.tableFooterView = UIView()
      
      tvPost.backgroundColor = UIColor.white
    }
  }
  
  // MARK: - Instance Variables Methods -
  private var isDidLayoutFinish: Bool = false
  private var selectedPostTopicIndex: Int = 0 {
    didSet {
      self.dropper.tfSearch.placeholder = self.searchPlaceHolderContents
      self.dropper.topicSelectButton.setTitle(self.postTopTitleContents, for: .normal)
    }
  }
  private var searchPlaceHolderContents: String {
    return "\(postTopTitleContents) clicked!"
  }
  private var postTopTitleContents: String {
    get {
      guard GLOBAL_DUMMY_DATA_LIST.count - 1 >= selectedPostTopicIndex else { return "" }
      return GLOBAL_DUMMY_DATA_LIST[selectedPostTopicIndex]
    }
  }
  
  /**
   * initiating floatListView instance..
   */
  private lazy var floatListView: BSFloatListView = { [unowned self] in
    let floatListView = BSFloatListView.initialization(
      on:
        self.dropper.topicSelectButton,
      with:
        GLOBAL_DUMMY_DATA_LIST,
      touchDetectionMode:
        .short,
      isSticky:
        true
    )
    floatListView.didSelectRowAtClosure = { [unowned self] indexPath in
      self.selectedPostTopicIndex = indexPath.row
    }
    return floatListView
  }()
  
  /**
   * initiating dropper instance with setup here...
   */
  private lazy var dropper: BSDropper = { [unowned self] in
    let dropper = BSDropper.initialization()
    return dropper
  }()

  // MARK: - ViewController LifeCycle Delegate Methods -
  override func viewDidLoad() {
    super.viewDidLoad()

    /**
     * Ready to use BSFloatListView
     */
    floatListView.readyToUse()
    
    /**
     * apply BSDropper
     */
    self.setUpDropper()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    isDidLayoutFinish = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - Own methods -
extension Sample0ViewController {
  func setUpDropper() -> Void {
    /**
     * add the dropper on top to get ready
     */
    self.view.addSubview(dropper)
    
    /**
     * Icon setup methods
     */
    dropper.setSearchTextFieldLeftImage(#imageLiteral(resourceName: "iconSearch"))
    dropper.setDropArrowImage(#imageLiteral(resourceName: "boardListOpen"))
    dropper.setMyPageIconImage(#imageLiteral(resourceName: "combinedShape"))
    dropper.setAlarmIconImage(#imageLiteral(resourceName: "alarmNotice"))
    
    /// set offset Y margin of tableView to fit in dropper.
    /// if not needed, you don't have to use it though.
    dropper.setScrollViewOffSet(tvPost)
    
    /**
     * Search TextField Delegate. Use if needed.
     */
    dropper.tfSearch.delegate = self
    
    /**
     * Events Listeners
     */
    dropper.closureBtTopicSelect = { [weak self] topicTitle in
      guard let `self` = self else { return }
      
      self.dropper.show() { [weak self] in
        guard let `self` = self else { return }
        //
      }
      
      print("'\(topicTitle)' clicked.")
    }
    
    self.dropper.closureBtAlarm = { [weak self] in
      guard let `self` = self else { return }
      print("'Alarm clicked.")
    }
    
    self.dropper.closureBtMyPage = { [weak self] in
      guard let `self` = self else { return }
      print("'MyPage clicked.")
    }
    
    self.dropper.closureBtFilterPost = { [weak self] in
      guard let `self` = self else { return }
      print("'Filter clicked.")
    }
  }
  
  fileprivate func showTransition(targetView: UIView, completion: (() -> (Void))? = nil) -> Void {
    UIView.transition(with: targetView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
      targetView.alpha = 1.0
    }, completion: { _ in
      completion?()
    })
  }
  
  fileprivate func hideTransitionView(targetView: UIView, completion: (() -> (Void))? = nil) -> Void {
    UIView.transition(with: targetView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
      targetView.alpha = 0.0
    }, completion: { _ in
      completion?()
    })
  }
}

// MARK: - UITableView Delegate Methods -
extension Sample0ViewController: UITableViewDelegate, UITableViewDataSource {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /**
     * observe scrollView
     */
    dropper.observe(scrollView)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    /**
     * checking offSet
     */
    dropper.check(offsetY: scrollView.contentOffset.y)
    
    /**
     * when scroll starts, hide floatListView.
     */
    floatListView.hide()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let targetViewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier:"Sample1ViewController") as! Sample1ViewController
    self.present(targetViewController, animated: true, completion: {})
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
      }
      return cell
    }()
    
    cell.textLabel?.text = "Go To Next Sample"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
}

// MARK: - UITextFieldDelegate Methods -
extension Sample0ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      textField.resignFirstResponder()
    }
    
    /// when search done key is clicked
    if textField.returnKeyType == .search {
      // 
    }
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    ///
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    ///
  }
}
