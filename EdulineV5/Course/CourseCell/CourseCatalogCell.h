//
//  CourseCatalogCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"
#import "CourseListModel.h"
#import "CourseListModelFinal.h"
#import "playAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@class CourseCatalogCell;

@protocol CourseCatalogCellDelegate <NSObject>

@optional
- (void)listChangeUpAndDown:(UIButton *)sender listModel:(CourseListModelFinal *)model panrentListModel:(CourseListModelFinal *)panrentModel;

- (void)playCellVideo:(CourseListModelFinal *)model currentCellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex currentCell:(CourseCatalogCell *)cell;

@end

@interface CourseCatalogCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource,CourseCatalogCellDelegate>

//@property (strong, nonatomic) UIView *blueView;
//@property (strong, nonatomic) UILabel *firstTitle;
//@property (strong, nonatomic) UIButton *firstRightBtn;
//@property (strong, nonatomic) UIView *firstLine;

//@property (strong, nonatomic) UILabel *secondTitle;
//@property (strong, nonatomic) UIButton *secondRightBtn;

@property (assign, nonatomic) id<CourseCatalogCellDelegate> delegate;

@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UIImageView *lockIcon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *freeImageView;// 免费图标
@property (strong, nonatomic) UILabel *priceLabel;// 价格
@property (strong, nonatomic) UIButton *courseRightBtn;// 展开收起按钮
@property (strong, nonatomic) UIButton *coverButton;//整个cell点击按钮
@property (strong, nonatomic) UIImageView *learnIcon;// 已完成学习的图标
@property (strong, nonatomic) UILabel *learnTimeLabel;// 学习记录时长
@property (strong, nonatomic) playAnimationView *isLearningIcon;// 正在学习的动画



@property (strong, nonatomic) UITableView *cellTableView;
@property (assign, nonatomic) BOOL isClassNew;
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
@property (assign, nonatomic) BOOL courseIsBuy;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow courselayer:(NSString *)courselayer isMainPage:(BOOL)isMainPage allLayar:(NSString *)allLayar isLive:(BOOL)isLive;

- (void)setListInfo:(CourseListModelFinal *)model;

@end

NS_ASSUME_NONNULL_END
