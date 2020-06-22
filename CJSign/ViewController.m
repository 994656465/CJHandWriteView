//
//  ViewController.m
//  CJSign
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 SmartPig. All rights reserved.
//

#import "ViewController.h"
#import "CJHandSignViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 200, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonCLick) forControlEvents:UIControlEventTouchUpInside];
  
    [self.view addSubview:button];
}

-(void)buttonCLick{
    CJHandSignViewController * signvc = [[CJHandSignViewController alloc]init];
    signvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:signvc animated:YES completion:nil];
}
@end
