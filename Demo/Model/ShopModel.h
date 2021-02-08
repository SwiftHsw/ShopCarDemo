//
//  ShopModel.h
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject

@property (nonatomic, strong) NSString  *p_id;

@property (nonatomic, assign) float     p_price;

@property (nonatomic, assign) float     p_desMaxWidth;

@property (nonatomic, strong) NSString  *p_name;
@property (nonatomic, strong) NSString  *p_desString;
@property (nonatomic, strong) NSString  *p_imageUrl;

@property (nonatomic, assign) NSInteger p_stock;

@property (nonatomic, assign) NSInteger p_quantity;

//商品是否被选中
@property (nonatomic, assign) BOOL      isSelect;

@end

NS_ASSUME_NONNULL_END
