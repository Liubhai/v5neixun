//
//  SearchHistoryListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryListCell : UITableViewCell

@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setSearchHistoryListCellInfo:(NSDictionary *)info searchKeyWord:(NSString *)searchKeyWord;

@end

NS_ASSUME_NONNULL_END
