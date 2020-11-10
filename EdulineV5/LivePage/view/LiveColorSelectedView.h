//
//  LiveColorSelectedView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LiveColorSelectedViewDelegate <NSObject>

@optional
- (void)colorBtnClick:(UIButton *)sender selectColor:(NSString *)colorString;

@end

@interface LiveColorSelectedView : UIView

@property (assign, nonatomic) id<LiveColorSelectedViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *colorArray;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *colorBackView;


@end

NS_ASSUME_NONNULL_END
