//
//  SwiftTestView.swift
//  XBRuleView
//
//  Created by XBingo on 2018/1/7.
//  Copyright © 2018年 少先队. All rights reserved.
//

import UIKit

class SwiftTestView: UIView,UIScrollViewDelegate {
    
    var ruleVew : XBSwiftRuleView?
    var label : UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubView() {
        
        ruleVew = XBSwiftRuleView.init(frame: self.bounds,ruleType: XBSwiftRuleType.horizontal)
        ruleVew?.setRange(from: 20, to: 200, minScale: 1, minScaleWidth: 10)
        ruleVew?.delegate = self
        
        ruleVew?.currentValue = 100
        self.addSubview(ruleVew!)
        
        let view = UIView.init(frame: CGRect(x:0,y:0,width:1,height:self.bounds.size.height))
        view.backgroundColor = UIColor.black
        view.center = CGPoint(x:self.bounds.size.width/2.0,y:self.bounds.size.height/2.0)
        self.addSubview(view)
        
        
        label = UILabel.init(frame:CGRect(x:0,y:0,width:100,height:20))
        label?.center = CGPoint(x:self.bounds.size.width/2.0,y:self.bounds.size.height/2.0)
        label?.textColor = UIColor.red
        label?.textAlignment = NSTextAlignment.center
        self.addSubview(label!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(NSString(format:"%0.0f",(ruleVew?.currentValue)!))
        label?.text = NSString(format:"%0.0f",(ruleVew?.currentValue)!) as String
    }
}
