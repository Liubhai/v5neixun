//
//  MyCenterTypeOneCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCenterTypeOneCellDelegate <NSObject>

@optional
- (void)jumpToOtherPage:(UIButton *)sender;

@end

@interface MyCenterTypeOneCell : UITableViewCell

@property (weak, nonatomic) id<MyCenterTypeOneCellDelegate> delegate;

@property (strong, nonatomic) UIView *cellView;

// 28 + 8 + 20 + 33 / 2.0
- (void)setMyCenterClassifyInfo:(NSMutableArray *)info;

- (void)setMyCenterClassifyInfoOnlyOne:(NSMutableArray *)info;

@end

NS_ASSUME_NONNULL_END
