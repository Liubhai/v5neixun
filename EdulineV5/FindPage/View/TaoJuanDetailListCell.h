//
//  TaoJuanDetailListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaoJuanDetailListCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *learnProgress;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *learnCountLabel;
@property (strong, nonatomic) UIButton *examDoButton;
@property (strong, nonatomic) UIView *lineView;

- (void)setTaojuanDetailListCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
