//
//  ZhuangXiangListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanXiangModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ZhuangXiangListCell;

@protocol ZhuangXiangListCellDelegate <NSObject>

@optional
- (void)userBuyOrExam:(ZhuangXiangListCell *)cell;
- (void)userExamBy:(ZhuangXiangListCell *)cell;

@end

@interface ZhuangXiangListCell : UITableViewCell

@property (assign, nonatomic) id<ZhuangXiangListCellDelegate> delegate;

@property (strong, nonatomic) UIView *grayLineTop;
@property (strong, nonatomic) UIView *grayLineCenter;
@property (strong, nonatomic) UIImageView *jiantouImageView;
@property (strong, nonatomic) UIView *grayLine;
@property (strong, nonatomic) UIImageView *getOrFreeIamgeView;
@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *learnProgress;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *rightRateLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIButton *getOrExamBtn;
@property (strong, nonatomic) UIButton *doExamButton;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) ZhuanXiangModel *treeItem;

- (void)updateItem;
- (void)setZhuangXiangCellInfo:(ZhuanXiangModel *)model cellIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
