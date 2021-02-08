//
//  JSCartFooterView.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "SWShopCartFooterView.h" 
@interface SWShopCartFooterView ()

@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UIView*whiteView;
@property (nonatomic,strong) CAShapeLayer *maskLayer;


@end

@implementation SWShopCartFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
   
    _whiteView = [UIView new];
    [self addSubview:_whiteView];
    _whiteView.backgroundColor = UIColor.whiteColor;
     _whiteView.layer.mask = self.maskLayer;
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"小记:￥15.80";
    _priceLabel.textColor = [UIColor redColor];
    [_whiteView addSubview:_priceLabel];
     
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _whiteView.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 50);
    _priceLabel.frame = CGRectMake(0, 10, _whiteView.width-20, 30);
    
    self.contentView.x = 10;
    self.contentView.width = SCREEN_WIDTH - 20;

 
}

- (void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray{
    
    _shopGoodsArray = shopGoodsArray;
    
    NSArray *pricesArray = [[[_shopGoodsArray rac_sequence] map:^id(ShopModel *model) {
        
        return @(model.p_quantity*model.p_price);
        
    }] array];
    
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"合计:￥%.2f",shopPrice];
}


+ (CGFloat)getCartFooterHeight{
    
    return 60;
}


- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-20, 50)
                                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(25, 25)];
           _maskLayer =  [[CAShapeLayer alloc] init];
           _maskLayer.frame = _whiteView.bounds;
           _maskLayer.path = maskPath.CGPath;
    }
    return _maskLayer;
}
@end
