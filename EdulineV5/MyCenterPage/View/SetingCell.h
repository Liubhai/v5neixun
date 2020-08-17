//
//  SetingCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SetingCellDelegate <NSObject>

@optional
- (void)switchClick:(UISwitch *)sender setInfo:(NSDictionary *)setInfo;

@end

@interface SetingCell : UITableViewCell

@property (weak, nonatomic) id<SetingCellDelegate> delegate;

@property (strong, nonatomic) UILabel *themeLabel;

@property (strong, nonatomic) UILabel *rightLabel;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *rightIcon;

@property (strong, nonatomic) UISwitch *switchOther;

@property (strong, nonatomic) NSDictionary *setInfo;

- (void)setSetingCellInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
