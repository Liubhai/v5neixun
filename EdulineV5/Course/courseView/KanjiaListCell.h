//
//  KanjiaListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/30.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KanjiaListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *groupFace;
@property (strong, nonatomic) UILabel *groupTitle;
@property (strong, nonatomic) UILabel *timeCountDownLabel;
@property (strong, nonatomic) UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
