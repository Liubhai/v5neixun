//
//  EmptyCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/9/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyCell : UITableViewCell

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *emptyIconImage;
@property (strong, nonatomic) UILabel *emptyLabel;

@end

NS_ASSUME_NONNULL_END
