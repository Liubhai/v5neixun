//
//  ShopCarCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCarCell : UITableViewCell

@property (strong, nonatomic) UIButton *selectedIconBtn;
@property (strong,nonatomic) UIImageView *courseFaceImageView;
@property (strong,nonatomic) UILabel *themeLabel;
@property (strong,nonatomic) UILabel *courseHourLabel;
@property (strong,nonatomic) UILabel *priceLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) BOOL cellType;// 默认是结算页面cell 不然就是管理页面cell
@property (nonatomic, strong) NSIndexPath *cellIndex;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BOOL)cellType;

@end

NS_ASSUME_NONNULL_END
