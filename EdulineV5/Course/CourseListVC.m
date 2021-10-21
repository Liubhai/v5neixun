//
//  CourseListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseListVC.h"
#import "Net_Path.h"
//#import "CourseListModel.h"
//#import "CourseListModelFinal.h"

@interface CourseListVC ()<CourseCatalogCellDelegate> {
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    NSString *cellCouserlayar;// 当前第一个cell类型
}

@end

@implementation CourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([_courselayer isEqualToString:@"1"]) {
        cellCouserlayar = @"3";
    } else if ([_courselayer isEqualToString:@"2"]) {
        cellCouserlayar = @"2";
    } else {
        cellCouserlayar = @"1";
    }
    _courseListArray = [NSMutableArray new];
    _canPlayRecordVideo = YES;
    [self addTableView];
    [self getCourseListData];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
//    if ([_courselayer isEqualToString:@"1"]) {
//        return 0.001;
//    } else if ([_courselayer isEqualToString:@"2"]) {
//        return 50;
//    } else if ([_courselayer isEqualToString:@"3"]) {
//        return 50;
//    }
//    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
//    if ([_courselayer isEqualToString:@"1"]) {
//        return nil;
//    }
//    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
//    tableHeadView.backgroundColor = [UIColor whiteColor];
//    tableHeadView.tag = section;
//
//    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
//    blueView.backgroundColor = EdlineV5_Color.themeColor;
//    blueView.layer.masksToBounds = YES;
//    blueView.layer.cornerRadius = 2;
//    [tableHeadView addSubview:blueView];
//
//    //添加标题
//    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 50, 50)];
//    sectionTitle.text = @"课程第几章";
//    sectionTitle.textColor = EdlineV5_Color.textFirstColor;
//    sectionTitle.font = SYSTEMFONT(15);
//    [tableHeadView addSubview:sectionTitle];
//
//    UIButton *courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
//    [courseRightBtn setImage:Image(@"contents_down") forState:0];
//    [courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
//    [tableHeadView addSubview:courseRightBtn];
//    if ([_courselayer isEqualToString:@"2"]) {
//        blueView.hidden = YES;
//        [sectionTitle setLeft:15];
//    } else if ([_courselayer isEqualToString:@"3"]) {
//        [sectionTitle setLeft:blueView.right + 8];
//        blueView.hidden = NO;
//    }
//    //给整个View添加手势
////    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
//
//    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    if ([_courselayer isEqualToString:@"1"]) {
//        return 1;
//    } else if ([_courselayer isEqualToString:@"2"]) {
//        return 3;
//    } else if ([_courselayer isEqualToString:@"3"]) {
//        return 3;
//    }
//    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    if ([_courselayer isEqualToString:@"1"]) {
//        return 50;
//    } else if ([_courselayer isEqualToString:@"2"]) {
//        return 50;
//    } else if ([_courselayer isEqualToString:@"3"]) {
//        return 50 + 3 * 50;
//    }
//    return 50 + 3 * 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CourseCatalogCell";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:reuse isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row courselayer:cellCouserlayar isMainPage:_isMainPage allLayar:_courselayer isLive:self.vc ? self.vc.isLive : self.detailVC.isLive];
    }
    cell.delegate = self;
    CourseListModelFinal *model = _courseListArray[indexPath.row];
    model.cellIndex = indexPath;
    if ([_courselayer isEqualToString:@"1"]) {
        model.courselayer = @"3";
    } else if ([_courselayer isEqualToString:@"2"]) {
        model.courselayer = @"2";
    } else {
        model.courselayer = @"1";
    }
    if (SWNOTEmptyDictionary(_videoInfoDict)) {
        cell.courseIsBuy = [[_videoInfoDict objectForKey:@"is_buy"] boolValue];
    } else {
        cell.courseIsBuy = NO;
    }
    model.allLayar = _courselayer;
    [cell setListInfo:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_courselayer isEqualToString:@"1"]) {
        CourseCatalogCell *cell = (CourseCatalogCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (_delegate && [_delegate respondsToSelector:@selector(playVideo:cellIndex:panrentCellIndex:superCellIndex:currentCell:)]) {
            [_delegate playVideo:_courseListArray[indexPath.row] cellIndex:indexPath panrentCellIndex:nil superCellIndex:nil currentCell:cell];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        } else {
            if (self.detailVC.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.detailVC.canScroll = YES;
            }
        }
    }
}

