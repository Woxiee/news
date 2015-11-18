//
//  SelectTitleViewController.h
//  NewsDemo
//
//  Created by Faker on 15/11/16.
//  Copyright © 2015年 Faker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OldJqMenuView.h"

typedef void(^ComeBackVauleBlock)(NSMutableArray *array);

@interface SelectTitleViewController : UIViewController<jqMenuViewDelegate>

@property (nonatomic,strong) NSMutableArray *resoureArray;

@property (nonatomic, copy)  ComeBackVauleBlock comeBackVaule;

/**
 选择菜单
 */
@property (nonatomic, strong) OldJqMenuView *menuview;

@property (nonatomic ,strong) NSMutableArray * appeoplearyArray;

@end
