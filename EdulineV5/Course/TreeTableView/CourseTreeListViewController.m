//
//  CourseTreeListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseTreeListViewController.h"
#import "Net_Path.h"

@interface CourseTreeListViewController () {
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    NSString *cellCouserlayar;// 当前第一个cell类型
}

@end

@implementation CourseTreeListViewController

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
    [self getClassCourseList];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuse = @"NewClassCourseCell";
    NewClassCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[NewClassCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    CourseListModel *item = self.manager.showItems[indexPath.row];
    [cell setCourseInfo:item isMainPage:_isMainPage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseListModel *item = self.manager.showItems[indexPath.row];
    if ([item.type isEqualToString:@"课时"]) {
        // 跳转到播放页面
        if (_delegate && [_delegate respondsToSelector:@selector(newClassCourseCellDidSelected:indexpath:)]) {
            [_delegate newClassCourseCellDidSelected:item indexpath:indexPath];
        }
    } else {
        if (!item.isExpand) {
            item.isExpand = !item.isExpand;
            [self.manager.showItems replaceObjectAtIndex:indexPath.row withObject:item];
            [self getCourseListArray:item indepath:indexPath];
        } else {
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

- (void)tableView:(UITableView *)tableView didSelectItems:(NSArray <CourseListModel *>*)items isExpand:(BOOL)isExpand {
    
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    NSMutableArray *editIndexPaths   = [NSMutableArray array];
    
    for (CourseListModel *item in items) {
        
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
        NewClassCourseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateItem];
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

- (void)getClassCourseList {
    if (SWNOTEmptyStr(_courseId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path classCourseList:_courseId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_courseListArray removeAllObjects];
                    NSArray *pass = [NSArray arrayWithArray:[CourseListModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
                    for (CourseListModel *object in pass) {
                        object.isLeaf = YES;
                        object.level = 0;
                        object.type = @"课程";
                        [_courseListArray addObject:object];
                    }
                    NSMutableSet *items = [NSMutableSet set];
                    [_courseListArray enumerateObjectsUsingBlock:^(CourseListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        obj.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                        obj.parentID = @"";
                        obj.parentItem = nil;
                        obj.type = @"课程";
                        [items addObject:obj];
                        NSArray *zhangArray = obj.childItems;
                        
                        [zhangArray enumerateObjectsUsingBlock:^(CourseListModel *zhang, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            zhang.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                            zhang.parentID = obj.course_id;
                            zhang.parentItem = obj;
                            zhang.type = @"章";
                            [items addObject:zhang];
                            NSArray *jieArray = obj.childItems;
                            
                            [jieArray enumerateObjectsUsingBlock:^(CourseListModel *jie, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                jie.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                                jie.parentID = zhang.course_id;
                                jie.parentItem = zhang;
                                jie.type = @"节";
                                [items addObject:jie];
                                NSArray *keshiArray = jie.childItems;
                                
                                [keshiArray enumerateObjectsUsingBlock:^(CourseListModel *keshi, NSUInteger idx, BOOL * _Nonnull stop) {
                                    
                                    keshi.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                                    keshi.parentID = jie.course_id;
                                    keshi.parentItem = jie;
                                    keshi.type = @"课时";
                                    [items addObject:keshi];
                                    
                                }];
                            }];
                        }];
                        
                    }];
                    
                    MYTreeTableManager *manager = [[MYTreeTableManager alloc] initWithItems:items andExpandLevel:0];
                    _manager = manager;
                    
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程目录请求失败 = %@",error);
        }];
    }
}

- (void)getCourseListArray:(CourseListModel *)model indepath:(NSIndexPath *)path {
    
    NSString *courseId = model.course_id;
    
    CourseListModel *pmodel = model.parentItem;
    while (pmodel) {
        courseId = pmodel.course_id;
        pmodel = pmodel.parentItem;
    }
    
    if (SWNOTEmptyStr(courseId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseList:courseId pid:(SWNOTEmptyStr(model.classHourId) ? model.classHourId : @"0")] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSMutableArray *newArray = [NSMutableArray new];
                    NSArray *pass = [NSArray arrayWithArray:[CourseListModel mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"data"] objectForKey:@"section_info"] objectForKey:@"data"]]];
                    NSString *section_level = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"section_level"]];
                    if (SWNOTEmptyArr(pass)) {
                        [pass enumerateObjectsUsingBlock:^(CourseListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj.parentID = model.course_id;
                            obj.parentItem = model;
                            obj.orderNo = [NSString stringWithFormat:@"%@", @(idx)];
                            if ([section_level isEqualToString:@"1"]) {
                                if ([model.type isEqualToString:@"课程"]) {
                                    obj.type = @"课时";
                                } else if ([model.type isEqualToString:@"章"]) {
                                    obj.type = @"节";
                                } else if ([model.type isEqualToString:@"节"]) {
                                    obj.type = @"课时";
                                }
                            } else if ([section_level isEqualToString:@"2"]) {
                                if ([model.type isEqualToString:@"课程"]) {
                                    obj.type = @"节";
                                } else if ([model.type isEqualToString:@"章"]) {
                                    obj.type = @"节";
                                } else if ([model.type isEqualToString:@"节"]) {
                                    obj.type = @"课时";
                                }
                            } else if ([section_level isEqualToString:@"3"]) {
                                if ([model.type isEqualToString:@"课程"]) {
                                    obj.type = @"章";
                                } else if ([model.type isEqualToString:@"章"]) {
                                    obj.type = @"节";
                                } else if ([model.type isEqualToString:@"节"]) {
                                    obj.type = @"课时";
                                }
                            }
                            [newArray addObject:obj];
                        }];
                        
                        model.childItems = newArray;
                        
                        [_manager.showItems insertObjects:newArray atIndex:path.row + 1];
                    }
//                    for (CourseListModel *object in pass) {
//                        object.parentID = model.course_id;
//                        object.parentItem = model;
//                        [newArray addObject:object];
//                    }
//                    model.childItems = newArray;
                    [_tableView reloadData];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            NSLog(@"课程目录请求失败 = %@",error);
        }];
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
