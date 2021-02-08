//
//  ShopModel.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
-(void)setP_desString:(NSString *)p_desString{
    _p_desString = p_desString;
    CGFloat maxWith = [self widthForSingleLineString:p_desString font:kFontWithSize(12)];
    _p_desMaxWidth = maxWith+10;
     
}

- (CGFloat)widthForSingleLineString:(NSString *)text font:(UIFont *)font {
    
    CGRect rect = [text
                   boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20 - 150, MAXFLOAT)
                   options:0
                   attributes:@{NSFontAttributeName:font}
                   context:nil];
    return rect.size.width;
    
}


@end
