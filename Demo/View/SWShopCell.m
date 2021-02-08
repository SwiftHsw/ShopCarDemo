//
//  SWShopCell.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/5.
//  Copyright © 2021 lity. All rights reserved.
//

#import "SWShopCell.h"

@interface SWShopCell()
@property (weak, nonatomic) IBOutlet UILabel        *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *GoodsPricesLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *goodsImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthDes;

@end
@implementation SWShopCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.goodsDesLable.userInteractionEnabled = YES;
    
}
 
- (void)setModel:(ShopModel *)model{
    
    self.goodsNameLabel.text             = model.p_name;
    self.GoodsPricesLabel.text           = [NSString stringWithFormat:@"￥%.2f",model.p_price];
    self.nummberCountView.totalNum           = model.p_stock;
    self.nummberCountView.currentCountNumber = model.p_quantity;
    self.selectShopGoodsButton.selected  = model.isSelect;
 
    [self.goodsImageView setImageURL:[NSURL URLWithString:model.p_imageUrl]];
    self.goodsDesLable.text = model.p_desString;
    self.widthDes.constant = model.p_desMaxWidth;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)getCartCellHeight{
    
    return 100;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.x = 10;
    self.contentView.width = SCREEN_WIDTH - 20;
      
}
@end
