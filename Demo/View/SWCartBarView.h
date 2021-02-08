//
//  SWCartBarView.h
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface SWCartBarView : UIView

//结算
@property (nonatomic, strong) UIButton *balanceButton;
//全选
@property (nonatomic, strong) UIButton *selectAllButton;
//价格
@property (nonatomic, retain) UILabel *allMoneyLabel;
//删除
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL     isNormalState;

@property (nonatomic, assign) float    money;

@end

NS_ASSUME_NONNULL_END
