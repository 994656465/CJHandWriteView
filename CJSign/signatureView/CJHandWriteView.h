//
//  CJHandWriteView.h
//  CJSign
//
//  Created by mac on 2020/6/22.
//  Copyright © 2020 SmartPig. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define LINEWIDTH  2
@protocol CJHandWriteViewDelegate <NSObject>
-(void)getSignatureImg:(UIImage*)image;
@end
@interface CJHandWriteView : UIView
{
    
    CGFloat min;
    
    CGFloat max;
    
    CGRect origRect;
    
    CGFloat origionX;
    
    CGFloat totalWidth;
    
    BOOL  isSure;
    
}

//签名完成后的水印文字
@property (nonatomic, strong)  NSMutableArray * pathPointArr;

@property (strong,nonatomic) NSString *showMessage;

@property(nonatomic,weak) id<CJHandWriteViewDelegate> delegate;
// 水印颜色 默认红色
@property (nonatomic, strong)  UIColor * watermarkColor;
// 线的颜色 默认黑色
@property (nonatomic, strong)  UIColor * lineColor;
@property (nonatomic, assign)  CGFloat watermarkFont;

- (void)clear;

- (void)sure;
@end

NS_ASSUME_NONNULL_END
