//
//  XBRuleView.m
//  XBRuleView
//
//  Created by XB on 2016/10/30.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "XBRuleView.h"

#define defaultSymbolColor [UIColor blackColor]
#define defaultShortSymbolHeight 10
#define defaultMiddleSymbolHeight 20
#define defaultLongSymbolHeight 30
#define defaultTextFont [UIFont systemFontOfSize:10]

@interface XBRuleView()<UIScrollViewDelegate>

{
    CGFloat _currentValue;
    
    UIFont *_textFont;
    
    UIColor *_textColor;
    UIColor *_shortSymbolColor;
    UIColor *_middleSymbolColor;
    UIColor *_longSymbolColor;
    
    CGFloat _shortSymbolHeight;
    CGFloat _middleSymbolHeight;
    CGFloat _longSymbolHeight;
    
    
}

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,assign) CGFloat minValue;
@property (nonatomic ,assign) CGFloat maxValue;
@property (nonatomic ,assign) CGFloat minScale;
@property (nonatomic ,assign) CGFloat minScaleWidth;

@property (nonatomic ,assign) XBRuleType ruleType;

@end

@implementation XBRuleView

-(instancetype)initWithFrame:(CGRect)frame ruleType:(XBRuleType)ruleType{
    
    if (self = [super initWithFrame:frame]) {
        
        self.ruleType = ruleType;
        
        [self setUpSubViews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame ruleType:XBRuleTypeHorizontal];
}

-(void)setUpSubViews{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
}

-(void)setRangeFrom:(NSInteger)minVale to:(NSInteger)maxValue minScale:(CGFloat)minScale minScaleWidth:(CGFloat)minScaleWidth{
    self.minValue = minVale;
    self.maxValue = maxValue;
    self.minScale = minScale;
    self.minScaleWidth = minScaleWidth;
    
    CGFloat contentViewWidth = 0;
    CGRect contentViewFrame = CGRectZero;
    
    if (self.ruleType == XBRuleTypeVertical) {
        contentViewWidth = (maxValue - minVale)/minScale * _minScaleWidth + self.bounds.size.height;
        contentViewFrame = CGRectMake(0, 0, self.frame.size.width, contentViewWidth);
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, contentViewWidth);
        
    }else{
        contentViewWidth = (maxValue - minVale)/minScale * _minScaleWidth + self.bounds.size.width;
        contentViewFrame = CGRectMake(0, 0, contentViewWidth, self.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(contentViewWidth, self.bounds.size.height);
    }
    
    XBRuleContentView *contentView = [[XBRuleContentView alloc]initWithFrame:contentViewFrame
                                                                    minScale:minScale
                                                               minScaleWidth:minScaleWidth
                                                                     minVale:minVale
                                                                    maxValue:maxValue
                                                                  startIndex:self.ruleType == XBRuleTypeVertical ? self.bounds.size.height/2.0 : self.bounds.size.width/2.0
                                                            shortSymbolColor:self.shortSymbolColor
                                                           middleSymbolColor:self.middleSymbolColor
                                                             longSymbolColor:self.longSymbolColor
                                                           shortSymbolHeight:self.shortSymbolHeight
                                                          middleSymbolHeight:self.middleSymbolHeight
                                                            longSymbolHeight:self.longSymbolHeight
                                                                   textColor:self.textColor
                                                                    textFont:self.textFont
                                                                    ruleType:self.ruleType];
    
    [self.scrollView addSubview:contentView];
    
}

#pragma mark --delegate

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector])
        
        return self.delegate;
    
    return [super forwardingTargetForSelector:aSelector];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    *targetContentOffset = [self scrollToOffset:(*targetContentOffset)];
    
    if ([self.delegate respondsToSelector:
         @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        
        [self.delegate scrollViewWillEndDragging:scrollView
                                    withVelocity:velocity
                             targetContentOffset:targetContentOffset];
}

- (CGPoint)scrollToOffset:(CGPoint)starting {
    
    CGPoint ending = starting;
    if (self.ruleType == XBRuleTypeVertical) {
        ending.y = roundf(starting.y / self.minScaleWidth) * self.minScaleWidth;
    }else{
        ending.x = roundf(starting.x / self.minScaleWidth) * self.minScaleWidth;
    }
    return ending;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:scrollView];
}

#pragma mark --set/get method

-(void)setCurrentValue:(CGFloat)newValue{
    
    if (newValue < _minValue ) {
        _currentValue = _minValue;
    }else if (newValue > _maxValue) {
        _currentValue = _maxValue;
    }else{
        _currentValue = newValue;
    }
    
    if (self.ruleType == XBRuleTypeVertical) {
        CGPoint offset = self.scrollView.contentOffset;
        offset.y = (_currentValue - _minValue)/self.minScale * _minScaleWidth;
        self.scrollView.contentOffset = offset;
    }else{
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = (_currentValue - _minValue)/self.minScale * _minScaleWidth;
        self.scrollView.contentOffset = offset;
    }
}

-(CGFloat)currentValue{
    
    if (self.ruleType == XBRuleTypeVertical) {
        return (self.scrollView.contentOffset.y / self.minScaleWidth) * self.minScale + self.minValue;
    }else{
        return (self.scrollView.contentOffset.x / self.minScaleWidth) * self.minScale + self.minValue;
    }
    
}

-(void)setShortSymbolColor:(UIColor *)shortSymbolColor{
    _shortSymbolColor = shortSymbolColor;
}

-(UIColor *)shortSymbolColor{
    return _shortSymbolColor ? _shortSymbolColor : defaultSymbolColor;
}

-(void)setShortSymbolHeight:(CGFloat)shortSymbolHeight{
    _shortSymbolHeight = shortSymbolHeight;
}

-(CGFloat)shortSymbolHeight{
    return _shortSymbolHeight > 0 ? _shortSymbolHeight : defaultShortSymbolHeight;
}

-(void)setMiddleSymbolColor:(UIColor *)middleSymbolColor{
    _middleSymbolColor = middleSymbolColor;
}

-(UIColor *)middleSymbolColor{
    return _middleSymbolColor ? _middleSymbolColor : defaultSymbolColor;
}

-(void)setMiddleSymbolHeight:(CGFloat)middleSymbolHeight{
    _middleSymbolHeight = middleSymbolHeight;
}

-(CGFloat)middleSymbolHeight{
    return _middleSymbolHeight > 0 ? _middleSymbolHeight : defaultMiddleSymbolHeight;
}

-(void)setLongSymbolColor:(UIColor *)longSymbolColor{
    _longSymbolColor = longSymbolColor;
}

-(UIColor *)longSymbolColor{
    return _longSymbolColor ? _longSymbolColor : defaultSymbolColor;
}

-(void)setLongSymbolHeight:(CGFloat)longSymbolHeight{
    _longSymbolHeight = longSymbolHeight;
}

-(CGFloat)longSymbolHeight{
    return _longSymbolHeight > 0 ? _longSymbolHeight : defaultLongSymbolHeight;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}
-(UIColor *)textColor{
    return _textColor ? _textColor : defaultSymbolColor;
}

-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
}

-(UIFont *)textFont{
    return _textFont ? _textFont : defaultTextFont;
}




@end

