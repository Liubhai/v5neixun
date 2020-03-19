//
//  CourseListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseListVC.h"
#import "CourseCatalogCell.h"

@interface CourseListVC () {
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
}

@end

@implementation CourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _canPlayRecordVideo = YES;
    [self addTableView];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    tableHeadView.backgroundColor = [UIColor whiteColor];
    tableHeadView.tag = section;
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
    blueView.backgroundColor = EdlineV5_Color.themeColor;
    blueView.layer.masksToBounds = YES;
    blueView.layer.cornerRadius = 2;
    [tableHeadView addSubview:blueView];
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 50, 50)];
    sectionTitle.text = @"课程第几章";
    sectionTitle.textColor = EdlineV5_Color.textFirstColor;
    sectionTitle.font = SYSTEMFONT(15);
    [tableHeadView addSubview:sectionTitle];
    
    UIButton *courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
    [courseRightBtn setImage:Image(@"contents_down") forState:0];
    [courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
    [tableHeadView addSubview:courseRightBtn];
    if (_isClassCourse) {
        [sectionTitle setLeft:blueView.right + 8];
        blueView.hidden = NO;
    } else {
        blueView.hidden = YES;
        [sectionTitle setLeft:15];
    }
    
    //给整个View添加手势
//    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 + 3 * 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCatalogCell";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:reuse isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc.canScrollAfterVideoPlay == YES) {
            self.cellTabelCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            self.vc.canScroll = YES;
        }
    }
}


@end
