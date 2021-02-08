//
//  JSCartHeaderView.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "SWShopCartHeaderView.h"
 
@interface SWShopCartHeaderView()
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@end
@implementation SWShopCartHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    
     self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_normal"]
                             forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_select"]
                             forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"店铺名字_____"
                      forState:UIControlStateNormal];
    [self.storeNameButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.storeNameButton.titleLabel.font = kFontWithSize(13);
    [self addSubview:self.storeNameButton];

     
    self.contentView.layer.mask = self.maskLayer;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.selectStoreGoodsButton.frame = CGRectMake(10, 5, 36, 30);
    
    self.storeNameButton.frame = CGRectMake(self.selectStoreGoodsButton.maxX + 10, 5, SCREEN_WIDTH-40, 30);
  
    self.contentView.x = 10;
    self.contentView.width = SCREEN_WIDTH - 20;

}

+ (CGFloat)getCartHeaderHeight{
    
    return 40;
}
 

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(20, 20)];
           _maskLayer =  [[CAShapeLayer alloc] init];
           
           _maskLayer.frame = self.contentView.bounds;
           
           _maskLayer.path = maskPath.CGPath;
    }
    return _maskLayer;
}

@end
