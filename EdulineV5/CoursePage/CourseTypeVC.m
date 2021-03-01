//
//  CourseTypeVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseTypeVC.h"
#import "CourseCommonCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface CourseTypeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation CourseTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.view.hidden = YES;
    _titleImage.hidden = YES;
    _dataSource = [NSMutableArray new];
    [self maketableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
    [self getCourseTypeList];
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _dataSource.count * 60)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SearchHistoryListCell";
    CourseCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse showOneLine:YES];
    }
    [cell setCourseCommonCellInfo:_dataSource[indexPath.row] searchKeyWord:_typeId];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _typeId = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    [_tableView reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCourseType:)]) {
        [_delegate chooseCourseType:_dataSource[indexPath.row]];
    }
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getCourseTypeList {
    NSString *getUrl = [Net_Path coursetypeList];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([_typeString isEqualToString:@"exam"]) {
        getUrl = [Net_Path openingExamCategoryNet];
        [param setObject:@"3" forKey:@"module_id"];
    }
    [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                _tableView.frame = CGRectMake(0, 0, MainScreenWidth, _dataSource.count * 60 > (MainScreenHeight - MACRO_UI_UPHEIGHT) ? (MainScreenHeight - MACRO_UI_UPHEIGHT) : _dataSource.count * 60);
                [_tableView reloadData];
                self.view.hidden = NO;
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
