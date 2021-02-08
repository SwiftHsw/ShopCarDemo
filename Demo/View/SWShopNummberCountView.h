//
//  SWShopNummberCountView.h
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SWNumberChangeBlock)(NSInteger count);

@interface SWShopNummberCountView : UIView
/**
 *  总数
 */
@property (nonatomic, assign) NSInteger           totalNum;
/**
 *  当前显示价格
 */
@property (nonatomic, assign) NSInteger           currentCountNumber;

/**
 *  数量改变回调
 */
@property (nonatomic, copy  ) SWNumberChangeBlock NumberChangeBlock;

@end

NS_ASSUME_NONNULL_END
