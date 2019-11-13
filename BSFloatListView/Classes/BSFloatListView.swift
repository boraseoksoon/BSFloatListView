//
//  BSFloatListView.swift
//  Sidekick
//
//  Created by Seoksoon Jang on 2018. 6. 19..
//  Copyright © 2018년 BSFloatListView. All rights reserved.
//

import UIKit

public enum TouchDetectionMode {
  case long
  case short
}

public class BSFloatListView: UIView {
  // MARK: - IBOutlet, IBActions -
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.separatorStyle = .none
      tableView.tableFooterView = UIView()
      tableView.isUserInteractionEnabled = true

      tableView.backgroundColor = UIColor.white

      tableView.register(
        UINib(
          nibName: BSFloatListTableViewCellIdentifier,
          bundle: Bundle(for: BSFloatListView.self)),
          forCellReuseIdentifier:BSFloatListTableViewCellIdentifier
      )
    }
  }
  
  // MARK: - Instance Variables -
  private var isSticky: Bool = true
  private var tokenKVO: NSKeyValueObservation?
  private var touchDetectionMode: TouchDetectionMode = .long
  private lazy var cellClickFlagList = { [unowned self] in return dataList.map { _ in return false } }()
  
  private var _dataList: [String]  = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  public var dataList: [String] {
    get {
      return _dataList
    }
    set {
      _dataList = newValue
    }
  }

  private weak var _observedTouchView: UIView! {
    didSet {
      _observedTouchView.isUserInteractionEnabled = true
    }
  }
  private weak var observedTouchView: UIView! {
    get {
      return _observedTouchView
    }
    set {
      _observedTouchView = newValue
    }
  }

  /// Closures
  public var didSelectRowAtClosure: ((IndexPath) -> Void)?
  
  // MARK: - TableView Cell Reuse Identifiers -
  private let BSFloatListTableViewCellIdentifier = "BSFloatListTableViewCell"
  
  // MARK: - Constant -
  static let XIB_NAME_CONSTANT = "BSFloatListView"
  static let HEIGHT: CGFloat = 200
  static let WIDTH: CGFloat = UIScreen.main.bounds.width * 0.55
  static let PADDING: CGFloat = 10.0
  static let TRANSITION_DURATION: Double = 0.25
  
  // MARK: - Instance Variables -
  private lazy var superViewTapRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.superViewTouchTapped(_:)))
    gesture.delegate = self
    gesture.cancelsTouchesInView = false
    return gesture
  }()
  
  private lazy var tapRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
    gesture.delegate = self
    gesture.cancelsTouchesInView = false

    return gesture
  }()
  
  private lazy var longPressRecognizer: UILongPressGestureRecognizer = { [unowned self] in
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTouchTapped(_:)))
    gesture.delegate = self
    gesture.cancelsTouchesInView = false
    
    return gesture
  }()
}

// MARK: - Own Methods -
extension BSFloatListView {
  
  /// Used to create floatList instance from nib file to return.
  ///
  /// - warning:  Mind whether isSticky is true or false will make difference of usage. Check detail in example source.
  /// - parameter observedTouchView: a targetView to react on.
  /// - parameter dataList: string array to display on the list.
  /// - parameter touchDetectionMode: choose recognizer type for either short tap(.short) or long press(.long)
  /// - parameter isSticky: if true, rather than floating around, stick to and show floatListView on a given observedTouchView in the first parameter.
  /// - returns: BSFloatListView instance
  public class func initialization(on observedTouchView: UIView,
                                   with dataList: [String],
                                   touchDetectionMode: TouchDetectionMode,
                                   isSticky: Bool = true) -> BSFloatListView {
    if let floatList = Bundle(for: BSFloatListView.self).loadNibNamed(BSFloatListView.XIB_NAME_CONSTANT,
                                                              owner:self,
                                                              options:nil)?[0] as? BSFloatListView {
      floatList.isSticky = isSticky
      floatList.setFocusingView(at: observedTouchView, touchDetectionMode: touchDetectionMode)
      
      if floatList.isSticky {

        floatList.frame = CGRect(
          x: observedTouchView.frame.origin.x,
          y: observedTouchView.frame.origin.y + observedTouchView.frame.size.height + BSFloatListView.PADDING,
          width: BSFloatListView.WIDTH,
          height: BSFloatListView.HEIGHT
        )
        
      } else {

        floatList.frame = CGRect(
          x: 0,
          y: 0,
          width: BSFloatListView.WIDTH,
          height: BSFloatListView.HEIGHT
        )
      }
 
      floatList.dataList = dataList

      floatList.addBorder()
      
      /// initially set alpha 0.0 to be hidden.
      floatList.alpha = 0.0
      
      /// Using KVO, observe frame and if exeeding screen size, re-calculate it.
      floatList.tokenKVO = floatList.observe(\.frame) { object, change in
        
        if (object.frame.origin.x + object.frame.size.width) > UIScreen.main.bounds.width {
          floatList.frame = CGRect(
            origin: CGPoint(x: floatList.frame.origin.x - floatList.frame.size.width, y: floatList.frame.origin.y),
            size: floatList.frame.size
          )
        } else if (object.frame.origin.y + object.frame.size.height) > UIScreen.main.bounds.height {
          floatList.frame = CGRect(
            origin: CGPoint(x: floatList.frame.origin.x, y: floatList.frame.origin.y - floatList.frame.size.height),
            size: floatList.frame.size
          )
        }
      }

      return floatList
    }
    
    return BSFloatListView()
  }

