//
//  SelectTitleViewController.m
//  NewsDemo
//
//  Created by Faker on 15/11/16.
//  Copyright © 2015年 Faker. All rights reserved.
//

#import "SelectTitleViewController.h"

// 程序可用的rect
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface SelectTitleViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectTitleViewController
{
    UITableView *theTabelView;
     NSMutableArray *_selectedPersonArray;
    NSInteger _selectPersonNumbers;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _selectedPersonArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self setNavigationBar];
    [self setMeunView];
    [self setTabelView];
}

- (void)setNavigationBar
{
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    [self.view addSubview:navigationBar];
    
    
    UIButton *dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissBtn.frame = CGRectMake(15, 10, 60, 60);
    [dissBtn setTitle:@"返回" forState:UIControlStateNormal];
    [dissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dissBtn addTarget:self action:@selector(dissmissTheVC) forControlEvents:UIControlEventTouchDragInside];
    [navigationBar addSubview:dissBtn];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = @"选择标题";
    title.textAlignment = NSTextAlignmentCenter;
    title.center = navigationBar.center;
    title.textColor = [UIColor blackColor];
    [navigationBar addSubview:title];

}


- (void)setMeunView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 65,self.view.frame.size.width , self.view.frame.size.height * 0.3)];
    view.backgroundColor = [UIColor colorWithRed:0.996 green:0.988 blue:0.898 alpha:1.000];
    [self.view addSubview:view];
    
    self.menuview = [[OldJqMenuView alloc] initWithFrame:view.bounds];
    self.menuview.menuDelegate = self;
    _menuview.enableMultiply = NO;
    _menuview.showsVerticalScrollIndicator = NO;
    _menuview.showsHorizontalScrollIndicator=YES;
    _menuview.pagingEnabled = YES;
    [_menuview layoutRow:2 column:4];
    
    [_menuview setElementWidth:70 height:48];
    [_menuview bringSubviewToFront:self.view];
    [view addSubview:_menuview];
    
    if (_selectedPersonArray.count >0) {
        _selectPersonNumbers = _selectedPersonArray.count - 1;
        for (int i = 0; i< _selectedPersonArray.count; i++) {
            [_menuview addMenuForIndex:i icon:@"searchButton" title:[_selectedPersonArray objectAtIndex:i] badge:0 active:NO selects:NO];
        }
    }else{
        _selectPersonNumbers = -1;
        
    }

    
}

- (void)setTabelView
{
    theTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65 + self.view.frame.size.height * 0.3 + 1, self.view.frame.size.width, self.view.frame.size.height * 0.7 - 67) style:UITableViewStylePlain];
    theTabelView.delegate = self;
    theTabelView.dataSource = self;
    theTabelView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:theTabelView];
}


#pragma mark - resoureArray 懒加载
- (NSMutableArray *)resoureArray
{
    if (!_resoureArray ) {
        _resoureArray = [[NSMutableArray alloc] initWithObjects:@"十年",@"等你爱我",@"爱情转移",@"你的背包",@"lonely Christmas",@"钟无艳",@"明明就",@"你比从前快乐", nil];
    }

    return _resoureArray;
}


- (void)dissmissTheVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.comeBackVaule(_selectedPersonArray);
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arry = [self resoureArray];
    return arry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"ListViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    NSMutableArray *arry = [self resoureArray];
    cell.textLabel.text = [arry objectAtIndex:indexPath.row];
    
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arry = [self resoureArray];
    NSString *str = [arry objectAtIndex:indexPath.row];
    [self addSomebodyToSelected:str];
}



#pragma mark - jqmeunDelegate
-(void)resetSelectedArea{
    for (UIView *view in [_menuview subviews]) {
        if ([view isKindOfClass:[_menuview class]]) {
            ((OldMenuModel*)view).isActive=NO;
        }
    }
}


- (void)addSomebodyToSelected:(NSString *)str
{
    if (str== nil) {
        return;
    }
    if (![_selectedPersonArray containsObject:str]) {
        
        if (_selectedPersonArray.count == 0) {
            [_selectedPersonArray addObject:str];
            [_appeoplearyArray addObject: str];
            [self menuviewinit:_selectedPersonArray];
            
            return;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for ( int i = 0; i < _selectedPersonArray.count; i++) {
            [array addObject:[NSString  stringWithFormat:@"%@",[_selectedPersonArray objectAtIndex:i]]];
        }
        
        if (![array containsObject:[NSString stringWithFormat:@"%@",str]]) {
            [_selectedPersonArray addObject:str];
            [_appeoplearyArray addObject:str];
            [self menuviewinit:_selectedPersonArray];
        }
        
    }
}



-(void)menuviewinit:(NSMutableArray *)peopleary
{
    _selectPersonNumbers++;
    [_menuview addMenuForIndex:_selectPersonNumbers icon:@"searchButton" title:peopleary.lastObject badge:0 active:NO selects:NO];
    
    if (_selectedPersonArray.count == 9) {
        [_menuview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    
    if (_selectedPersonArray.count == 17) {
        [_menuview setContentOffset:CGPointMake(2*SCREEN_WIDTH, 0) animated:YES];
    }
    
}

-(void)menuView:(OldMenuModel*)view deleteMenuAtIndex:(NSInteger)index title:(NSString*)theTitle
{

    for (int i = 0; i <_selectedPersonArray.count; i ++) {
        if ([[_selectedPersonArray objectAtIndex:i] isEqualToString:theTitle]) {
            [_selectedPersonArray removeObjectAtIndex:i];
            [_appeoplearyArray removeObjectAtIndex:i];
            break;
        }
    }
    _selectPersonNumbers = _selectedPersonArray.count - 1;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
