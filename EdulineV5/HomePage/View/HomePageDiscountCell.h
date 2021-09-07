//
//  HomePageDiscountCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/7.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageDiscountCellDelegate <NSObject>

@optional
- (void)goToDiscountCourseMainPage:(NSDictionary *)courseInfo;

@end

@interface HomePageDiscountCell : UITableViewCell

@property (weak, nonatomic) id<HomePageDiscountCellDelegate> delegate;

@property (strong, nonatomic) UIScrollView *discountScrollView;
@property (strong, nonatomic) NSMutableArray *discountInfoArray;

- (void)setDiscountArrayInfo:(NSMutableArray *)infoArray;

@end

NS_ASSUME_NONNULL_END
