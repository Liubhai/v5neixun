//
//  CourseListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseListVC.h"
#import "CourseCatalogCell.h"
#import "Net_Path.h"
#import "CourseListModel.h"

@interface CourseListVC () {
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
}

@end

@implementation CourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _courseListArray = [NSMutableArray new];
    _canPlayRecordVideo = YES;
    _courseId = @"1";
    [self addTableView];
    [self getCourseListData];
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
    if ([_courselayer isEqualToString:@"1"]) {
        return 0.001;
    } else if ([_courselayer isEqualToString:@"2"]) {
        return 50;
    } else if ([_courselayer isEqualToString:@"3"]) {
        return 50;
    }
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_courselayer isEqualToString:@"1"]) {
        return nil;
    }
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
    if ([_courselayer isEqualToString:@"2"]) {
        blueView.hidden = YES;
        [sectionTitle setLeft:15];
    } else if ([_courselayer isEqualToString:@"3"]) {
        [sectionTitle setLeft:blueView.right + 8];
        blueView.hidden = NO;
    }
    //给整个View添加手势
//    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_courselayer isEqualToString:@"1"]) {
        return 1;
    } else if ([_courselayer isEqualToString:@"2"]) {
        return 3;
    } else if ([_courselayer isEqualToString:@"3"]) {
        return 3;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_courselayer isEqualToString:@"1"]) {
        return 50;
    } else if ([_courselayer isEqualToString:@"2"]) {
        return 50;
    } else if ([_courselayer isEqualToString:@"3"]) {
        return 50 + 3 * 50;
    }
    return 50 + 3 * 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCatalogCell";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:reuse isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row courselayer:_courselayer isMainPage:_isMainPage];
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

- (void)getCourseListData {
    if (SWNOTEmptyStr(_courseId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseList:nil] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_courseListArray removeAllObjects];
//                    [_courseListArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
                    [_courseListArray addObjectsFromArray:[CourseListModel mj_keyValuesArrayWithObjectArray:[[responseObject objectForKey:@"data"] objectForKey:@"section_info"]]];
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程目录请求失败 = %@",error);
        }];
    }
}

@end
