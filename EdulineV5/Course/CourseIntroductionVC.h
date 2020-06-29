//
//  CourseIntroductionVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMainViewController.h"
#import "V5_Constant.h"
#import "CourseDetailPlayVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseIntroductionVC : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) UILabel *introTitleL;
@property (strong ,nonatomic) WKWebView *ClassIntroWeb;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) CourseMainViewController *vc;
@property (strong, nonatomic) CourseDetailPlayVC *detailVC;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL isZhibo;

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong, nonatomic) NSString *courseId;

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight;

@end

NS_ASSUME_NONNULL_END
