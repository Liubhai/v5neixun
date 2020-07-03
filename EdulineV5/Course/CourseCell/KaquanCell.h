//
//  KaquanCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@class KaquanCell;

@protocol KaquanCellDelegate <NSObject>

@optional
- (void)useOrGetAction:(KaquanCell *)cell;

@end

@interface KaquanCell : UITableViewCell

@property (weak, nonatomic) id<KaquanCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UILabel *fanweiLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) NSString *cellType;
@property (assign, nonatomic) BOOL getOrUse;
@property (strong, nonatomic) CouponModel *couponModel;
@property (strong, nonatomic) NSIndexPath *cellIndexpath;
@property (assign, nonatomic) BOOL useful;
@property (assign, nonatomic) BOOL isMyCouponsList;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(NSString *)cellType getOrUse:(BOOL)getOrUse useful:(BOOL)useful;

- (void)setCouponInfo:(CouponModel *)model cellIndexPath:(NSIndexPath *)cellIndexPath isMyCouponsList:(BOOL)isMyCouponsList;

@end

NS_ASSUME_NONNULL_END
