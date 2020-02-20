//
//  MainViewController.m
//  StatisticDemo
//
//  Created by  GaoGao on 2020/2/12.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import "MainViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试标题";
    
    [self setupSubViews];
}
- (void)setupSubViews{
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 80)];
    [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 100, 80)];
    [btn2 setTitle:@"btn2" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 280, 100, 80)];
    [btn3 setTitle:@"btn3" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 addTarget:self action:@selector(action3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 380, 100, 80)];
    [btn4 setTitle:@"btn4" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor redColor];
    [btn4 addTarget:self action:@selector(action4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(100, 480, 100, 80)];
    [btn5 setTitle:@"btn5" forState:UIControlStateNormal];
    btn5.backgroundColor = [UIColor redColor];
    [btn5 addTarget:self action:@selector(action5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)action1{
    NSLog(@"mainViewController -- NSLog -- btn2 is clicked");
}

- (void)action2{
    OneViewController *one = [[OneViewController alloc] init];
    [self.navigationController pushViewController:one animated:NO];
}

-(void)action3:(UIButton *)but{
    TwoViewController *two = [[TwoViewController alloc]init];
    [self.navigationController pushViewController:two animated:YES];
}

-(void)action4{
    ThreeViewController *three = [[ThreeViewController alloc]init];
    [self.navigationController pushViewController:three animated:YES];
    
}


-(void)action5{
    
    FourViewController *four = [[FourViewController alloc]init];
    [self.navigationController pushViewController:four animated:YES];
    
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