  public func setFocusingView(at targetView: UIView, touchDetectionMode: TouchDetectionMode = .long) -> Void {
    self.observedTouchView = targetView
    self.processGestureRecognizer(touchDetectionMode: touchDetectionMode)
  }
  
  private func processGestureRecognizer(touchDetectionMode: TouchDetectionMode) -> Void {
    self.touchDetectionMode = touchDetectionMode
    switch self.touchDetectionMode {
    case .long:
      self.observedTouchView.addGestureRecognizer(self.longPressRecognizer)
      self.observedTouchView.addGestureRecognizer(self.tapRecognizer)
      
      if let _ = self.observedTouchView.superview {
        // if superView is exist
        self.observedTouchView.superview?.subviews.forEach {
          $0.addGestureRecognizer(self.superViewTapRecognizer)
        }
      } else {
        // if superView is not exist, in other words, the view is the superView.
      }
    case .short:
      self.observedTouchView.addGestureRecognizer(self.tapRecognizer)
      
      if let _ = self.observedTouchView.superview {
        // if superView is exist
        self.observedTouchView.superview?.subviews.forEach {
          $0.addGestureRecognizer(self.superViewTapRecognizer)
        }
      } else {
        // if superView is not exist, in other words, the view is the superView.
      }
    }
    
  }
}

// MARK: - Target, Action Methods -
extension BSFloatListView {
  @objc private func superViewTouchTapped(_ sender: UITapGestureRecognizer) {
    if self.observedTouchView.superview != nil {
      self.hideTransitionView(targetView: self)
    }
  }
  
  @objc private func touchTapped(_ sender: UITapGestureRecognizer) {
    if touchDetectionMode == .long {
      self.hideTransitionView(targetView: self)
    } else {
      let loc = sender.location(in: sender.view)
      
      if isSticky {
        self.frame = CGRect(
          origin: CGPoint(
            x: self.observedTouchView.frame.origin.x,
            y: observedTouchView.frame.origin.y + observedTouchView.frame.size.height + BSFloatListView.PADDING
          ),
          size: self.frame.size
        )
      } else {
        if self.observedTouchView is UILabel || self.observedTouchView is UIButton {
          self.frame = CGRect(origin: CGPoint(x: loc.x, y: self.observedTouchView.frame.origin.y),
                              size: self.frame.size)
        } else {
          self.frame = CGRect(origin: CGPoint(x: loc.x, y: loc.y),
                              size: self.frame.size)
        }
      }
      
      self.alpha == 0.0 ? self.showTransition(targetView: self) : self.hideTransitionView(targetView: self)
    }
  }
  
  @objc private func longTouchTapped(_ sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .began:
      let loc = sender.location(in: sender.view)
      
      if isSticky {
        self.frame = CGRect(
          origin: CGPoint(
            x: self.observedTouchView.frame.origin.x,
            y: observedTouchView.frame.origin.y + observedTouchView.frame.size.height + BSFloatListView.PADDING
          ),
          size: self.frame.size)
      } else {
        if self.observedTouchView is UILabel || self.observedTouchView is UIButton {
          self.frame = CGRect(origin: CGPoint(x: loc.x,
                                              y: self.observedTouchView.frame.origin.y),
                                size: self.frame.size)
        } else {
          self.frame = CGRect(origin: CGPoint(x: loc.x, y: loc.y),
                              size: self.frame.size)
        }
      }
      
      self.alpha == 0.0 ? self.showTransition(targetView: self) : self.hideTransitionView(targetView: self)
    case .ended:
      break
    default:
      break
    }
  }
}

