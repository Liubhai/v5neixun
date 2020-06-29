//
//  ShopCarCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@class ShopCarCell;

@protocol ShopCarCellDelegate <NSObject>

@optional
- (void)chooseWhichCourse:(ShopCarCell *)shopCarCell;

@end

@interface ShopCarCell : UITableViewCell

@property (weak, nonatomic) id<ShopCarCellDelegate> delegate;

@property (strong, nonatomic) UIButton *selectedIconBtn;
@property (strong,nonatomic) UIImageView *courseFaceImageView;
@property (strong,nonatomic) UIImageView *courseTypeImageView;
@property (strong,nonatomic) TYAttributedLabel *themeLabel;
@property (strong,nonatomic) UIImageView *course_card;
@property (strong,nonatomic) UILabel *courseHourLabel;
@property (strong,nonatomic) UILabel *priceLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UIImageView *hasCourseCardImageView;
@property (assign, nonatomic) BOOL cellType;// 默认是结算页面cell 不然就是管理页面cell
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (strong, nonatomic) ShopCarCourseModel *courseModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType;
- (void)setShopCarCourseInfo:(ShopCarCourseModel *)model cellIndexPath:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
