//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by “ Faker on 15-11-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "FKListViewController.h"

@interface FKListViewController ()

@end

@implementation FKListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"viewDidLoad title = %@",self.title);
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %ld ",self.title,(long)row];
    
    return  cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
