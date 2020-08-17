//
//  BalanceDetailCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceDetailCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setInfoData:(NSDictionary *)infoData listType:(NSString *)listType;

@end

NS_ASSUME_NONNULL_END
