//
//  ASDFTextMaker.m
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFTextMaker.h"
#import <UIKit/UIKit.h>
#import "YYKit.h"

@interface ASDFTextMaker ()
{
    YYTextContainer *container;
    YYTextLayout *layout;
}
@end

@implementation ASDFTextMaker

+ (NSMutableAttributedString*)makeText {
    return [self makeTextWithNick:@"昵称:" message:@"你好呀~" link:@"https://www.baidu.com"];
}

+ (NSMutableAttributedString*)makeTextWithNick:(NSString*)name message:(NSString*)message link:(NSString*)link
{
    NSMutableAttributedString *mutText = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *nameMutText = [self makeName:name];
    NSMutableAttributedString *messMutText = [self makeMessage:message];
    NSMutableAttributedString *linkMutText = [self makeLink:link];
    NSMutableAttributedString *iconMutText1 = [self makeIcon];
    NSMutableAttributedString *iconMutText2 = [self makeIcon];
    NSMutableAttributedString *iconMutText3 = [self makeIcon];
    
    [mutText appendAttributedString:iconMutText1];
    [mutText appendAttributedString:nameMutText];
    [mutText appendAttributedString:messMutText];
    [mutText appendAttributedString:linkMutText];
    [mutText appendAttributedString:iconMutText2];
    [mutText appendAttributedString:iconMutText3];
    
    //设置换行截断模式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setAlignment:NSTextAlignmentLeft];
    [mutText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutText.length)];
    
    return mutText;
}

+ (NSMutableAttributedString*)makeName:(NSString*)name
{
    NSMutableAttributedString *mutText = [[NSMutableAttributedString alloc] initWithString:[name copy]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = UIColor.whiteColor;
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(1, 5);
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 2.5f;
    NSRange range = NSMakeRange(0, name.length);
    [mutText addAttribute:NSShadowAttributeName value: shadow range: range];
    [mutText setAttributes:dic range:range];
    
    [mutText setTextHighlightRange:range
                             color:[UIColor purpleColor]
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView * containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             NSLog(@"++tap on Name:%@",[text.string substringWithRange:range]);
    }];
    return mutText;
}


+ (NSMutableAttributedString*)makeMessage:(NSString*)message
{
    NSMutableAttributedString *mutText = [[NSMutableAttributedString alloc] initWithString:[message copy]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = UIColor.cyanColor;
    
    [mutText setAttributes:dic range:NSMakeRange(0, message.length)];
    
    return mutText;
}

+ (NSMutableAttributedString*)makeLink:(NSString*)link
{
    NSMutableAttributedString *mutText = [[NSMutableAttributedString alloc] initWithString:link];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = UIColor.whiteColor;
    dic[NSUnderlineColorAttributeName] = UIColor.blueColor;
    dic[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    
    NSRange range = NSMakeRange(0, link.length);
    [mutText setAttributes:dic range:range];
    
    //设置点击回调
    [mutText setTextHighlightRange:range
                             color:[UIColor blueColor]
                   backgroundColor:[UIColor greenColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             NSLog(@"++tap on link:%@",[text.string substringWithRange:range]);
                         }];
    
    return mutText;
}


+ (NSMutableAttributedString*)makeIcon
{
    YYImage *yyImg = [YYImage imageNamed:@"logo"];
    yyImg.preloadAllAnimatedImageFrames = YES;
    YYAnimatedImageView *imView = [[YYAnimatedImageView alloc] initWithImage:yyImg];
    imView.frame = CGRectMake(0, 0, 20, 20);
    imView.clipsToBounds = YES;
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imView
                                                                                       contentMode:UIViewContentModeScaleAspectFit
                                                                                    attachmentSize:imView.frame.size
                                                                                       alignToFont:[UIFont systemFontOfSize:16]
                                                                                         alignment:YYTextVerticalAlignmentCenter];
    return attachText;
}

@end
