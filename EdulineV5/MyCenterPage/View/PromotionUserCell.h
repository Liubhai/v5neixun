//
//  PromotionUserCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionUserCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *promotionIncome;
@property (strong, nonatomic) UIView *lineView;

- (void)setPromotionUserCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
