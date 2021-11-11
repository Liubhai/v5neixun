//
//  Dialogue.h
//  demo
//
//  Created by cc on 16/7/18.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCBaseViewController.h"

typedef NS_ENUM(NSInteger, DialogueType) {
    DialogueType_Text = 0,
    DialogueType_Pic = 1,
};

typedef void(^CalculateSizeBlock)(void);

@interface Dialogue : NSObject

@property (copy, nonatomic) NSString                        *userid;
@property (copy, nonatomic) NSString                        *username;
@property (copy, nonatomic) NSString                        *userrole;

@property (copy, nonatomic) NSString                        *fromuserid;
@property (copy, nonatomic) NSString                        *fromusername;
@property (copy, nonatomic) NSString                        *fromuserrole;

@property (copy, nonatomic) NSString                        *touserid;
@property (copy, nonatomic) NSString                        *tousername;

@property (copy, nonatomic) NSString                        *msg;
@property (copy, nonatomic) NSString                        *time;

@property (assign, nonatomic) CGSize                        msgSize;
@property (assign, nonatomic) CGSize                        userNameSize;

@property(assign,nonatomic)BOOL                             isNew;

@property(nonatomic,copy)NSString                           *head;
@property(nonatomic,copy)NSString                           *myViwerId;

@property(nonatomic,copy)NSString                           *useravatar;

@property(nonatomic,copy)NSString                           *encryptId;
@property(nonatomic,assign)NSContentType                    dataType;
@property(nonatomic,assign)DialogueType                      type;
@property(nonatomic,strong)NSDictionary                      *picInfo;

@property(nonatomic,strong)NSString                          *picUrl;
@property(nonatomic,assign)float                             picShowW;
@property(nonatomic,assign)float                             picShowH;
@property(nonatomic,assign)BOOL                             isPublish;
@property(nonatomic,assign)BOOL                             isPrivate;

@property(nonatomic, copy) NSString                    *chatId;
@property(nonatomic, copy) NSString                    *status;
@property(nonatomic, assign)CGFloat                     cellHeight;

@property(nonatomic, copy) CalculateSizeBlock block;

@property(nonatomic,strong)NSMutableAttributedString *showAttributedString;
- (void)calcMsgSize:(float)width font:(UIFont *)font block:(CalculateSizeBlock)block;
//为了适配web端对发送的内容里面的链接进行处理
+ (NSString *)addLinkTag:(NSString *)str;
//去除收到的消息里面的链接信息
+ (NSString *)removeLinkTag:(NSString *)str;
@end

