//
//  QCListViewController.h
//  QCSliderTableView
//
//  Created by “  Faker on 15-11-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FKListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableViewList;
}

@property (nonatomic, strong) IBOutlet UITableView *tableViewList;

- (void)viewDidCurrentView;

@end

