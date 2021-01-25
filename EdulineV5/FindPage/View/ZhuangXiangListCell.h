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

@interface ZhuangXiangListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *jiantouImageView;
@property (strong, nonatomic) UIImageView *getOrFreeIamgeView;
@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *learnProgress;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIButton *getOrExamBtn;
@property (strong, nonatomic) UIButton *doExamButton;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) ZhuanXiangModel *treeItem;

- (void)updateItem;
- (void)setZhuangXiangCellInfo:(ZhuanXiangModel *)model;

@end

NS_ASSUME_NONNULL_END