- (void)getCourseListData {
    if (SWNOTEmptyStr(_courseId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseList:_courseId pid:@"0"] WithAuthorization:nil paramDic:@{@"page":@"1",@"count":@"500"} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSString *course_buy_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"course_buy_status"]];
                    [_courseListArray removeAllObjects];
                    NSArray *pass = [NSArray arrayWithArray:[CourseListModel mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"data"] objectForKey:@"section_info"] objectForKey:@"data"]]];
                    _courselayer = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"section_level"]];
                    if ([_courselayer isEqualToString:@"1"]) {
                        cellCouserlayar = @"3";
                    } else if ([_courselayer isEqualToString:@"2"]) {
                        cellCouserlayar = @"2";
                    } else {
                        cellCouserlayar = @"1";
                    }
                    for (CourseListModel *object in pass) {
                        object.is_course_buy = [course_buy_status boolValue];
                        CourseListModelFinal *model = [CourseListModelFinal canculateHeight:object cellIndex:nil courselayer:cellCouserlayar allLayar:_courselayer isMainPage:_isMainPage];
                        [_courseListArray addObject:model];
                    }
                    [self justReloadListStatus];
//                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程目录请求失败 = %@",error);
        }];
    }
}

- (void)listChangeUpAndDown:(UIButton *)sender listModel:(CourseListModelFinal *)model panrentListModel:(nonnull CourseListModelFinal *)panrentModel {
    if (panrentModel) {
        if (model.isExpanded) {
            if (SWNOTEmptyArr(_courseListArray)) {
                CourseListModelFinal *modelpass1 = _courseListArray[panrentModel.cellIndex.row];
                CourseListModelFinal *modelpass2 = modelpass1.child[model.cellIndex.row];
                modelpass2.isExpanded = NO;
                [modelpass1.child replaceObjectAtIndex:model.cellIndex.row withObject:modelpass2];
                [_courseListArray replaceObjectAtIndex:panrentModel.cellIndex.row withObject:modelpass1];
            }
//            [_tableView reloadData];
            [self justReloadListStatus];
        } else {
            if (model.child) {
                if (SWNOTEmptyArr(_courseListArray)) {
                    CourseListModelFinal *modelpass1 = _courseListArray[panrentModel.cellIndex.row];
                    CourseListModelFinal *modelpass2 = modelpass1.child[model.cellIndex.row];
                    modelpass2.isExpanded = YES;
                    [modelpass1.child replaceObjectAtIndex:model.cellIndex.row withObject:modelpass2];
                    [_courseListArray replaceObjectAtIndex:panrentModel.cellIndex.row withObject:modelpass1];
                }
//                [_tableView reloadData];
                [self justReloadListStatus];
                return;
            }
            if (SWNOTEmptyStr(_courseId) && SWNOTEmptyStr(model.model.classHourId)) {
                [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseList:_courseId pid:model.model.classHourId] WithAuthorization:nil paramDic:@{@"page":@"1",@"count":@"500"} finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            NSString *course_buy_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"course_buy_status"]];
                            NSMutableArray *passOrigin = [NSMutableArray new];
                            NSArray *pass = [NSArray arrayWithArray:[CourseListModel mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"data"] objectForKey:@"section_info"] objectForKey:@"data"]]];
                            for (CourseListModel *object in pass) {
                                object.is_course_buy = [course_buy_status boolValue];
                                CourseListModelFinal *model = [CourseListModelFinal canculateHeight:object cellIndex:nil courselayer:cellCouserlayar allLayar:_courselayer isMainPage:_isMainPage];
                                [passOrigin addObject:model];
                            }
                            if (SWNOTEmptyArr(_courseListArray)) {
                                CourseListModelFinal *modelpass1 = _courseListArray[panrentModel.cellIndex.row];
                                CourseListModelFinal *modelpass2 = modelpass1.child[model.cellIndex.row];
                                modelpass2.isExpanded = YES;
                                modelpass2.child = [NSMutableArray arrayWithArray:passOrigin];
                                [modelpass1.child replaceObjectAtIndex:model.cellIndex.row withObject:modelpass2];
                                [_courseListArray replaceObjectAtIndex:panrentModel.cellIndex.row withObject:modelpass1];
                            }
