//
//  HomePageHotRecommendedCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPScrollerScaleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageHotRecommendedCell : UITableViewCell

@property (nonatomic, strong) ZPScrollerScaleView *scrollerView;

- (void)setRecommendCourseCellInfo:(NSArray *)recommendArray;

@end

NS_ASSUME_NONNULL_END
