//
//  LivePageControlView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LivePageControlViewDelegate <NSObject>

@optional
- (void)previousPagePress;
- (void)nextPagePress;
- (void)lastPagePress;
- (void)firstPagePress;

@end

@interface LivePageControlView : UIView

@property (assign, nonatomic) id<LivePageControlViewDelegate> delegate;

@property (strong, nonatomic) UIButton *previousPageButton;
@property (strong, nonatomic) UIButton *nextPageButton;
@property (strong, nonatomic) UIButton *lastPageButton;
@property (strong, nonatomic) UIButton *firstPageButton;
@property (strong, nonatomic) UILabel *pageCountLabel;

@end

NS_ASSUME_NONNULL_END
