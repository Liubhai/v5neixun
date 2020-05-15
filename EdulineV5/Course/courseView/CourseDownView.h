//
//  CourseDownView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CourseDownView;

@protocol CourseDownViewDelegate <NSObject>

@optional

- (void)jumpServiceVC:(CourseDownView *)downView;
- (void)jumpToShopCarVC:(CourseDownView *)downView;
- (void)joinShopCarEvent:(CourseDownView *)downView;
- (void)joinStudyEvent:(CourseDownView *)downView;
- (void)jumpToCommentVC;

@end

@interface CourseDownView : UIView

@property (assign, nonatomic) id<CourseDownViewDelegate> delegate;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIButton *serviceButton;
@property (strong, nonatomic) UIButton *shopCarButton;
@property (strong, nonatomic) UILabel *shopCountLabel;
@property (strong, nonatomic) UIButton *joinShopCarButton;
@property (strong, nonatomic) UIButton *joinStudyButton;

@property (strong, nonatomic) UIButton *recordButton;

@property (assign, nonatomic) BOOL isRecord;// yes 播放详情页 底部 no 课程详情页底部

- (instancetype)initWithFrame:(CGRect)frame isRecord:(BOOL)isRecord;

- (void)setCOurseInfoData:(NSDictionary *)courseInfo;

@end

NS_ASSUME_NONNULL_END
