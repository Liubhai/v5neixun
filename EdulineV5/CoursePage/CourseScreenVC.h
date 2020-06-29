//
//  CourseScreenVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CourseScreenVCDelegate <NSObject>

@optional
- (void)cleanChooseScreen:(NSDictionary *)info;
- (void)sureChooseScreen:(NSDictionary *)info;

@end

@interface CourseScreenVC : BaseViewController

@property (weak, nonatomic) id<CourseScreenVCDelegate> delegate;

@property (assign, nonatomic) BOOL isMainPage;// 是不是课程主页
@property (strong, nonatomic) NSString *screenId;// 当前选中的类型

@property (assign, nonatomic) NSString *upAndDown;

@property (assign, nonatomic) NSString *priceMin;
@property (assign, nonatomic) NSString *priceMax;
@property (assign, nonatomic) NSString *screenType;;

@end

NS_ASSUME_NONNULL_END
