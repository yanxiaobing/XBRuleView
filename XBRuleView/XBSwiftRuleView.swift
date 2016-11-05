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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubView() {
        
        let ruleVew = XBSwiftRuleView.init(frame: self.bounds,ruleType: XBSwiftRuleType.Horizontal)
        ruleVew.setRange(from: 20, to: 200, minScale: 1, minScaleWidth: 5)
        ruleVew.currentValue = 100
        
        self.addSubview(ruleVew)
    }
}

class XBSwiftRuleView: UIView ,UIScrollViewDelegate {
    
    var shortSymbolColor : UIColor = UIColor.red
    var middleSymbolColor : UIColor = UIColor.red
    var longSymbolColor: UIColor = UIColor.red
    var shortSymbolHeight : CGFloat = 5
    var middleSymbolHeight : CGFloat = 10
    var longSymbolHeight : CGFloat = 15
    var  textColor: UIColor = UIColor.red
    var textFont : UIFont = UIFont.systemFont(ofSize: 10)
    
    var ruleType : XBSwiftRuleType = XBSwiftRuleType.Horizontal
    var minValue : NSInteger = 20
    var maxValue : NSInteger = 200
    var minScale : CGFloat = 1
    var minScaleWidth : CGFloat = 5
    
    var scrollview : UIScrollView?
    var delegate : UIScrollViewDelegate?
    
    var value : CGFloat?
    
