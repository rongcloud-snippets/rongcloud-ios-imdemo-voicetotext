//
//  RCSConversationViewController.m
//  RCSuppportDemo
//
//  Created by 张一帆 on 2020/6/15.
//  Copyright © 2020 RCSupport. All rights reserved.
//

#import "RCSConversationViewController.h"
#import "RCSVoiceCell.h"

@interface RCSConversationViewController ()
//长按消息时候，暂存消息数据的 model
@property (strong, nonatomic) RCMessageModel *longTouchModel;
//语音转换文字后得到的内容
@property (strong, nonatomic) NSMutableString *mutableResultString;

@end

@implementation RCSConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutableResultString = [NSMutableString new];
    
    //给语音消息绑定自定义 cell，用于展示语音转文字
    [self registerClass:[RCSVoiceCell class] forMessageClass:[RCVoiceMessage class]];
}

//长按消息的回调
- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model {
    NSMutableArray<UIMenuItem *> *menuList = [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    if ([model.content isKindOfClass:[RCVoiceMessage class]]) {
        UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转文字"
                                                             action:@selector(speechRecognizer)];
        self.longTouchModel = model;
        [menuList addObject:forwardItem];
    }
    return menuList;
}

- (void)speechRecognizer {
    if (self.longTouchModel) {
        [self.mutableResultString setString:@""];
        RCVoiceMessage *voiceMsg = (RCVoiceMessage *)self.longTouchModel.content;
        //将音频数据 voiceMsg.wavAudioData 传给语音识别的 SDK，进行识别
    }
}

//以科大讯飞 SDK 为例，假设这个方法是识别结果的代理方法，需要在该方法中拼接翻译好的字符串，并刷新 cell，展示翻译结果
- (void)onResults:(NSArray *) results isLast:(BOOL)isLast {
    NSDictionary *rootDic = [results objectAtIndex:0];
    NSString *firstKey = rootDic.allKeys.firstObject;
    NSDictionary *resultDic = [self _dictionaryWithJsonString:firstKey];
    NSArray *resultArray = resultDic[@"ws"];
    
    for (NSDictionary *dic in resultArray) {
        NSArray *cwArray = dic[@"cw"];
        for (NSDictionary *firstDic in cwArray) {
            NSString *wString = firstDic[@"w"];
            [self.mutableResultString appendString:wString];
        }
    }
    if (isLast) {
        self.longTouchModel.extra = self.mutableResultString;
        self.longTouchModel.cellSize = CGSizeZero;
        [self.conversationMessageCollectionView reloadData];
        RCMessageModel *model = [self.conversationDataRepository lastObject];
        if (model.messageId == self.longTouchModel.messageId ) {
            [self scrollToBottomAnimated:YES];
        }
    }
}

#pragma mark - private method

- (NSDictionary *)_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

@end
