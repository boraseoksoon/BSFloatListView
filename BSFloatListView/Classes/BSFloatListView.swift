//
//  BSFloatListView.swift
//  Sidekick
//
//  Created by Seoksoon Jang on 2018. 6. 19..
//  Copyright © 2018년 Sidekick Company. All rights reserved.
//

import UIKit

public class BSFloatListView: UIView {
  // MARK: - IBOutlet, IBActions -
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.separatorStyle = .none
      tableView.tableFooterView = UIView()
      
      tableView.backgroundColor = UIColor.white
      
      tableView.register(
        UINib(
          nibName: BSFloatListTableViewCellIdentifier, bundle: Bundle(for: BSFloatListView.self)),
          forCellReuseIdentifier:BSFloatListTableViewCellIdentifier
      )
    }
  }
  
  // MARK: - Instance Variables -
  lazy var cellClickFlagList = { [unowned self] in return dataList.map { _ in return false } }()
  
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
  
  public var didSelectRowAtClosure: ((IndexPath) -> Void)?
  
  // MARK: - TableView Cell Reuse Identifiers -
  let BSFloatListTableViewCellIdentifier = "BSFloatListTableViewCell"
  
  // MARK: - Instance Variables -
  static let XIB_NAME_CONSTANT = "BSFloatListView"
}

// MARK: - Own Methods -
extension BSFloatListView {
  /**
   used to create floatList instance from nib file to return.
   - parameters: None
   - returns: BSFloatListView
   */
  public class func initialization(frame: CGRect, with dataList: [String]) -> BSFloatListView {
    if let floatList = Bundle(for: BSFloatListView.self).loadNibNamed(BSFloatListView.XIB_NAME_CONSTANT,
                                                              owner:self,
                                                              options:nil)?[0] as? BSFloatListView {
      
      floatList.frame = frame
      floatList.dataList = dataList
      
      floatList.addRightBorderWithColor(
        color: UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0),
        width: 1.5
      )

      floatList.addBottomBorderWithColor(
        color: UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0),
        width: 1.5
      )
      
      floatList.alpha = 0.0
      // 초기 상태 화면에 안보이도록 처리. 애니메이션을 위해 alpha을 0.0으로 처리.
      
      return floatList
    }
    
    return BSFloatListView()
  }
}

extension BSFloatListView {
  func addRightBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
    self.layer.addSublayer(border)
  }
  
  func addBottomBorderWithColor(color: UIColor, width: CGFloat, frameWidthOffset: CGFloat = 0.0) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0,
                          y: self.frame.size.height - width,
                          width: self.frame.size.width - frameWidthOffset,
                          height: width)
    self.layer.addSublayer(border)
  }
}

// MARK: - UITableView Delegate, Datasource Methods -
extension BSFloatListView: UITableViewDelegate, UITableViewDataSource {
  private func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
  
  private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard dataList.count - 1 >= indexPath.row else { return }
    
    didSelectRowAtClosure?(indexPath)
    
    /// 셀의 indexPath.row 기준으로 클릭여부를 플래그로 저장시켜 둔 후 테이블뷰를 다시 reload 요청하여 UI를 새로 그려 클릭된 셀은 UI로 갱신되도록 처리한다.
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