//                            [_tableView reloadData];
                            [self justReloadListStatus];
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    NSLog(@"课程目录请求失败 = %@",error);
                }];
            }
        }
    } else {
        if (model.isExpanded) {
            if (SWNOTEmptyArr(_courseListArray)) {
                CourseListModelFinal *modelpass = _courseListArray[model.cellIndex.row];
                modelpass.isExpanded = NO;
                [_courseListArray replaceObjectAtIndex:model.cellIndex.row withObject:modelpass];
            }
//            [_tableView reloadData];
            [self justReloadListStatus];
        } else {
            if (model.child) {
                if (SWNOTEmptyArr(_courseListArray)) {
                    CourseListModelFinal *modelpass = _courseListArray[model.cellIndex.row];
                    modelpass.isExpanded = YES;
                    [_courseListArray replaceObjectAtIndex:model.cellIndex.row withObject:modelpass];
                }
//                [_tableView reloadData];
                [self justReloadListStatus];
                return;
            }
            if (SWNOTEmptyStr(_courseId) && SWNOTEmptyStr(model.model.classHourId)) {
                [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseList:_courseId pid:model.model.classHourId] WithAuthorization:nil paramDic:@{@"page":@"1",@"count":@"500"} finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            NSString *course_buy_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"course_buy_status"]];
                            NSMutableArray *passOrigin = [NSMutableArray new];
                            NSArray *pass = [NSArray arrayWithArray:[CourseListModel mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"data"] objectForKey:@"section_info"] objectForKey:@"data"]]];
                            for (CourseListModel *object in pass) {
                                object.is_course_buy = [course_buy_status boolValue];
                                CourseListModelFinal *model = [CourseListModelFinal canculateHeight:object cellIndex:nil courselayer:cellCouserlayar allLayar:_courselayer isMainPage:_isMainPage];
                                [passOrigin addObject:model];
                            }
                            if (SWNOTEmptyArr(_courseListArray)) {
                                CourseListModelFinal *modelpass = _courseListArray[model.cellIndex.row];
                                modelpass.isExpanded = YES;
                                modelpass.child = [NSMutableArray arrayWithArray:passOrigin];
                                [_courseListArray replaceObjectAtIndex:model.cellIndex.row withObject:modelpass];
                            }
//                            [_tableView reloadData];
                            [self justReloadListStatus];
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    NSLog(@"课程目录请求失败 = %@",error);
                }];
            }
        }
    }
}

- (void)playCellVideo:(CourseListModelFinal *)model currentCellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex currentCell:(nonnull CourseCatalogCell *)cell {
    if (_delegate && [_delegate respondsToSelector:@selector(playVideo:cellIndex:panrentCellIndex:superCellIndex:currentCell:)]) {
        [_delegate playVideo:model cellIndex:cellIndex panrentCellIndex:panrentCellIndex superCellIndex:superIndex currentCell:cell];
    }
}

// MARK: - 刷新正在观看的课时、章、节等cell的状态
- (void)justReloadListStatus {
    if (SWNOTEmptyDictionary(_current_position)) {
        NSMutableArray *current_position = [NSMutableArray arrayWithArray:_current_position[@"position"]];
        
        for (int i = 0; i<_courseListArray.count; i++) {
            CourseListModelFinal *model1 = _courseListArray[i];
            for (int j = 0; j<model1.child.count; j++) {
                CourseListModelFinal *model2 = model1.child[j];
                for (int k = 0; k<model2.child.count; k++) {
                    CourseListModelFinal *model3 = model2.child[k];
                    model3.isPlaying = NO;
                    if (current_position.count == 3) {
                        if ([model3.model.classHourId isEqualToString:[NSString stringWithFormat:@"%@",current_position[2]]]) {
                            model3.isPlaying = YES;
                        }
                    }
                    [model2.child replaceObjectAtIndex:k withObject:model3];
                }
                model2.isPlaying = NO;
                
                if (current_position.count >= 2) {
                    if ([model2.model.classHourId isEqualToString:[NSString stringWithFormat:@"%@",current_position[1]]]) {
                        model2.isPlaying = YES;
                    }
                }
                [model1.child replaceObjectAtIndex:j withObject:model2];
            }
            model1.isPlaying = NO;
            if (current_position.count >= 1) {
                if ([model1.model.classHourId isEqualToString:[NSString stringWithFormat:@"%@",current_position[0]]]) {
                    model1.isPlaying = YES;
                }
            }
            [_courseListArray replaceObjectAtIndex:i withObject:model1];
        }
    }
    [_tableView reloadData];
}



- (void)dealloc {
    NSLog(@"1111111111111");
}

@end
