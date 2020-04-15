//
//  MyCenterTypeOneCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/15.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCenterTypeOneCell : UITableViewCell

@property (strong, nonatomic) UIView *cellView;

// 28 + 8 + 20 + 33 / 2.0
- (void)setMyCenterClassifyInfo:(NSMutableArray *)info;

@end

NS_ASSUME_NONNULL_END
