//
//  NewClassCourseCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "CourseListModel.h"
#import "CourseListModelFinal.h"
#import "playAnimationView.h"
#import "NewClassCourseModel.h"
#import "CourseCatalogCell.h"

NS_ASSUME_NONNULL_BEGIN

@class NewClassCourseCell;

@protocol NewClassCourseCellDelegate <NSObject>

@optional
- (void)getCourseFirstList:(NewClassCourseCell *)cell;

@end

@interface NewClassCourseCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource,CourseCatalogCellDelegate>

@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *courseRightBtn;

@property (assign, nonatomic) id<NewClassCourseCellDelegate> delegate;


@property (strong, nonatomic) UITableView *cellTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) NSInteger cellRow;
@property (assign, nonatomic) NSInteger cellSection;

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局) 自己属于第几层样式
@property (strong, nonatomic) NSString *allLayar;// 总共有几层
@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录
@property (assign, nonatomic) BOOL isLive;//是不是直播  区分直播详情页和其他类型详情页
@property (strong, nonatomic) CourseListModel *listModel;
@property (strong, nonatomic) CourseListModelFinal *listFinalModel;//CourseListModelFinal

@property (strong, nonatomic) NewClassCourseModel *newClassModel;

- (void)setNewClassCourseModelInfo:(NewClassCourseModel *)model;

@end

NS_ASSUME_NONNULL_END