// MARK: - Utility Methods -
extension BSFloatListView {
  /// Used to add an instance of BSFloatListView on the top of an observedTouchView's hierarchy chain to get ready to show before the use.
  /// - parameter None
  /// - returns: None
  public func readyToUse() -> Void {
    FindBaseView(from: self.observedTouchView.superview)?.addSubview(self)
  }
  
//  public func show() -> Void {
//    showTransition(targetView: self)
//  }
//
  
/**
   Used to forcefully hide an instance of BSFloatListView while shown for which especially it can be used to hide when in hierarchy, a scrollView begins to scroll.
   - Parameter None
   - Returns: None.
 */
  public func hide() -> Void {
    hideTransitionView(targetView: self)
  }
  
  private func showTransition(targetView: UIView, completion: (() -> (Void))? = nil) -> Void {
    self.removeFromSuperview()
    FindBaseView(from: self.observedTouchView.superview)?.addSubview(self)
    
    self.tableView.flashScrollIndicators()
    UIView.transition(with: targetView,
                      duration: BSFloatListView.TRANSITION_DURATION,
                      options: [.transitionCrossDissolve], animations: {
      targetView.alpha = 1.0
    }, completion: { _ in
      completion?()
    })
  }
  
  private func hideTransitionView(targetView: UIView, completion: (() -> (Void))? = nil) -> Void {
    UIView.transition(with: targetView,
                      duration: BSFloatListView.TRANSITION_DURATION,
                      options: [.transitionCrossDissolve], animations: {
      targetView.alpha = 0.0
    }, completion: { _ in
      completion?()
    })
  }
  
  private func addBorder(
    color: UIColor = UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0),
    width: CGFloat = 1.75) {

    self.addTopBorderWithColor(
      color: UIColor(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0),
      width: 1.0
    )
    
    self.addLeftBorderWithColor(
      color: UIColor(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0),
      width: 1.0
    )

    self.addRightBorderWithColor(
      color: color,
      width: width
    )
    
    self.addBottomBorderWithColor(
      color: color,
      width: width
    )
  }
  
  private func addRightBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
    self.layer.addSublayer(border)
  }
  
  private func addBottomBorderWithColor(color: UIColor, width: CGFloat, frameWidthOffset: CGFloat = 0.0) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0,
                          y: self.frame.size.height - width,
                          width: self.frame.size.width - frameWidthOffset,
                          height: width)
    self.layer.addSublayer(border)
  }
  
  private func addTopBorderWithColor(color: UIColor, width: CGFloat, frameWidthOffset: CGFloat = 0.0) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0,
                          y: 0,
                          width: self.frame.size.width - frameWidthOffset,
                          height: width)
    self.layer.addSublayer(border)
  }
  
  private func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    self.layer.addSublayer(border)
  }
  
}

// MARK: - UITableView Delegate, Datasource Methods -
extension BSFloatListView: UITableViewDelegate, UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
  
  /// never make accessor private.. please....it will cause disaster. :)
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard dataList.count - 1 >= indexPath.row else { return }
    
    didSelectRowAtClosure?(indexPath)
    self.hideTransitionView(targetView: self) {
      // do additional jobs if needed.
    }
    
    
    for (index, _) in cellClickFlagList.enumerated() {
      if index == indexPath.row {
        cellClickFlagList[index] = true
      } else {
        cellClickFlagList[index] = false
      }
    }
    
    tableView.reloadData()
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier:BSFloatListTableViewCellIdentifier) as? BSFloatListTableViewCell {
      guard dataList.count - 1 >= indexPath.row,
        cellClickFlagList.count - 1 >= indexPath.row,
        case let postTopicName = dataList[indexPath.row] else {
          return UITableViewCell()
      }
      
      cell.lbTitle?.text = postTopicName
      cell.selectionStyle = .none
      
      switch cellClickFlagList[indexPath.row] {
      case true:
        cell.btCheck?.isHidden = false
        cell.lbTitle?.textColor = UIColor(red: 27.0 / 255.0, green: 84.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
      case false:
        cell.btCheck?.isHidden = true
        cell.lbTitle?.textColor = .black
      }
      
      return cell
    }
    
    return UITableViewCell()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
}

// MARK: - UIGestureRecognizerDelegate - 
extension BSFloatListView: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if let touchedView = touch.view, touchedView.isDescendant(of: tableView) {
      print("consuming..\(touchedView)")
      return false
    }
    
    return true
  }
}

// MARK: - Functions -
func FindBaseView(from givenView: UIView?) -> UIView? {
  return givenView?.superview == nil ?  givenView : FindBaseView(from: givenView?.superview)
}

func Delay(_ delaySeconds: Double, completion: @escaping () -> Void) -> Void {
  DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
    completion()
  }
}
