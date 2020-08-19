//
//  RCSVoiceCell.m
//  rongcloud-ios-imdemo-voicetotext
//
//  Created by Jue on 2020/8/11.
//  Copyright © 2020 RC. All rights reserved.
//

#import "RCSVoiceCell.h"

@interface RCSVoiceCell ()

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *labelBackGroundView;

@end

static const NSInteger RCDLeftSpace = 56;
static const NSInteger RCDRightSpace = 51;
static const NSInteger RCDSpeechRecognizerTextFont = 14;
static const NSInteger RCDTextEdgeSpace = 5;

@implementation RCSVoiceCell
//设置 cell 的 size
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    CGFloat height = 0;
    //如果长按消息转文字后，mode.extra 会有内容，重新计算高度
    if (model.extra.length) {
        height = [self __getTextLabelSize:model.extra maxWidth:collectionViewWidth - RCDLeftSpace - RCDRightSpace].height + [[self class] __deviationWithModel:model];
    }
    return [super sizeForMessageModel:model withCollectionViewWidth:collectionViewWidth referenceExtraHeight:extraHeight + height];
}

#pragma mark - 重写 cell 渲染方法

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    //防止复用出问题，所以移除
    [self.label removeFromSuperview];
    [self.labelBackGroundView removeFromSuperview];
    
    NSString *extra = model.extra;
    CGRect rect = self.messageContentView.frame;
    
    //根据不同方向，判断转化后文字的位置
    if (model.messageDirection == MessageDirection_SEND) {
        rect = self.messageContentView.frame;
    } else {
        rect = self.bubbleBackgroundView.frame;
    }
    
    //获取文本的尺寸
    CGSize size = [[self class] __getTextLabelSize:extra maxWidth:[UIScreen mainScreen].bounds.size.width - RCDRightSpace - RCDLeftSpace];
    
    //根据 cell 是否显示时间决定 label 下移的比例
    NSInteger rate = 1;
    if (model.isDisplayMessageTime) {
        rate = 2;
    }
    CGRect labelRect = CGRectZero;
    
    //根据消息方向决定 label 尺寸
    if (model.messageDirection == MessageDirection_SEND) {
        labelRect = CGRectMake([UIScreen mainScreen].bounds.size.width - size.width - RCDRightSpace, rect.origin.y + rect.size.height * rate + [[self class] __deviationWithModel:model], size.width, size.height);
    } else {
        labelRect = CGRectMake(RCDLeftSpace, rect.origin.y + rect.size.height * rate + [[self class] __deviationWithModel:model], size.width, size.height);
    }
    if (extra.length) {
        self.label = [[UILabel alloc] initWithFrame:labelRect];
        self.label.numberOfLines = 0;
        self.label.text = extra;
        self.label.font = [UIFont systemFontOfSize:RCDSpeechRecognizerTextFont];
        [self.contentView addSubview:self.label];
        //给 label 添加背景图
        self.labelBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(labelRect.origin.x - RCDTextEdgeSpace, labelRect.origin.y - RCDTextEdgeSpace, labelRect.size.width + RCDTextEdgeSpace * 2, labelRect.size.height + RCDTextEdgeSpace * 2)];
        self.labelBackGroundView.layer.cornerRadius = 7;
        self.labelBackGroundView.center = self.label.center;
        [self.contentView addSubview:self.labelBackGroundView];
        [self.contentView bringSubviewToFront:self.label];
        [self __fitDarkMode];

    }
}

#pragma mark - private method 计算文本 size 的方法
+ (CGSize)__getTextLabelSize:(NSString *)content maxWidth:(CGFloat)maxWidth {
    if ([content length] > 0) {
        CGRect textRect = [content
                           boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:RCDSpeechRecognizerTextFont]}
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width, textRect.size.height);
    } else {
        return CGSizeZero;
    }
}

//label 偏差计算
+ (CGFloat)__deviationWithModel:(RCMessageModel *)model {
    CGFloat space = RCDTextEdgeSpace * 3;
    CGFloat deviation = space;
    if (model.isDisplayMessageTime) {
        deviation = space;
    }
    if (model.messageDirection == MessageDirection_RECEIVE) {
        deviation += space;
    }
    return deviation;
}

- (void)__fitDarkMode {
    if (@available(iOS 13.0, *)) {
        BOOL isDark = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
        UIColor *color = isDark ? [UIColor darkGrayColor] : [UIColor whiteColor];
        self.labelBackGroundView.backgroundColor = color;
    }
}

@end

