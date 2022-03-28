//
//  NeixunMyCenterListView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/28.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NeixunMyCenterListViewDelegate <NSObject>

@optional
- (void)neixunJumpToOtherPage:(UIButton *)sender;

@end

@interface NeixunMyCenterListView : UIView

@property (weak, nonatomic) id<NeixunMyCenterListViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *listArray;

- (void)setListinfo:(NSMutableArray *)info;

@end

NS_ASSUME_NONNULL_END
