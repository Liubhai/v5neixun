//
//  KaquanCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KaquanCell : UITableViewCell

@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UILabel *fanweiLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) NSString *cellType;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(NSString *)cellType;

@end

NS_ASSUME_NONNULL_END
