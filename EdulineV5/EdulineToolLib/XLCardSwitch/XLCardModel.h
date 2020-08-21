//
//  CardModel.h
//  CardSwitchDemo
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCardModel : NSObject


//"course_type" = 1;
//"course_type_text" = "\U70b9\U64ad";
//cover = 784;
//"cover_url" = "http://v5.51eduline.com/storage/upload/20200715/012a56b8785d0f8a0d0f75d24420cfe1.png";
//id = 13;
//price = 100;
//"sale_count" = 24;
//title = "\U4e8c\U7ea7\U76ee\U5f55\U6d4b\U8bd5\U8bfe\U7a0b";
//"user_price" = 100;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (copy, nonatomic) NSString *course_type;
@property (copy, nonatomic) NSString *course_type_text;
@property (copy, nonatomic) NSString *course_id;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *sale_count;
@property (copy, nonatomic) NSString *user_price;


@end
