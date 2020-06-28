//
//  ZiXunListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZiXunListCell : UITableViewCell

@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UIImageView *faceImageView;

@property (strong, nonatomic) UIImageView *lookCountImage;
@property (strong, nonatomic) UILabel *lookCountLabel;
@property (strong, nonatomic) UIView *fengeLine1;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *fengeLine2;


- (void)setZiXunInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
