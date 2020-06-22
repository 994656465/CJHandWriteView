//
//  CJHandSignViewController.m
//  CJSign
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 SmartPig. All rights reserved.
//

#import "CJHandSignViewController.h"
#import <Masonry.h>
#import "UIView+Toast.h"
#import "CJHandWriteView.h"

#define kUIScreenWidth       [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeigth      [UIScreen mainScreen].bounds.size.height
@interface CJHandSignViewController ()<CJHandWriteViewDelegate>
{
    
    UIImage *saveImage;
    
    UIView *saveView;
    void(^_block)(UIImage * image);
}
@property (strong,nonatomic) CJHandWriteView *signatureView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation CJHandSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor lightGrayColor];
    [self orientationChange:YES];

    [self   creatUI];
}
//  MARK:view

-(void)creatUI{
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(0);
       make.left.mas_equalTo(0);
       make.right.mas_equalTo(0);
       make.height.mas_equalTo(64);
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text =@"请清晰签写您的姓名";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(titleView.mas_width);
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.height.mas_equalTo(44);
    }];
    
    UIButton * backBtn = [UIButton buttonWithType:0];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"offer_icon_back"] forState:UIControlStateNormal];
    [titleView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"清楚签名" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   cancelBtn.backgroundColor = [UIColor whiteColor];

    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
 cancelBtn.layer.cornerRadius = 4;
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.borderColor = [UIColor grayColor].CGColor;
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(210);
        make.right.mas_equalTo(self.view.mas_centerX).offset(-16);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-11.5);
    }];
    
    UIButton * doneBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.backgroundColor = [UIColor whiteColor];
    [doneBtn setTitle:@"确认签署"  forState:UIControlStateNormal];
       [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
       doneBtn.clipsToBounds = YES;
       doneBtn.layer.borderColor = [UIColor grayColor].CGColor;
       doneBtn.layer.borderWidth = 1;
    doneBtn.layer.cornerRadius = 4;
    doneBtn.clipsToBounds = YES;
    doneBtn.tag = 0;
    [doneBtn addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cancelBtn.mas_height);
        make.width.mas_equalTo(cancelBtn.mas_width);
        make.left.mas_equalTo(self.view.mas_centerX).offset(16);
        make.bottom.mas_equalTo(cancelBtn.mas_bottom);
    }];
    
     self.signatureView = [[CJHandWriteView alloc] init];
    
    self.signatureView.backgroundColor = [UIColor lightGrayColor];
    
    self.signatureView.delegate =self;
    
    self.signatureView.showMessage =@"我是水印";

    [self.view addSubview:self.signatureView];
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(titleView.mas_bottom);
        make.bottom.mas_equalTo(cancelBtn.mas_top);
        
    }];
}
- (void)orientationChange:(BOOL)landscapeRight
{
    if (landscapeRight) {
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.view.bounds = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth);
    } else {
        self.view.transform = CGAffineTransformMakeRotation(0);
        self.view.bounds = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth);
    }
}
//  MARK:click
-(void)cancelButtonClick{
    [self.signatureView clear];
}
-(void)doneButtonClick{
    
   [self.signatureView sure];
    
    if (_image ) {
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    NSString * filePath = [self writeImageToLocalWithImage:_image];
        NSLog(@"%@",filePath);
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self.view makeToast:@"签名内容不能为空！" duration:1.0 position:CSToastPositionCenter];

    }

}


-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)clickSureSignImageBack:(void (^)(UIImage *))block{
    _block = block;
}
-(void)getSignatureImg:(UIImage*)image

{
    if(image)
        
    {
        _image = image;
        
    }
 
}

-(NSString * )writeImageToLocalWithImage:(UIImage *)image{
       NSString *fileName = [NSString stringWithFormat:@"%.00f.jpg",[NSDate timeIntervalSinceReferenceDate]];
       NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
           UIGraphicsEndImageContext();
           NSData *imageData = UIImageJPEGRepresentation(image, 1);
           if (imageData.length > 1048576) {
               imageData = UIImageJPEGRepresentation(image, 0.5);
           }
           [imageData writeToFile:tempFilePath atomically:YES];
    NSLog(@"%@",tempFilePath);
        return   tempFilePath;
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
