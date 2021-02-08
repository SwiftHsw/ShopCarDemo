//
//  SWShopCell.h
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/5.
//  Copyright © 2021 lity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWShopNummberCountView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectShopGoodsButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesLable;
@property (weak, nonatomic) IBOutlet SWShopNummberCountView *nummberCountView;

@property (nonatomic, strong) ShopModel *model;

+ (CGFloat)getCartCellHeight;

@end

NS_ASSUME_NONNULL_END
