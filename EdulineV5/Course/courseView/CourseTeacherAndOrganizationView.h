//
//  CourseTeacherAndOrganizationView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CourseTeacherAndOrganizationViewDelegate <NSObject>

@optional
- (void)jumpToOrganization:(NSDictionary *)schoolInfo;

- (void)jumpToTeacher:(NSDictionary *)teacherInfoDict tapTag:(NSInteger)viewTag;

@end

@interface CourseTeacherAndOrganizationView : UIView

@property (assign, nonatomic) id<CourseTeacherAndOrganizationViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *teachersHeaderScrollView;
@property (strong, nonatomic) NSDictionary *schoolInfo;
@property (strong, nonatomic) NSArray *teacherInfoDict;

- (void)setTeacherAndOrganizationData:(NSDictionary *)schoolInfo teacherInfo:(NSArray *)teacherInfoDict;

@end

NS_ASSUME_NONNULL_END
