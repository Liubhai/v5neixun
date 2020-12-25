//
//  SpecialExamListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SpecialExamListCell;

@protocol SpecialExamListCellDelegate <NSObject>

@optional
- (void)getOrExamButtonWith:(SpecialExamListCell *)cell;

@end

@interface SpecialExamListCell : UITableViewCell

@property (assign, nonatomic) id<SpecialExamListCellDelegate> delegate;

@property (strong, nonatomic) UIView *whiteBack;
@property (strong, nonatomic) UIImageView *gotImage;
@property (strong, nonatomic) UILabel *examTitle;
@property (strong, nonatomic) UILabel *examCount;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIButton *getOrExamBtn;


@end

NS_ASSUME_NONNULL_END
