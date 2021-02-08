//
//  SWShopViewModel.h
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWShopViewModel : NSObject

@property (nonatomic, weak  ) SWSuperViewContoller *cartVC;
//显示的购物车列表
@property (nonatomic, strong) NSMutableArray       *cartData;
/**
 *  存放店铺选中
 */
@property (nonatomic, strong) NSMutableArray       *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;

/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                  isSelectAll;
/**
 *  购物车商品数量
 */
@property (nonatomic, assign) NSInteger             cartGoodsCount;

//row select
- (void)rowSelect:(BOOL)isSelect
        IndexPath:(NSIndexPath *)indexPath;

//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity
                indexPath:(NSIndexPath *)indexPath;

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path;


//获取模拟数据
- (void)getData;


//计算总价
- (float)getAllPrices;


//全选/取消去选计算价格

- (void)selectAll:(BOOL)isSelect;

// 选中删除
- (void)deleteGoodsBySelect;
@end

NS_ASSUME_NONNULL_END
