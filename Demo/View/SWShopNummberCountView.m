//
//  SWShopNummberCountView.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import "SWShopNummberCountView.h"


static CGFloat const Wd = 28;

#define TEXTVALUE  @"UITextFieldTextDidEndEditingNotification"

@interface SWShopNummberCountView()
//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;
//数字按钮
@property (nonatomic, strong) UITextField *numberTT;

@end

@implementation SWShopNummberCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setUI];
}

#pragma mark -  set UI

- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    WeakSelf(self)
    /* ***************************减 ***************************/
    [self addSubview:self.subButton];
    [[self.subButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
           StrongSelf(self)
           self.currentCountNumber--;
        !self.NumberChangeBlock ? :self.NumberChangeBlock(self.currentCountNumber);
      }];
     
     /************************** 内容 ****************************/
    [self addSubview:self.numberTT];
    
    
     /************************** 加 ****************************/
    [self addSubview:self.addButton];
       [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
              StrongSelf(self)
              self.currentCountNumber++;
           !self.NumberChangeBlock ? :self.NumberChangeBlock(self.currentCountNumber);
      }];
       
     /************************** 内容改变 ****************************/
    [[kNotificationCenter rac_addObserverForName:TEXTVALUE object:self.numberTT]subscribeNext:^(NSNotification * _Nullable x) {
        StrongSelf(self)
        NSString *text = [(UITextField *)x.object text];
        NSInteger changeNum = 0;
        
        //大于并且不等于零
        if (text.integerValue > self.totalNum && self.totalNum != 0) {
            self.currentCountNumber = self.totalNum;
            self.numberTT.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
            changeNum = self.totalNum;//计算总数
        }else if (text.integerValue < 1){
            //最小为1件商品
            self.numberTT.text = @"1";
            changeNum = 1;
        }else{
            //其他
            changeNum = self.currentCountNumber = text.integerValue;
        }
        //回调
         !self.NumberChangeBlock ? :self.NumberChangeBlock(self.currentCountNumber);
        
    }];
    
    
     /* 捆绑加减的enable */
    
   RAC(self.subButton,enabled)  = [RACObserve(self, currentCountNumber) map:^id _Nullable(NSNumber *subValue) {
        return  @(subValue.integerValue > 1);
    }];
    
   RAC(self.addButton,enabled)  = [RACObserve(self, currentCountNumber) map:^id _Nullable(NSNumber *subValue) {
        return  @(subValue.integerValue <self.totalNum);
    }];
    
    
    
     /* 内容颜色显示 */
    RAC(self.numberTT,textColor) = [RACObserve(self, totalNum) map:^id _Nullable(NSNumber *totalValue) {
        return totalValue.integerValue == 0 ? UIColor.redColor : UIColor.blackColor;
    }];
    RAC(self.numberTT,text) = [RACObserve(self, currentCountNumber) map:^id _Nullable(NSNumber *Value) {
        return [NSString stringWithFormat:@"%@",Value];
    }];
      
    
}

#pragma mark - lazy
- (UIButton *)subButton{
    if (!_subButton) {
        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
         _subButton.frame = CGRectMake(0, 0, Wd,Wd);
         [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"]
                                  forState:UIControlStateNormal];
         [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"]
                                  forState:UIControlStateDisabled];
        _subButton.tag = 0;
    }
    return _subButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
         _addButton.frame = CGRectMake(self.numberTT.maxX, 0, Wd,Wd);
         [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"]
                                  forState:UIControlStateNormal];
         [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"]
                                  forState:UIControlStateDisabled];
        _addButton.tag = 1;
    }
    return _addButton;
}

- (UITextField *)numberTT{
    if (!_numberTT) {
        _numberTT = [[UITextField alloc]init];
        _numberTT.frame = CGRectMake(self.subButton.maxX, 0, Wd*1.5, self.subButton.height);
        _numberTT.keyboardType=UIKeyboardTypeNumberPad;
       _numberTT.text=[NSString stringWithFormat:@"%@",@(0)];
        _numberTT.backgroundColor = [UIColor whiteColor];
        _numberTT.textColor = [UIColor blackColor];
        _numberTT.adjustsFontSizeToFitWidth = YES;
        _numberTT.textAlignment=NSTextAlignmentCenter;
        _numberTT.layer.borderColor = UIColorRGB(201, 201, 201).CGColor;
       _numberTT.layer.borderWidth = 1.3;
        _numberTT.font= kFontWithSize(17);
    }
    return _numberTT;
}
@end
