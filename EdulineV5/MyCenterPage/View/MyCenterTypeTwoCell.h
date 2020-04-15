//
//  MyCenterTypeTwoCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCenterTypeTwoCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIImageView *rightIcon;
@property (strong, nonatomic) UIView *lineView;

- (void)setMyCenterTypeTwoCellInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
