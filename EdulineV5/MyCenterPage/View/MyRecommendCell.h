//
//  MyRecommendCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRecommendCell : UITableViewCell

@property (strong, nonatomic) UILabel *typeTitle;
@property (strong, nonatomic) UIImageView *rightIcon;
@property (strong, nonatomic) UIView *lineView;

- (void)setInfo:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
