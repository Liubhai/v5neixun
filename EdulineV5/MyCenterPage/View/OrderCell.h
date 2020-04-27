//
//  OrderCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCell : UITableViewCell

@property (strong, nonatomic) UIImageView *backIamgeView;

@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UILabel *orderTitle;
@property (strong, nonatomic) UILabel *orderNum;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *theme;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *dateLine;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *trueLabel;
@property (strong, nonatomic) UILabel *truePriceLabel;

@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;

- (void)setOrderInfo:(NSDictionary *)orderInfo;

@end

NS_ASSUME_NONNULL_END
