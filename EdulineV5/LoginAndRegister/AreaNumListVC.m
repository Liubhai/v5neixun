//
//  AreaNumListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "AreaNumListVC.h"
#import "V5_Constant.h"

#import "AreaTableViewCell.h"

@interface AreaNumListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *areaArray;
@property (strong, nonatomic) NSMutableArray *allKeyArray;
@property (strong, nonatomic) NSDictionary *areaInfo;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AreaNumListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"选择国家或地区";
    _areaArray = [NSMutableArray new];
    _allKeyArray = [NSMutableArray new];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AreaNumCode" ofType:@"plist"];
    //当数据结构为数组时
//    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    //当数据结构为非数组时
    _areaInfo = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *pass = [_areaInfo allKeysSorted];
    [_allKeyArray addObjectsFromArray:pass];
    
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexColor = EdlineV5_Color.themeColor;
    [self.view addSubview:_tableView];
}

//返回索引栏数据
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeyArray;
}

//建立索引栏和section的关联
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_allKeyArray indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_areaInfo objectForKey:_allKeyArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuserIdentifier = @"areaCell";
    AreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    [cell setAreaInfo:[_areaInfo objectForKey:_allKeyArray[indexPath.section]][indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40.0)];
    headerView.backgroundColor = EdlineV5_Color.backColor;
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15 * WidthRatio, 0, MainScreenWidth - 15 * WidthRatio, 40)];
    headerTitle.text = [NSString stringWithFormat:@"%@",_allKeyArray[section]];
    headerTitle.textColor = EdlineV5_Color.textFirstColor;
    headerTitle.backgroundColor = EdlineV5_Color.backColor;
    [headerView addSubview:headerTitle];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_areaNumCodeBlock) {
        NSArray *pass = [NSArray arrayWithArray:[_areaInfo objectForKey:_allKeyArray[indexPath.section]][indexPath.row]];
        _areaNumCodeBlock(pass[1]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
