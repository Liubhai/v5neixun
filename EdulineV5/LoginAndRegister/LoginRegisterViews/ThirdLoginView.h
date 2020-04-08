//
//  ThirdLoginView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/5.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ThirdLoginViewDelegate <NSObject>

@optional
- (void)loginButtonClickKKK:(UIButton *)sender;

@end

@interface ThirdLoginView : UIView

@property (weak, nonatomic) id<ThirdLoginViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *methodArray;


@end

NS_ASSUME_NONNULL_END