    var currentValue : CGFloat{
        set{
            if (newValue < CGFloat(minValue) ) {
                value = CGFloat(minValue)
            }else if (newValue > CGFloat(maxValue)) {
                value = CGFloat(maxValue)
            }else{
                value = newValue;
            }
            
            if (ruleType == XBSwiftRuleType.Vertical) {
                var offset = scrollview?.contentOffset
                offset?.y = (value! - CGFloat(minValue)) / CGFloat(minScale) * CGFloat(minScaleWidth)
                scrollview?.contentOffset = offset!
            }else{
                var offset = scrollview?.contentOffset;
                offset?.x = (value! - CGFloat(minValue)) / CGFloat(minScale) * CGFloat(minScaleWidth);
                scrollview?.contentOffset = offset!;
            }
        }
        
        get{
            if ruleType == XBSwiftRuleType.Vertical {
                return ((scrollview?.contentOffset.y)! / minScaleWidth) * CGFloat(minScale) + CGFloat(minValue)
            }else{
                return ((scrollview?.contentOffset.x)! / minScaleWidth) * CGFloat(minScale) + CGFloat(minValue)
            }
        }
    }
    
    
    init(frame: CGRect , ruleType:XBSwiftRuleType ) {
        self.ruleType = ruleType;
        super.init(frame: frame)
        setUpSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews(){
        self.backgroundColor = UIColor.clear
        scrollview = UIScrollView.init(frame: self.bounds)
        scrollview?.backgroundColor = UIColor.yellow
        self.addSubview(scrollview!)
        scrollview?.delegate = self
    }
    
    func setRange(from : NSInteger , to : NSInteger , minScale:CGFloat , minScaleWidth:CGFloat){
        
        self.minValue = from
        self.maxValue = to
        self.minScale = minScale
        self.minScaleWidth = minScaleWidth
        
        var  contentViewWidth : CGFloat
        
        var contentViewFrame : CGRect
        
        if ruleType == XBSwiftRuleType.Vertical {
            contentViewWidth = CGFloat(maxValue - minValue) / minScale * minScaleWidth + self.bounds.size.height
            contentViewFrame = CGRect(x:0, y:0, width:self.frame.size.width, height:contentViewWidth)
            scrollview?.contentSize = CGSize(width:self.bounds.size.width, height:contentViewWidth)
            
        }else{
            contentViewWidth = CGFloat(maxValue - minValue) / minScale * minScaleWidth + self.bounds.size.width
            contentViewFrame = CGRect(x:0, y:0, width:contentViewWidth, height:self.frame.size.height)
            scrollview?.contentSize = CGSize(width:contentViewWidth, height:self.bounds.size.height)
        }
        
        let contentView = XBSwiftRuleContentView.init(frame: contentViewFrame, minScale: minScale, minScaleWidth: minScaleWidth, minValue: CGFloat(minValue), maxValue: CGFloat(maxValue), startIndex: ruleType == XBSwiftRuleType.Vertical ? self.bounds.size.height/2.0 : self.bounds.size.width/2.0, shortSymbolColor: shortSymbolColor, middleSymbolColor: middleSymbolColor, longSymbolColor: longSymbolColor, shortSymbolHeight: shortSymbolHeight, middleSymbolHeight: middleSymbolHeight, longSymbolHeight: longSymbolHeight, textColor:textColor, textFont:textFont, ruleType:ruleType)
        
        scrollview?.addSubview(contentView)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if (delegate?.responds(to: aSelector))! {
            return delegate
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll!(scrollview!)
    }

}

class XBSwiftRuleContentView: UIView {
    var minScale:CGFloat
    var minScaleWidth:CGFloat
    var minValue:CGFloat
    var maxValue:CGFloat
    var startIndex:CGFloat
    var shortSymbolColor:UIColor
    var middleSymbolColor:UIColor
    var longSymbolColor:UIColor
    var shortSymbolHeight:CGFloat
    var middleSymbolHeight:CGFloat
    var longSymbolHeight:CGFloat
    var textColor:UIColor
    var textFont:UIFont
    var ruleType:XBSwiftRuleType
    
    init(frame: CGRect,
         minScale:CGFloat,
         minScaleWidth:CGFloat,
         minValue:CGFloat,
         maxValue:CGFloat,
         startIndex:CGFloat,
         shortSymbolColor:UIColor,
         middleSymbolColor:UIColor,
         longSymbolColor:UIColor,
         shortSymbolHeight:CGFloat,
         middleSymbolHeight:CGFloat,
         longSymbolHeight:CGFloat,
         textColor:UIColor,
         textFont:UIFont,
         ruleType:XBSwiftRuleType) {
        
        self.minScale = minScale
        self.minScaleWidth = minScaleWidth
        self.minValue = minValue
        self.maxValue = maxValue
        self.startIndex = startIndex
        self.shortSymbolColor = shortSymbolColor
        self.middleSymbolColor = middleSymbolColor
        self.longSymbolColor = longSymbolColor
        self.shortSymbolHeight = shortSymbolHeight
        self.middleSymbolHeight = middleSymbolHeight
        self.longSymbolHeight = longSymbolHeight
        self.textColor = textColor
        self.textFont = textFont
        self.ruleType = ruleType;
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if ruleType == XBSwiftRuleType.Horizontal {
            drawSubviewsWhenHorizontal(rect: rect)
        }else{
            drawSubviewsWhenVertical(rect: rect)
        }
    }
    
    func drawSubviewsWhenHorizontal(rect:CGRect){
        
        let longSymbolDotImage = imageWith(color: longSymbolColor, size: CGSize(width:1,height:1))
        let middleSymbolDotImage = imageWith(color: middleSymbolColor, size: CGSize(width:1,height:1))
        let shortSymbolDotImage = imageWith(color: shortSymbolColor, size: CGSize(width:1,height:1))
        
        for i in 0...(Int)((maxValue - minValue) / minScale){
            
            if i % 10 == 0 {
                let scaleFrame = CGRect(x:startIndex + CGFloat(i) * minScaleWidth, y:0, width:1, height:longSymbolHeight)
                longSymbolDotImage.draw(in: scaleFrame)
                let text = NSString(format:"%0.0f",minValue + CGFloat(i) * minScale)
                let textSize = countTextSize(font: textFont, text: text)
                let attributes = [NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor] as [String : Any]
                let rect = CGRect(x:scaleFrame.origin.x - textSize.width/2.0,y:rect.size.height - textSize.height, width:textSize.width, height:textSize.height)
                text.draw(in: rect, withAttributes: attributes)
            }else if i % 5 == 0{
                
                middleSymbolDotImage.draw(in: CGRect(x:startIndex + CGFloat(i) * minScaleWidth,y:0,width:1,height:middleSymbolHeight))
            }else{
                
                shortSymbolDotImage.draw(in: CGRect(x:startIndex + CGFloat(i) * minScaleWidth,y:0,width:1,height:shortSymbolHeight))
            }
            
        }
        
        
    }
    
    func drawSubviewsWhenVertical(rect:CGRect){

        let longSymbolDotImage = imageWith(color: longSymbolColor, size: CGSize(width:1,height:1))
        let middleSymbolDotImage = imageWith(color: middleSymbolColor, size: CGSize(width:1,height:1))
        let shortSymbolDotImage = imageWith(color: shortSymbolColor, size: CGSize(width:1,height:1))
        
        for i in 0...(Int)((maxValue - minValue) / minScale){
            
            if i % 10 == 0 {
                let scaleFrame = CGRect(x:0, y:startIndex + minScaleWidth * CGFloat(i), width:longSymbolHeight, height:1)
                longSymbolDotImage.draw(in: scaleFrame)
                let text = NSString(format:"%0.2f",minValue + CGFloat(i) * minScale)
                let textSize = countTextSize(font: textFont, text: text)
                let attributes = [NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor] as [String : Any]
                let rect = CGRect(x:rect.size.width - textSize.width,y:scaleFrame.origin.y - textSize.height/2.0, width:textSize.width, height:textSize.height)
                text.draw(in: rect, withAttributes: attributes)
            }else if i % 5 == 0{
                
                middleSymbolDotImage.draw(in: CGRect(x:0,y:startIndex + CGFloat(i) * minScaleWidth,width:middleSymbolHeight,height:1))
            }else{
                
                shortSymbolDotImage.draw(in: CGRect(x:0,y:startIndex + CGFloat(i) * minScaleWidth,width:shortSymbolHeight,height:1))
            }
            
        }
    }

    func imageWith(color:UIColor, size:CGSize) -> UIImage {
        let rect = CGRect(x:0,y:0,width:size.width,height:size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func countTextSize(font:UIFont,text:NSString) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        let attribute = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle]
        let size = text.size(attributes: attribute)
        return size
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
