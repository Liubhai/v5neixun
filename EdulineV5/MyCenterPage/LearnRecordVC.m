//
//  LearnRecordVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LearnRecordVC.h"
#import "LearnRecordCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CourseMainViewController.h"
#import "CourseDetailPlayVC.h"
#import "CourseListModel.h"
#import "FaceVerifyViewController.h"
#import "V5_UserModel.h"

@interface LearnRecordVC ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger page;
}

@property (strong ,nonatomic)UITableView *tableView;

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
//时间断点
@property (strong ,nonatomic)NSMutableArray *timeArray;
//处理后排序的数据源
@property (strong ,nonatomic)NSMutableArray *allDateArray;
//应该显示年的sectionArray
@property (strong, nonatomic) NSMutableArray *shouldShowYearSectionArray;

@end

@implementation LearnRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"我的学习记录";
    _dataSource = [NSMutableArray new];
    _timeArray = [NSMutableArray new];
    _allDateArray = [NSMutableArray new];
    _shouldShowYearSectionArray = [NSMutableArray new];
    page = 1;
    [self makeTableView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getlearnRecordList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMorelearnRecordList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _timeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_allDateArray.count == 0) {
        return 0;
    }
    NSArray *array = _allDateArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"LearnRecordCell";
    LearnRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LearnRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    } else {
        cell.topLine.hidden = NO;
    }
    NSArray *array = _allDateArray[indexPath.section];
    if (indexPath.row == array.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    [cell setLearnRecordInfo:_allDateArray[indexPath.section][indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, [_shouldShowYearSectionArray containsObject:@(section)] ? 80 : 40)];
    
    UILabel *yearSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    yearSectionLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeForYYYY:_allDateArray[section][0][@"update_time"]]];
    yearSectionLabel.font = SYSTEMFONT(24);
    yearSectionLabel.textColor = EdlineV5_Color.textFirstColor;
    [view1 addSubview:yearSectionLabel];
    
    yearSectionLabel.hidden = ![_shouldShowYearSectionArray containsObject:@(section)];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, [_shouldShowYearSectionArray containsObject:@(section)] ? 50 : 0, 200, [_shouldShowYearSectionArray containsObject:@(section)] ? 20 : 40)];
    sectionLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool timeForMMDD:_allDateArray[section][0][@"update_time"]]];
    sectionLabel.font = SYSTEMFONT(14);
    sectionLabel.textColor = EdlineV5_Color.textFirstColor;
    [view1 addSubview:sectionLabel];
    return view1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_shouldShowYearSectionArray containsObject:@(section)]) {
        return 80;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
//    vc.ID = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_id"]];
//    vc.isLive = [[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]] isEqualToString:@"2"] ? YES : NO;
//    vc.courseType = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]];
//    [self.navigationController pushViewController:vc animated:YES];
    
    // 判断是不是过期了
    NSString *timeOut = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"expire_rest"]];
    if ([timeOut isEqualToString:@"0"]) {
        [self showHudInView:self.view showHint:@"课程已过期"];
        return;
    }
    
    if ([ShowUserFace isEqualToString:@"1"]) {
        self.userFaceLearnRecordVerifyResult = ^(BOOL result) {
            CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
            vc.ID = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_id"]];
            vc.courselayer = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_level"]];
            vc.currentHourseId = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_id"]];
            vc.isLive = [[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]] isEqualToString:@"2"];
            vc.courseType = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]];
            
            CourseListModel *model = [[CourseListModel alloc] init];
            section_data_model *sectionModel = [[section_data_model alloc] init];
            sectionModel.data_type = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_data_type"]];
            section_rate_model *sectionRateModel = [[section_rate_model alloc] init];
            sectionRateModel.current_time = [[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"current_time"]] unsignedIntValue];
            model.title = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_title"]];
            model.section_data = sectionModel;
            model.section_rate = sectionRateModel;
            model.course_id = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_id"]];
            model.classHourId = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_id"]];
            vc.currentPlayModel = model;
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        if ([[V5_UserModel userFaceVerify] isEqualToString:@"1"]) {
            [self faceCompareTip:[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_id"]] sourceType:@"course_section"];
        } else {
            [self faceVerifyTip];
        }
    } else {
        CourseDetailPlayVC *vc = [[CourseDetailPlayVC alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_id"]];
        vc.courselayer = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_level"]];
        vc.currentHourseId = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_id"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]] isEqualToString:@"2"];
        vc.courseType = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_type"]];
        
        CourseListModel *model = [[CourseListModel alloc] init];
        section_data_model *sectionModel = [[section_data_model alloc] init];
        sectionModel.data_type = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_data_type"]];
        section_rate_model *sectionRateModel = [[section_rate_model alloc] init];
        sectionRateModel.current_time = [[NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"current_time"]] unsignedIntValue];
        model.title = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_title"]];
        model.section_data = sectionModel;
        model.section_rate = sectionRateModel;
        model.course_id = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"course_id"]];
        model.classHourId = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"section_id"]];
        vc.currentPlayModel = model;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getlearnRecordList {
    page = 1;
    NSMutableDictionary *pass = [NSMutableDictionary new];
    [pass setObject:@(page) forKey:@"page"];
    [pass setObject:@"10" forKey:@"count"];
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path learnRecordList] WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
            }
        }
        if (_dataSource.count<10) {
            _tableView.mj_footer.hidden = YES;
        } else {
            _tableView.mj_footer.hidden = NO;
            [_tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [_timeArray removeAllObjects];
        [_allDateArray removeAllObjects];
        [_shouldShowYearSectionArray removeAllObjects];
        [self dealDataSource];
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMorelearnRecordList {
    page = page + 1;
    NSMutableDictionary *pass = [NSMutableDictionary new];
    [pass setObject:@(page) forKey:@"page"];
    [pass setObject:@"10" forKey:@"count"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path learnRecordList] WithAuthorization:nil paramDic:pass finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *passArray = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:passArray];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_timeArray removeAllObjects];
        [_allDateArray removeAllObjects];
        [_shouldShowYearSectionArray removeAllObjects];
        [self dealDataSource];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark --- 处理数据
- (void)dealDataSource {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年"];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSMutableArray *_titleTimeArray = [NSMutableArray new];
    
    for (int i = 0 ; i < _dataSource.count ; i ++) {
        NSString *timeStr =  [EdulineV5_Tool formatterDate:_dataSource[i][@"update_time"]];
        [_titleTimeArray addObject:timeStr];
    }
    
    NSMutableArray *timeArray = [NSMutableArray array];
    NSMutableArray *numArray = [NSMutableArray array];
    
    for (int i = 0 ; i < _titleTimeArray.count ; i ++) {
        NSString *timeStr = _titleTimeArray[i];
        if (![timeArray containsObject:timeStr]) {
            [timeArray addObject:timeStr];
        } else {
            NSLog(@"%d",i);
            [numArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    _timeArray = timeArray;
    
    NSMutableArray *array= [NSMutableArray arrayWithArray:_dataSource];
    
    NSMutableArray*dateMutablearray = [@[]mutableCopy];
    for(int i = 0;i < array.count;i ++) {
        
        NSDictionary *dict1 = array[i];
        
        NSMutableArray*tempArray = [@[]mutableCopy];
        
        [tempArray addObject:dict1];
        
        for(int j = i+1;j < array.count;j ++) {
            
            NSDictionary *dict2 = array[j];
            
            NSString *day1 = [EdulineV5_Tool formatterDate:dict1[@"update_time"]];
            NSString *day2 = [EdulineV5_Tool formatterDate:dict2[@"update_time"]];
            
            if([ day1 isEqualToString:day2]){
                
                [tempArray addObject:dict2];
                
                [array removeObjectAtIndex:j];
                
                j -= 1;
                
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    _allDateArray = dateMutablearray;
    NSMutableArray *showYearArray = [NSMutableArray new];
    for (int i = 0; i<_allDateArray.count; i ++) {
        NSArray *sectionArray = _allDateArray[i];
        NSString *yearString = [EdulineV5_Tool timeForYYYY:sectionArray[0][@"update_time"]];
        [showYearArray addObject:yearString];
    }
    
    NSMutableArray *timeArray1 = [NSMutableArray array];
    NSMutableArray *numArray1 = [NSMutableArray array];
    
    for (int i = 0 ; i < showYearArray.count ; i ++) {
        NSString *timeStr = showYearArray[i];
        if (![timeArray1 containsObject:timeStr] && ![timeStr isEqualToString:currentDay]) {
            [timeArray1 addObject:timeStr];
            [numArray1 addObject:@(i)];
        }
    }
    
    _shouldShowYearSectionArray = numArray1;
    
    [_tableView reloadData];
}

// MARK: - 人脸未认证提示
- (void)faceVerifyTip {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"未完成人脸认证\n请先去认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = YES;
        vc.verifyed = NO;
        vc.verifyResult = ^(BOOL result) {
//            if (result) {
//                self.userFaceVerifyResult(result);
//            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

// MARK: - 人脸识别提示
- (void)faceCompareTip:(NSString *)courseHourseId sourceType:(NSString *)type {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请进行人脸验证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commentAction = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FaceVerifyViewController *vc = [[FaceVerifyViewController alloc] init];
        vc.isVerify = NO;
        vc.verifyed = YES;
        vc.sourceType = type;
        vc.sourceId = courseHourseId;
        vc.scene_type = @"1";
        vc.verifyResult = ^(BOOL result) {
            if (result) {
                self.userFaceLearnRecordVerifyResult(result);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        }];
    [commentAction setValue:EdlineV5_Color.themeColor forKey:@"_titleTextColor"];
    [alertController addAction:commentAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    [cancelAction setValue:EdlineV5_Color.textSecendColor forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


@end
