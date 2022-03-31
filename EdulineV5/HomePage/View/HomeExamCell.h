//
//  HomeExamCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/28.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeExamCellDelegate <NSObject>

@optional
- (void)doExamOrLookExamResult:(NSDictionary *)examInfo;

@end

@interface HomeExamCell : UITableViewCell

@property (strong, nonatomic) id<HomeExamCellDelegate> delegate;
@property (strong, nonatomic) UIView *whiteBackView;
@property (strong, nonatomic) UIImageView *examStatusImageView;
@property (strong, nonatomic) UILabel *examTitle;
@property (strong, nonatomic) UIButton *examButton;
@property (strong, nonatomic) UIView *fenggeLineView;
@property (strong, nonatomic) UILabel *examCountLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *examMenberNumLabel;
@property (strong, nonatomic) NSDictionary *homeExamInfo;

- (void)setHomeExamListInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
