//
//  ViewController.m
//  FGAutoScrollView
//
//  Created by wangguigui on 16/8/11.
//  Copyright © 2016年 topsci. All rights reserved.
//

#import "ViewController.h"
#import "FGCarouselView.h"

@interface ViewController ()<FGCarouselViewDelegate>
@property (nonatomic, strong) FGCarouselView * carView;
@property (nonatomic, strong) NSMutableArray * imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray array];
    for (int i = 1; i<9; i++) {
        [self.imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd.jpeg",i]]];
    }

    self.carView = [[FGCarouselView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 150)];
    self.carView.backgroundColor = [UIColor lightGrayColor];
    self.carView.imageArray = self.imageArray;
    self.carView.delegate = self;
    [self.view addSubview:self.carView];
}

-(void)clickImageAtIndex:(NSInteger)index
{
    NSLog(@"%@",self.imageArray[index]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
