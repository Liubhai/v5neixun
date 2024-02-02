//
//  WeekDayPublicView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/15.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

@protocol WeekDayPublicViewDelegate <NSObject>

@optional
- (void)selectedDay:(NSArray *_Nullable)yymmddwwArray;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WeekDayPublicView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<WeekDayPublicViewDelegate> delegate;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *nsdateArray;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *hasClassScheduleArray;

- (void)reloadDataHasClassScheculeList:(NSMutableArray *)array;
- (void)fastReturnToToday;

@end

NS_ASSUME_NONNULL_END
