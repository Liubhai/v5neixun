//
//  NewStudyRecentView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewStudyRecentView : UIView

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) NSMutableArray *userLearnCourseArray;

@end

NS_ASSUME_NONNULL_END
