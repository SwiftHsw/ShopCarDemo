//
//  ViewController.m
//  SWShoppingCartDemo
//
//  Created by 帅到不行 on 2021/2/4.
//  Copyright © 2021 lity. All rights reserved.
//

#import "ViewController.h"
#import <UITableView+SW_Extension.h>
#import "SWCartBarView.h"
#import "SWShopCartHeaderView.h" //上
#import "SWShopCell.h"
#import "SWShopCartFooterView.h"//下
#import "SWShopViewModel.h"

static NSString  * const SWShopCartHeaderView_ID = @"SWShopCartHeaderView";
static NSString  * const SWShopCartCell_ID = @"SWShopCell";
static NSString  * const SWShopCartFooterView_ID = @"SWShopCartFooterView";



@interface ViewController ()
{
    ///开启编辑/删除
     BOOL _isIdit;
     UIBarButtonItem *_editItem;
      SWSlidePopupView *sildeView;
}
@property (nonatomic,strong) SWCartBarView     *carBar;
@property (nonatomic,strong) SWShopViewModel   *viewModel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel getData];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = true;
    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(editClick:)];
    _editItem.tintColor = UIColorRGB(170, 170, 170);
    self.navigationItem.rightBarButtonItem = _editItem;
    
    /*add View*/
   
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.carBar];
    self.tableView.isShowNodata = YES;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self bangdingRAC];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SAFEBOTTOM_HEIGHT - 50);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.tableView registerClass:[SWShopCartHeaderView class] forHeaderFooterViewReuseIdentifier:SWShopCartHeaderView_ID];
    [self.tableView registerClass:[SWShopCartFooterView class] forHeaderFooterViewReuseIdentifier:SWShopCartFooterView_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SWShopCell" bundle:nil] forCellReuseIdentifier:SWShopCartCell_ID];
    
    
  
}

- (void)editClick:(UIBarButtonItem *)item{
    _isIdit = !_isIdit;
    _editItem.title = _isIdit ? @"完成":@"编辑";
    self.carBar.isNormalState = !_isIdit;
    
}

- (void)bangdingRAC{
    
    WeakSelf(self)
    //删除
    [[self.carBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        StrongSelf(self)
        [self.viewModel deleteGoodsBySelect];
     }];
    
    //全选
    [[self.carBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
           x.selected = !x.selected;
          [self.viewModel selectAll:x.selected];
     }];
    //结算
    [[self.carBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        
    }];
    
     /* 观察价格属性 */
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        StrongSelf(self)
         self.carBar.money = x.floatValue;
    }];
    
    /* 观察 全选 状态 */
    RAC(self.carBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    
      /* 购物车数量 */
    
//    [RACObserve(self, <#KEYPATH#>)]
}
#pragma mark -tableView dg

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.cartData[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [SWShopCartHeaderView getCartHeaderHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.viewModel.cartData[section];

    SWShopCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SWShopCartHeaderView_ID];
    [headerView.storeNameButton setTitle:[NSString stringWithFormat:@"我是%ld的店铺",section+1]
                        forState:UIControlStateNormal];
    //店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *xx) {
        xx.selected = !xx.selected;
        BOOL isSelect = xx.selected;
        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        for (ShopModel *model in shopArray) {
            //全选/取消全选
            model.isSelect = isSelect;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        self.viewModel.allPrices = [self.viewModel getAllPrices];
    }];
    //店铺选中状态
    headerView.selectStoreGoodsButton.selected = [self.viewModel.shopSelectArray[section] boolValue];
 
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [SWShopCartFooterView getCartFooterHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    
    SWShopCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SWShopCartFooterView_ID];
    
    footerView.shopGoodsArray = shopArray;
    
    return footerView;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWShopCell *cell = [tableView dequeueReusableCellWithIdentifier:SWShopCartCell_ID
                                                       forIndexPath:indexPath];
    
      //赋值
      cell.model = self.viewModel.cartData[indexPath.section][indexPath.row];
    
     //cell点击勾选
      WeakSelf(self)
      [[[cell.selectShopGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
             StrongSelf(self)
             x.selected = !x.selected;
             [self.viewModel rowSelect:x.selected IndexPath:indexPath];
        }];
    cell.goodsDesLable.tag = indexPath.row;
    [cell.goodsDesLable addTapGestureRecognizer:@selector(didGoodDesAction:) target:self numberTaps:1];

    
      
      //数量改变
       cell.nummberCountView.NumberChangeBlock = ^(NSInteger changeCount){
             StrongSelf(self)
             [self.viewModel rowChangeQuantity:changeCount indexPath:indexPath];
         
        };
    return cell;
}
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
     
     return YES;
 }

 - (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     return @"删除";
 }

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         [self.viewModel deleteGoodsBySingleSlide:indexPath];
     }
 }
 
- (void)didGoodDesAction:(UITapGestureRecognizer *)tap{
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, SCREEN_HEIGHT *.7)];
             contentView.backgroundColor = [UIColor redColor];
             
            sildeView = [SWSlidePopupView popupViewWithFrame:UIScreen.mainScreen.bounds contentView:contentView]; 
           [sildeView showFrom:self.view completion:^{
                 
                 //弹出后要做的事情
                 
         }];
    
}
#pragma mark - Lazy Load

- (SWCartBarView *)carBar{
    if (!_carBar) {
        _carBar = [[SWCartBarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - SAFEBOTTOM_HEIGHT, SCREEN_WIDTH, 50 + SAFEBOTTOM_HEIGHT)];
    }
    return _carBar;
    
}

- (SWShopViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[SWShopViewModel alloc] init];
        _viewModel.cartVC = self;
    }
    return _viewModel;
}

@end
