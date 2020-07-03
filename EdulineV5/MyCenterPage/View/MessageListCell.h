//
//  MessageListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : UITableViewCell<TYAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *userFace;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSDictionary *currentMessageInfo;

- (void)setMessageInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
