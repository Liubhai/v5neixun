//
//  MenberCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenberCell : UITableViewCell

@property (strong, nonatomic) UIImageView *selectImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *freeLabel;

- (void)setMemberInfo:(NSDictionary *)info indexpath:(NSIndexPath *)indexpath currentIndexpath:(NSIndexPath *)currentIndexpath;

@end

NS_ASSUME_NONNULL_END
