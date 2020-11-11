//
//  LiveBoardToolView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LiveBoardToolViewDelegate <NSObject>

@optional
- (void)pressWhiteboardToolIndex:(NSInteger)index;

@end

@interface LiveBoardToolView : UIView

@property (assign, nonatomic) id<LiveBoardToolViewDelegate> delegate;

@property (strong, nonatomic) UIButton *toolSelectButton;
@property (strong, nonatomic) UIButton *toolPenButton;
@property (strong, nonatomic) UIButton *toolTextButton;
@property (strong, nonatomic) UIButton *toolEraserButton;
@property (strong, nonatomic) UIButton *toolColorButton;

@property (weak, nonatomic) UIButton *selectButton;

@end

NS_ASSUME_NONNULL_END
