//
//  XBRuleView.swift
//  XBRuleView
//
//  Created by XB on 2016/11/2.
//  Copyright © 2016年 少先队. All rights reserved.
//

import UIKit

enum XBSwiftRuleType {
    case Horizontal
    case Vertical
}

class SwiftTestView: UIView {
    
    //var ruleView : XBSwiftRuleView
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubView() {
        
        let ruleVew = XBSwiftRuleView.init(frame: self.bounds,ruleType: XBSwiftRuleType.Vertical)
        ruleVew.shortSymbolColor = UIColor.red;
        ruleVew.shortSymbolHeight = 5
        ruleVew.middleSymbolColor = UIColor.blue
        ruleVew.middleSymbolHeight = 10
        ruleVew.longSymbolColor = UIColor.green
        ruleVew.longSymbolHeight = 15
        ruleVew.textColor = UIColor.black
        ruleVew.textFont = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(ruleVew)
        
    }
}

class XBSwiftRuleView: UIView ,UIScrollViewDelegate {
    
    var shortSymbolColor : UIColor?
    var middleSymbolColor : UIColor?
    var  longSymbolColor: UIColor?
    var shortSymbolHeight : CGFloat?
    var middleSymbolHeight : CGFloat?
    var longSymbolHeight : CGFloat?
    var  textColor: UIColor?
    var textFont : UIFont?
    
    var scrollview : UIScrollView?
    var delegate : UIScrollViewDelegate?
    
    var ruleType : XBSwiftRuleType
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(frame: CGRect , ruleType:XBSwiftRuleType ) {
        
        self.ruleType = ruleType;
        super.init(frame: frame)
        setUpSubviews();
    }
    
    func setUpSubviews(){
        scrollview = UIScrollView.init(frame: self.bounds)
        scrollview?.backgroundColor = UIColor.yellow
        self.addSubview(scrollview!)
        scrollview?.delegate = self
    }
    
    func setRange(from : Int , to : Int , minScale:Float , minScaleWidth:Float){
        
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if (self.delegate?.responds(to: aSelector))! {
            return self.delegate
        }
        return super.forwardingTarget(for: aSelector)
    }

}

class XBSwiftRuleContentView: UIView {
    
    
}
