//
//  ExamNewMainCateListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/10.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ExamNewMainCateListVC.h"

#import "V5_Constant.h"
#import "ExamNewMainListCell.h"
#import "Net_Path.h"

#import "AppDelegate.h"
#import "V5_UserModel.h"
#import "MyExamPage.h"

#import "SpecialProjectExamList.h"
#import "ExamPointSelectVC.h"

#import "TaojuanListViewController.h"

#import "ZhuangXiangListTreeTableVC.h"

@interface ExamNewMainCateListVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *headerView;

@end

@implementation ExamNewMainCateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleImage.hidden = YES;
    
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeHeaderView];
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeHeaderView {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 110)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    NSArray *orderSortArray = @[@{@"image":@"exam_apportion",@"title":@"分配考试"},@{@"image":@"exam_record",@"title":@"考试记录"},@{@"image":@"exam_topic",@"title":@"题目收藏"},@{@"image":@"exma_wrongtopic",@"title":@"错题本"}];
    
    CGFloat BtnWidth = MainScreenWidth / (orderSortArray.count * 1.0);
    
    for (int i = 0; i< orderSortArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(BtnWidth * i, 0, BtnWidth, 110)];
        btn.tag = i;
        NSString *imageName = [orderSortArray[i] objectForKey:@"image"];
        [btn setImage:Image(imageName) forState:0];
        [btn setTitle:[orderSortArray[i] objectForKey:@"title"] forState:0];
        btn.titleLabel.font = SYSTEMFONT(12);
        [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-8/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-8/2.0, 0);
        [btn addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
    }
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstList)];
    _tableView.mj_footer.hidden = YES;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"ExamNewMainListCell";
    ExamNewMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ExamNewMainListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setExamNewMainCellInfo:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42 + 90 * (MainScreenWidth - 30) / 345 + 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *examTheme = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"module_type"]];
    if ([examTheme isEqualToString:@"3"]) {
        SpecialProjectExamList *vc = [[SpecialProjectExamList alloc] init];
        vc.examTypeId = examTheme;
        vc.examModuleId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([examTheme isEqualToString:@"1"]) {
        ExamPointSelectVC *vc = [[ExamPointSelectVC alloc] init];
        vc.examTypeString = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"title"]];
        vc.examTypeId = examTheme;
        vc.examModuleId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]];;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (([examTheme isEqualToString:@"4"])) {
        TaojuanListViewController *vc = [[TaojuanListViewController alloc] init];
        vc.module_id = examTheme;
        vc.examModuleId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]];;
        vc.module_title = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"title"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([examTheme isEqualToString:@"2"]) {
        ZhuangXiangListTreeTableVC *vc = [[ZhuangXiangListTreeTableVC alloc] init];
        vc.examTypeId = examTheme;
        vc.examModuleId = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getFirstList {
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examMainPageNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            [_dataSource removeAllObjects];
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
            }
            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
            [_tableView reloadData];
        }
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.refreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)orderButtonClick:(UIButton *)sender {
    
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    
    MyExamPage *vc = [[MyExamPage alloc] init];
    if (sender.tag == 1) {
        vc.sortTypeFromFind = @{@"title":@"考试记录",@"id":@"examRecord"};
    } else if (sender.tag == 2) {
        vc.sortTypeFromFind = @{@"title":@"题目收藏",@"id":@"examCollect"};
    } else if (sender.tag == 3) {
        vc.sortTypeFromFind = @{@"title":@"错题本",@"id":@"errorExam"};
    } else {
        vc.sortTypeFromFind = @{@"title":@"分配考试",@"id":@"examApportion"};
    }
    [self.navigationController pushViewController:vc animated:YES];
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
