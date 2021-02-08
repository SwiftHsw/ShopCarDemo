//
//  SWShopViewModel.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import "SWShopViewModel.h"

@interface SWShopViewModel (){
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
    NSArray *_goodsDesArray;
       
}
//随机获取店铺下商品数
@property (nonatomic, assign) NSInteger random;
@end


@implementation SWShopViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        //6
        _shopGoodsCount  = @[@(1),@(8),@(5),@(2),@(4),@(4)];
         _goodsPicArray  = @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.szthks.com%2Flocalimg%2F687474703a2f2f6777322e616c6963646e2e636f6d2f62616f2f75706c6f616465642f69322f5431436d757146586c6658585858585858585f2121302d6974656d5f7069632e6a7067.jpg&refer=http%3A%2F%2Fwww.szthks.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615083148&t=79f73bec7f9036b7f944f470c4594e00",
                            @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.szthks.com%2Flocalimg%2F687474703a2f2f6777312e616c6963646e2e636f6d2f62616f2f75706c6f616465642f69372f54314e34586b466f4a6758585858585858585f2121302d6974656d5f7069632e6a7067.jpg&refer=http%3A%2F%2Fwww.szthks.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615083148&t=4dea29ee9f48191d6c0fc71d4ac68c3a",
                            @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.szthks.com%2Flocalimg%2F687474703a2f2f6777312e616c6963646e2e636f6d2f62616f2f75706c6f616465642f69362f54313833564d5858586c585863554e6a76615f3132313630312e6a7067.jpg&refer=http%3A%2F%2Fwww.szthks.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615083148&t=646b59cf8c9e931e390857c8cfa018e4",
                            @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.szthks.com%2Flocalimg%2F687474703a2f2f6777312e616c6963646e2e636f6d2f62616f2f75706c6f616465642f69382f543156546d435879706258585858585858585f2121302d6974656d5f7069632e6a7067.jpg&refer=http%3A%2F%2Fwww.szthks.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615083148&t=ea2da5b13aea715df3eae0ae604cbba2",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg"];
        _goodsPriceArray = @[@(30.45),@(120.09),@(7.8),@(11.11),@(56.1),@(12)];
        _goodsQuantityArray = @[@(12),@(21),@(1),@(10),@(3),@(5)];
        _goodsDesArray = @[@"太空灰【古龙香】除甲醛✨",@"黑色-绿色背线；S码",@"深黑色",@"P40 128G华为",@"苹果iPhone12 Pro 5G全网通",@"黑色-适用思域"];
    }
    return self;
}
//左滑删除商品 并重新计算价格
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path{
    
    //删除
    NSMutableArray *shopArray = self.cartData[path.section];
    [shopArray removeObjectAtIndex:path.row];
    if (shopArray.count == 0) {
        //如果只有一个商品都被你删了，那就整个店铺的都给他删了
        [self.cartData removeObjectAtIndex:path.section];
        //同步删除shopSelectArray
        [self.shopSelectArray removeObjectAtIndex:path.section];
        
        [self.cartVC.tableView reloadData];
        
        [GKMessageTool showText:@"整个商家的购物车都被你删啦～"];
    }else{
        
        //判断是否都达到足够的数量
        NSInteger isSelectShopCount = 0;
        NSInteger shopCount = shopArray.count;
        for (ShopModel *model in shopArray) {
            if (model.isSelect) {
                isSelectShopCount ++;
            }
        }
        [self.shopSelectArray replaceObjectAtIndex:path.section withObject:@(isSelectShopCount == shopCount)];
        [self.cartVC.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationNone];
         [GKMessageTool showText:@"删除这件商品成功"];
    }
    
    self.cartGoodsCount -= 1;
    self.allPrices = [self getAllPrices];
    
    
}
//改变数据源的数量并且重新计算
- (void)rowChangeQuantity:(NSInteger)quantity
                indexPath:(NSIndexPath *)indexPath{
    
    ShopModel *model = self.cartData[indexPath.section][indexPath.row];
    model.p_quantity = quantity;
    
    self.allPrices = [self getAllPrices];
    
       [self.cartVC.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
    
     NSInteger section          = indexPath.section;
     NSInteger row              = indexPath.row;
     NSMutableArray *goodsArray = self.cartData[section]; //该店的购物车组数据
    NSInteger shopCount        = goodsArray.count;
    ShopModel *model          = goodsArray[row];
    model.isSelect = isSelect;
//    [model setValue:@(isSelect) forKey:@"isSelect"];
    //判断是否都到达了足够的数量
   __block NSInteger isSelectShopCount = 0;
    [goodsArray enumerateObjectsUsingBlock:^(ShopModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            isSelectShopCount ++;
        }
    }];
    //是否选中的所有商品，如果是 就替换head的选中状态
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount == shopCount)];
    self.allPrices =  [self getAllPrices];
    
       [self.cartVC.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
}
#pragma mark - 计算总价


