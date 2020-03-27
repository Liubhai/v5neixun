//
//  ShitikaCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShitikaCell;

@protocol ShitikaCellDelegate <NSObject>

@optional
- (void)usercardButton:(ShitikaCell *)cell;

@end

@interface ShitikaCell : UITableViewCell

@property (weak, nonatomic) id<ShitikaCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UILabel *kahaoLabel;
@property (strong, nonatomic) UIButton *userButton;

@end

NS_ASSUME_NONNULL_END
