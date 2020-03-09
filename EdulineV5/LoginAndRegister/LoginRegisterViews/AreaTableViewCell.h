//
//  AreaTableViewCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) UILabel *line;

- (void)setAreaInfo:(NSArray *)info;

@end

NS_ASSUME_NONNULL_END
