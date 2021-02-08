//
//  SWCartBarView.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import "SWCartBarView.h"


static NSInteger const BalanceButtonTag = 120;

static NSInteger const DeleteButtonTag = 121;

static NSInteger const SelectButtonTag = 122;


@implementation SWCartBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI{

    //默认yes
    
    self.isNormalState = YES;
    self.backgroundColor = [UIColor clearColor];
    /* 背景 */
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame = self.bounds;
    [self addSubview:effectView];

    CGFloat wd = SCREEN_WIDTH*2/7;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor  = UIColorRGB(210, 210, 210);
    [self addSubview:lineView];
    
    CGRect buttonFrame = CGRectMake(SCREEN_WIDTH-wd, 0, wd, self.height);
    /* 结算 */
    
     _balanceButton = [UIButton buttonWithBgImage:[UIImage imageWithColor:[UIColor redColor]]
                                  hilightedBgImage:[UIImage imageWithColor:[UIColor lightGrayColor]]
                                             frame:buttonFrame
                                              text:@"结算"
                                              font:16
                                             color:UIColor.whiteColor];
      _balanceButton.enabled = NO;
      _balanceButton.tag = BalanceButtonTag;
      [self addSubview:_balanceButton];
    
      /* 删除 */
    _deleteButton = [UIButton buttonWithBgImage:[UIImage imageWithColor:[UIColor redColor]]
                                  hilightedBgImage:[UIImage imageWithColor:[UIColor lightGrayColor]]
                                             frame:buttonFrame
                                              text:@"删除"
                                              font:16
                                             color:UIColor.whiteColor];
     _deleteButton.enabled = NO;
     _deleteButton.hidden = YES;
     _deleteButton.tag = DeleteButtonTag;
     [self addSubview:_deleteButton];
     
    /* 全选 */
 
    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
     _selectAllButton.tag = SelectButtonTag;
     [_selectAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_selectAllButton setTitle:@"全选"
                forState:UIControlStateNormal];
       [_selectAllButton setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
       [_selectAllButton setImage:[UIImage imageNamed:@"xn_circle_normal"]
                forState:UIControlStateNormal];
       [_selectAllButton setImage:[UIImage imageNamed:@"xn_circle_select"]
                forState:UIControlStateSelected];
       [_selectAllButton setFrame:CGRectMake(0, 0, 78, self.height)]; 
      [self addSubview:_selectAllButton];
    
    /* 价格 */
    self.allMoneyLabel = [UILabel labelWithText:[NSString stringWithFormat:@"总计￥:%@",@(00.00)]
                                   fontSize:15
                                  textColor:UIColor.blackColor
                              textAlignment:2
                                      frame:CGRectMake(wd, 0, SCREEN_WIDTH-wd*2-5, self.height)];
    [self addSubview:self.allMoneyLabel];
 
    
    [self bangdingRAC];
    
}


- (void)bangdingRAC
{
    WeakSelf(self)
    //监听属性变化
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        SWLog(@"==money==%@",x)
        StrongSelf(self)
        self.allMoneyLabel.text =  [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, money)] reduce:^id (NSNumber *money){
          StrongSelf(self)
        if (money.floatValue == 0) {
            self.selectAllButton.selected = NO;
        }
        return @(money.floatValue > 0);
    }];
    
    //是否可以点击 根据money 是否 >0来实现
    RAC(self.balanceButton,enabled) = comBineSignal;
    RAC(self.deleteButton,enabled) = comBineSignal;
       
    [RACObserve(self, isNormalState) subscribeNext:^(NSNumber *x) {
          StrongSelf(self)
        BOOL isNormal = x.boolValue;
        self.balanceButton.hidden = self.allMoneyLabel.hidden =  !isNormal;
        self.deleteButton.hidden = isNormal;
    }];
    
    
}
@end
