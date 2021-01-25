//
//  ZhuangXiangListTreeTableVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuangXiangListTreeTableVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ZhuangXiangListCell.h"
#import "ZhuanXiangModel.h"
#import "ZhuangXiangListCell.h"

@interface ZhuangXiangListTreeTableVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSInteger page;
    BOOL canSelect;//开关阀门 连续点击一个cell会出问题(由于网络延迟问题)
}

@property (strong, nonatomic) UITextField *institutionSearch;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ZhuangXiangListTreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    canSelect = YES;
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self makeTopSearch];
    
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [self makeData];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top - 2, MainScreenWidth - _leftButton.width - 15, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索专项名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17 + 15 + 10, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    _institutionSearch.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"ZhuangXiangListCell";
    ZhuangXiangListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ZhuangXiangListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    ZhuanXiangModel *item = self.manager.showItems[indexPath.row];
    [cell setZhuangXiangCellInfo:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZhuanXiangModel *item = self.manager.showItems[indexPath.row];
    if (item.level == 2) {
        
    } else {
        if (!item.isExpand) {
            if (!canSelect) {
                return;
            }
            canSelect = NO;
            NSLog(@"展开");
            item.isExpand = !item.isExpand;
            [self.manager.showItems replaceObjectAtIndex:indexPath.row withObject:item];
            [self getZhuangXiangListArray:item indepath:indexPath];
        } else {
            if (!canSelect) {
                return;
            }
            canSelect = NO;
            NSLog(@"收起");
//            item.isExpand = !item.isExpand;
//            [self.manager.showItems replaceObjectAtIndex:indexPath.row withObject:item];
            [self tableView:tableView didSelectItems:@[item] isExpand:!item.isExpand];
        }
    }
    
}

#pragma mark - Private Method

- (NSArray <NSIndexPath *>*)getUpdateIndexPathsWithCurrentIndexPath:(NSIndexPath *)indexPath andUpdateNum:(NSInteger)updateNum {
    
    NSMutableArray *tmpIndexPaths = [NSMutableArray arrayWithCapacity:updateNum];
    for (int i = 0; i < updateNum; i++) {
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
        [tmpIndexPaths addObject:tmp];
    }
    return tmpIndexPaths;
}

- (UIColor *)getColorWithRed:(NSInteger)redNum green:(NSInteger)greenNum blue:(NSInteger)blueNum {
    return [UIColor colorWithRed:redNum/255.0 green:greenNum/255.0 blue:blueNum/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectItems:(NSArray <ZhuanXiangModel *>*)items isExpand:(BOOL)isExpand {
    
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    NSMutableArray *editIndexPaths   = [NSMutableArray array];
    
    for (ZhuanXiangModel *item in items) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.manager.showItems indexOfObject:item] inSection:0];
        [updateIndexPaths addObject:indexPath];
        
        NSInteger updateNum = [self.manager expandItem:item];
        NSArray *tmp = [self getUpdateIndexPathsWithCurrentIndexPath:indexPath andUpdateNum:updateNum];
        [editIndexPaths addObjectsFromArray:tmp];
    }
    
    if (isExpand) {
        [tableView insertRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
//        [tableView deleteRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        // 上面 delete 方法有弊端  暂不清楚原因 这里直接 table 刷新
        [_tableView reloadData];
    }
    
    for (NSIndexPath *indexPath in updateIndexPaths) {
        ZhuangXiangListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateItem];
    }
    canSelect = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)makeData {
    
    ZhuanXiangModel *model11 = [[ZhuanXiangModel alloc] init];
    model11.course_id = @"11";
    model11.price = @"11.00";
    model11.is_buy = YES;
    model11.level = 0;
    model11.title = @"普通课程试卷汇总";
    model11.orderNo = @"0";
    
    ZhuanXiangModel *model12 = [[ZhuanXiangModel alloc] init];
    model12.course_id = @"12";
    model12.price = @"12.00";
    model12.is_buy = YES;
    model12.level = 0;
    model12.title = @"专项课程试卷汇总之专项课程列表";
    model12.orderNo = @"1";
    
    NSMutableSet *items = [NSMutableSet set];
    [items addObject:model11];
    [items addObject:model12];
//    [items addObject:model21];
//    [items addObject:model31];
//    [items addObject:model32];
    
    ZhuangXiangModelManager *manager = [[ZhuangXiangModelManager alloc] initWithItems:items andExpandLevel:0];
    _manager = manager;
    [_tableView reloadData];
}

- (void)getZhuangXiangListArray:(ZhuanXiangModel *)model indepath:(NSIndexPath *)path {
    if (model.level == 0) {
        ZhuanXiangModel *model21 = [[ZhuanXiangModel alloc] init];
        model21.course_id = @"21";
        model21.price = @"31.00";
        model21.is_buy = YES;
        model21.level = 1;
        model21.title = @"普通课程试卷";
        model21.orderNo = @"0";
        model21.parentItem = model;
        model21.parentID = model.course_id;
        
        model.childItems = [NSMutableArray arrayWithArray:@[model21]];
        [_manager.showItems insertObjects:@[model21] atIndex:path.row + 1];
        [_tableView reloadData];
        canSelect = YES;
        
    } else {
        ZhuanXiangModel *model31 = [[ZhuanXiangModel alloc] init];
        model31.course_id = @"31";
        model31.price = @"31.00";
        model31.is_buy = YES;
        model31.level = 2;
        model31.title = @"数学";
        model31.orderNo = @"0";
        model31.parentItem = model;
        model31.parentID = model.course_id;

        ZhuanXiangModel *model32 = [[ZhuanXiangModel alloc] init];
        model32.course_id = @"32";
        model32.price = @"32.00";
        model32.is_buy = NO;
        model32.level = 2;
        model32.title = @"语文";
        model32.orderNo = @"1";
        model32.parentItem = model;
        model32.parentID = model.course_id;
        model.childItems = [NSMutableArray arrayWithArray:@[model31,model32]];
        
        [_manager.showItems insertObjects:@[model31,model32] atIndex:path.row + 1];
        [_tableView reloadData];
        canSelect = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
