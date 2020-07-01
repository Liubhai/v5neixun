//
//  MyMenberCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyMenberCell : UITableViewCell

@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIButton *statusButton;
@property (strong, nonatomic) UILabel *scoreCountLabel;
@property (strong, nonatomic) UILabel *scoreFromLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setMenberInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
