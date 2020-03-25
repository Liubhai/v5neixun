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

NS_ASSUME_NONNULL_BEGIN

@protocol CourseCatalogCellDelegate <NSObject>

@optional
- (void)listChangeUpAndDown:(UIButton *)sender listModel:(CourseListModelFinal *)model panrentListModel:(CourseListModelFinal *)panrentModel;

- (void)playCellVideo:(CourseListModelFinal *)model currentCellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex;

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
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIButton *courseRightBtn;
@property (strong, nonatomic) UIImageView *learnIcon;
@property (strong, nonatomic) UILabel *learnTimeLabel;
@property (strong, nonatomic) UIImageView *isLearningIcon;



@property (strong, nonatomic) UITableView *cellTableView;
@property (assign, nonatomic) BOOL isClassNew;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) NSInteger cellRow;
@property (assign, nonatomic) NSInteger cellSection;

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局) 自己属于第几层样式
@property (strong, nonatomic) NSString *allLayar;// 总共有几层
@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录
@property (strong, nonatomic) CourseListModel *listModel;
@property (strong, nonatomic) CourseListModelFinal *listFinalModel;//CourseListModelFinal

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow courselayer:(NSString *)courselayer isMainPage:(BOOL)isMainPage allLayar:(NSString *)allLayar;

- (void)setListInfo:(CourseListModelFinal *)model;

@end

NS_ASSUME_NONNULL_END