- (void)selectAll:(BOOL)isSelect{
    
    __block float allPrices = 0;
    
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
           return @(isSelect);
       }] array] mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
           return  [[[[value rac_sequence] map:^id(ShopModel *model) {
                   model.isSelect = isSelect;
               if (model.isSelect) {
                   allPrices += model.p_quantity*model.p_price;
               }
               return model;
           }] array] mutableCopy];
       }] array] mutableCopy];
    
    self.allPrices = allPrices;
    [self.cartVC.tableView reloadData];
}
- (float)getAllPrices{
    
  __block  CGFloat allPrice = 0;
    NSInteger shopCount = self.cartData.count; //总数
    NSInteger shopSelectCount = self.shopSelectArray.count; //选中店铺的数量
    if (shopSelectCount == shopCount && shopCount!= 0) {
        self.isSelectAll = YES;
    }
    
    //代替数组
    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id _Nullable(NSMutableArray *value) {
        return [[[value rac_sequence] filter:^BOOL(ShopModel *model) {
            if (!model.isSelect) {
                //没有全选
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }]map:^id _Nullable(ShopModel *model) {
            return @(model.p_quantity*model.p_price);
        }];
    }] array] ;
    
    for (NSArray *priceA in pricesArray) {
        for (NSNumber *price in priceA) {
            allPrice += price.floatValue;
        }
    }
     
    
    return allPrice;
}

#pragma mark - 删除勾选
- (void)deleteGoodsBySelect{
    
    
    __block NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    
    //循环查找勾选的那个
    [self.cartData enumerateObjectsUsingBlock:^(NSMutableArray *shopArray, NSUInteger idx, BOOL * _Nonnull stop) {
           
        index1 ++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (ShopModel *model in shopArray) {
            index2 ++;
            if (model.isSelect) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (shopCount == selectCount) {
            //是否选中了该店铺所有的商品购物车
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount = selectCount;
        }
        [shopArray removeObjectsAtIndexes:selectIndexSet];
         
        
    }];
    
    //删除 选中的 shopSelectSet
    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
    
    //删除 shopSelectArray
    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
    [self.cartVC.tableView reloadData];
    
    //底部 恢复 默认
    self.allPrices = 0;
    
    //重新计算价格
    self.allPrices = [self getAllPrices];
    
    
}

#pragma mark - make data

- (void)getData{
    //数据个数
    NSInteger allCount = 20;
    NSInteger allGoodsCount = 0;
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
    NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
    //创造店铺数据
    for (int i = 0; i<allCount; i++) {
        //创造店铺下商品数据
        NSInteger goodsCount = [_shopGoodsCount[self.random] intValue];
        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
        for (int x = 0; x<goodsCount; x++) {
            ShopModel *cartModel = [[ShopModel alloc] init];
            cartModel.p_id         = @"122115465400";
            cartModel.p_price      = [_goodsPriceArray[self.random] floatValue];
            cartModel.p_name       = [NSString stringWithFormat:@"%@商品名称",@(x)];
            cartModel.p_stock      = 22;
            cartModel.p_imageUrl   = _goodsPicArray[self.random];
            cartModel.p_quantity   = [_goodsQuantityArray[self.random] integerValue];
            cartModel.p_desString =  _goodsDesArray[self.random];
            [goodsArray addObject:cartModel];
            allGoodsCount++;
        }
        [storeArray addObject:goodsArray];
        [shopSelectAarry addObject:@(NO)];
    }
    self.cartData = storeArray;
    self.shopSelectArray = shopSelectAarry;
    self.cartGoodsCount = allGoodsCount;
}
- (NSInteger)random{
    
    NSInteger from = 0;
    NSInteger to   = 5;
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
    
}
@end
