//
//  WRefreshControlView.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

/// 刷新view,添加到你需要添加的地方
class WRefreshControlView: UIView {
  let kDistanceOfLabelAndImageView:CGFloat = 10
  /// 刷新状态
  var refreshState:WRefreshControlState = {
    return WRefreshControlState.Normal
    }()
  
  var targetContentSet:CGPoint={
    return CGPointZero
    }()
  
  lazy private var stateLabel: UILabel = {
    let stateLabel =  UILabel()
    stateLabel.font = UIFont.systemFontOfSize(12)
    stateLabel.textAlignment = NSTextAlignment.Left
    /// label的右边缘在self的中心
    stateLabel.frame = CGRectMake(self.frame.width/2, self.frame.height - self.kDistanceOfLabelAndImageView - 30, 100, 30)
    self.addSubview(stateLabel)
    return stateLabel
    }()
  
  lazy private var refreshImageView: UIImageView = {
    let refreshImageView = UIImageView()
    refreshImageView.center = CGPointMake(self.frame.width/2-16, self.stateLabel.center.y)
    refreshImageView.bounds = CGRectMake(0, 0, 32, 32)
    let imagePath = kBundlePath+"/tableview_pull_refresh"
    refreshImageView.image = UIImage(contentsOfFile: imagePath)
    self.addSubview(refreshImageView)
    return refreshImageView
    }()
  
  private var timer:NSTimer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
    onChangeRefreshState(refreshState)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reloadData(state:WRefreshControlState){
    self.onChangeRefreshState(state)
    self.refreshState = state
    self.setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
}

private typealias PrivateFunction = WRefreshControlView
extension PrivateFunction{
  private func onChangeRefreshState(state:WRefreshControlState){
    /**
    *  移除无限循环动画
    */
    if(refreshImageView.layer.animationForKey("rotationAnimation") != nil){
      refreshImageView.layer.removeAnimationForKey("rotationAnimation")
    }
    
    switch state.rawValue{
    case WRefreshControlState.Normal.rawValue:
      stateLabel.text = "下拉刷新"
      let imagePath = kBundlePath+"/tableview_pull_refresh"
      refreshImageView.image = UIImage(contentsOfFile: imagePath)
    case WRefreshControlState.Pulling.rawValue:
      animationWithLabelAndImageView("下拉刷新", pi: -CGFloat(0))
    case WRefreshControlState.CanRefresh.rawValue:
      animationWithLabelAndImageView("释放更新", pi: CGFloat(M_PI))
    case WRefreshControlState.Refreshing.rawValue:
      self.stateLabel.text        = "加载中..."
      let imagePath               = kBundlePath+"/tableview_loading"
      self.refreshImageView.image = UIImage(contentsOfFile: imagePath)
      animationWithCircle()
    default:
      break
    }
  }
  
  private func animationWithLabelAndImageView(text:String ,pi:CGFloat){
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.stateLabel.text = text
      let imagePath = kBundlePath+"/tableview_pull_refresh"
      self.refreshImageView.image = UIImage(contentsOfFile: imagePath)
      self.refreshImageView.transform = CGAffineTransformMakeRotation(pi)
      }, completion: { (Bool) -> Void in
        
    })
  }
  
  private func animationWithCircle(){
    
    let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.fromValue            = 0 as NSValue
    rotationAnimation.toValue              = M_PI * 2.0 as NSValue
    rotationAnimation.duration             = 1.0;
    rotationAnimation.cumulative           = true;
    rotationAnimation.repeatCount          = 1000;
    self.refreshImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
  }
}
