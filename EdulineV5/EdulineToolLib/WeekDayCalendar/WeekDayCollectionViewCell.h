//
//  WeekDayCollectionViewCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/15.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekDayCollectionViewCellDelegate <NSObject>

@optional
- (void)cellDayButtonClick:(NSIndexPath *_Nullable)cellIndexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WeekDayCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<WeekDayCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) UILabel *weekLabel;

@property (strong, nonatomic) UIButton *dayButton;

@property (strong, nonatomic) UIView *hasLiveView;

@property (strong, nonatomic) NSIndexPath *cellIndexpath;

- (void)setWeekCellDeatilInfo:(NSDate *)cellInfoDate hasWeekDayArray:(NSMutableArray *)yymmddwwArray isSelected:(BOOL)selected currentDay:(NSString *)currentday cellindexpath:(NSIndexPath *)cellindexpath hasScheduleArray:(NSMutableArray *)hasScheduleArray;

@end

NS_ASSUME_NONNULL_END
