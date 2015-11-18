//
//  QCSlideViewController.m
//  QCSliderTableView
//
//  Created by “  Faker on 15-11-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "FKSlideViewController.h"
#import "FKListViewController.h"
#import "SelectTitleViewController.h"
@interface FKSlideViewController ()

@end

@implementation FKSlideViewController
{
    NSMutableArray *_resoureArray;
    NSMutableArray *_resoureVCArray;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)changeTopTitle
{

    for (int i = 0; i < _resoureArray.count; i++) {
        FKListViewController * VC = [[FKListViewController alloc] init];
        VC.view.tag = i;
        
        VC.title = [_resoureArray objectAtIndex:i];
        [_resoureVCArray addObject:VC];
    }
    [self.slideSwitchView buildUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"滑动切换视图";
    
    
    [self refreshUI];
    
    

    
    
    _resoureArray = [[NSMutableArray alloc] initWithObjects:@"十年",@"等你爱我",@"爱情转移",@"你的背包",@"lonely Christmas",@"钟无艳",@"明明就",@"你比从前快乐", nil];
    
    _resoureVCArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self changeTopTitle];

}

#pragma mark -选择标题
- (void)pushSelectTitleVC
{
    SelectTitleViewController *selectVC  = [[SelectTitleViewController alloc] init];
    selectVC.comeBackVaule = ^(NSMutableArray *array){
    
        NSLog(@"%@",array);
        if (_resoureVCArray.count >0) {
            [_resoureVCArray removeAllObjects];
        }
        _resoureArray =array;
        [self refreshUI];
        [self changeTopTitle];
    };
    [self presentViewController:selectVC animated:YES completion:nil];
    
}

- (void)refreshUI
{
//    if (self.slideSwitchView) {
        [self.slideSwitchView removeFromSuperview];
        self.slideSwitchView = nil;
    
        self.slideSwitchView = [[FKSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.frame.size.height)];
        self.slideSwitchView.slideSwitchViewDelegate = self;		
        self.slideSwitchView.tabItemNormalColor = [FKSlideSwitchView colorFromHexRGB:@"868686"];
        self.slideSwitchView.tabItemSelectedColor = [FKSlideSwitchView colorFromHexRGB:@"bb0b15"];
        self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                            stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
        [self.view addSubview:self.slideSwitchView];
        UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
        [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
        rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
        self.slideSwitchView.rigthSideButton = rightSideButton;
        
        [rightSideButton addTarget:self action:@selector(pushSelectTitleVC) forControlEvents:UIControlEventTouchUpInside];
//    }

    
    
}


#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(FKSlideSwitchView *)view
{
    return _resoureArray.count;
}

- (UIViewController *)slideSwitchView:(FKSlideSwitchView *)view viewOfTab:(NSUInteger)number
{

    NSLog(@"%ld",(unsigned long)number);

    FKListViewController  *vc = [_resoureVCArray objectAtIndex:number];
    NSString *tittle = [[_resoureVCArray objectAtIndex:number] title];
    

    if (  [tittle isEqualToString:@"十年"]) {
        self.vc1 = vc;
        self.vc1.title = tittle;
        return self.vc1;
    }
    else if ( [tittle isEqualToString:@"等你爱我"])
    {
        self.vc2 = vc;
        self.vc2.title = tittle;
        
        return self.vc2;
    }
    else if ( [tittle isEqualToString:@"爱情转移"])
    {
        self.vc3 = vc;
        self.vc3.title = tittle;
        return self.vc3;
    }
    else if ( [tittle isEqualToString:@"你的背包"])
    {
        self.vc4 = vc;
        self.vc4.title = tittle;
        
        return self.vc4;
    }
    else if ( [tittle isEqualToString:@"lonely Christmas"])
    {
        self.vc5 = vc;
        self.vc5.title = tittle;
        
        return self.vc5;
    }
    else if ( [tittle isEqualToString:@"钟无艳"])
    {
        self.vc6 = vc;
        self.vc6.title = tittle;
        
        return self.vc6;
    }
    else if  ([tittle isEqualToString:@"明明就"])
    {
        self.vc7 = vc;
        self.vc7.title = tittle;
        
        return self.vc7;
    }
    else if  ([tittle isEqualToString:@"你比从前快乐"])
    {
        self.vc8 = vc;
        self.vc8.title = tittle;
        
        return self.vc8;
    }

//        }
    
//        if (number == 0) {
//            return self.vc1;
//        } else if (number == 1) {
//            return self.vc2;
//        } else if (number == 2) {
//            return self.vc3;
//        } else if (number == 3) {
//            return self.vc4;
//        } else if (number == 4) {
//            return self.vc5;
//        } else if (number == 5) {
//            return self.vc6;
//        }
//        else if (number == 6) {
//            return self.vc7;
//        }
//        else {
//            return nil;
//        }


//    }
    
    return nil;
}



- (void)slideSwitchView:(FKSlideSwitchView *)view didselectTab:(NSUInteger)number
{
//    FKListViewController *vc = nil;
//    if (number == 0) {
//        vc = self.vc1;
//    } else if (number == 1) {
//        vc = self.vc2;
//    } else if (number == 2) {
//        vc = self.vc3;
//    } else if (number == 3) {
//        vc = self.vc4;
//    } else if (number == 4) {
//        vc = self.vc5;
//    } else if (number == 5) {
//        vc = self.vc6;
//    }
//    else if (number == 6) {
//        vc = self.vc7;
//    }
//    
//    self.title = vc.title;
////
//    for (FKListViewController *vc in _resoureVCArray) {
//        NSLog(@"%ld",(long)vc.view.tag);
//        NSLog(@"%@",[[_resoureVCArray objectAtIndex:number] title]);
//        
//        NSString *tittle = [[_resoureVCArray objectAtIndex:number] title];
//        NSLog(@"%ld",number);
//        //        @"芳芳同学好无聊",@"空城",@"奔跑吧兄弟",@"i want you",@"miss",@"独家记忆",@"我钟意你"
//        if (number == 0 && [tittle isEqualToString:@"芳芳同学好无聊"]) {
//            self.vc1 = vc;
//            self.vc1.title = tittle;
//        }
//        else if (number == 1 && [tittle isEqualToString:@"空城"])
//        {
//            self.vc2 = vc;
//            self.vc2.title = tittle;
//            
//        }
//        else if (number == 2 && [tittle isEqualToString:@"奔跑吧兄弟"])
//        {
//            self.vc3 = vc;
//            self.vc3.title = tittle;
//        }
//        else if (number == 3 && [tittle isEqualToString:@"i want you"])
//        {
//            self.vc4 = vc;
//            self.vc4.title = tittle;
//            
//        }
//        else if (number == 4 && [tittle isEqualToString:@"miss"])
//        {
//            self.vc5 = vc;
//            self.vc5.title = tittle;
//            
//        }
//        else if (number == 5 && [tittle isEqualToString:@"独家记忆"])
//        {
//            self.vc6 = vc;
//            self.vc6.title = tittle;
//            
//        }
//        else if (number == 6 && [tittle isEqualToString:@"我钟意你"])
//        {
//            self.vc7 = vc;
//            self.vc7.title = tittle;
//            
//        }

//    [vc viewDidCurrentView];
}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
