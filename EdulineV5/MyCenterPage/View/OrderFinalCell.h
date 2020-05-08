//
//  OrderFinalCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderFinalCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *theme;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *dateLine;

- (void)setOrderFinalInfo:(NSDictionary *)OrderFinalInfo;

@end

NS_ASSUME_NONNULL_END
