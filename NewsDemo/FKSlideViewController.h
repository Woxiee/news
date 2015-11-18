//
//  QCSlideViewController.h
//  QCSliderTableView
//
//  Created by “  Faker on 15-11-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FKSlideSwitchView.h"
#import "FKListViewController.h"

@interface FKSlideViewController : UIViewController<FKSlideSwitchViewDelegate>
{
    FKSlideSwitchView *_slideSwitchView;
//    FKListViewController *_vc1;
//    FKListViewController *_vc2;
//    FKListViewController *_vc3;
//    FKListViewController *_vc4;
//    FKListViewController *_vc5;
//    FKListViewController *_vc6;
}

@property (nonatomic, strong)  FKSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) FKListViewController *vc1;
@property (nonatomic, strong) FKListViewController *vc2;
@property (nonatomic, strong) FKListViewController *vc3;
@property (nonatomic, strong) FKListViewController *vc4;
@property (nonatomic, strong) FKListViewController *vc5;
@property (nonatomic, strong) FKListViewController *vc6;
@property (nonatomic, strong) FKListViewController *vc7;
@property (nonatomic, strong) FKListViewController *vc8;
@property (nonatomic, strong) FKListViewController *vc9;

@end

