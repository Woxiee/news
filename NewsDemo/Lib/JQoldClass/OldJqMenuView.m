//
//  MenuView.m
//  CaiDan
//
//  Created by  on 12-9-9.
//  Copyright (c) 2012年 JianQiao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OldJqMenuView.h"
#import "OldMenuModel.h"

#define ANGLE M_PI*2.5/180.0

@interface OldJqMenuView(){
    CGPoint loc0;
    CGPoint previous;
    NSInteger current;
    OldMenuModel* currentMenu;

    UITapGestureRecognizer* tap;
    OldMenuModel* multiplicationMenu;
    
    
}
-(void)handleLongPress:(UILongPressGestureRecognizer*)gesture;
-(void)handleTap:(UITapGestureRecognizer*)gesture;
-(void)sortAllMenu;
-(void)resetSerielAfterMoveMenu:(OldMenuModel *)menu;
-(void)resetSerielAfterDeleteMenu:(NSInteger)seriel;
-(void)resetSerielAfterInsertMenu:(NSInteger)seriel;
-(NSUInteger)areaContainsPoint:(CGPoint)loc;
int ceilingf(float f);
-(void)addTapGesture;
-(NSUInteger)fetchTotalNum;
-(void)awakenMultiplication:(NSInteger)fromIndex;

@end


@implementation OldJqMenuView
@synthesize enableEdit,enableMultiply;
@synthesize menuDelegate;
-(void)initialize{
    enableEdit=YES;
    enableMultiply=YES;
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
}
-(id)init{
    self=[super init];
    if (self) {
        [self initialize];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)layoutRow:(NSUInteger)rowNum column:(NSUInteger)columnNum{
    row=rowNum;
    column=columnNum;
    
}
-(void)setElementWidth:(CGFloat)w height:(CGFloat)h{
    elementWidth=w;
    elementHeight=h;
}
-(NSUInteger)fetchTotalNum{
    NSUInteger ret=0;
    for (UIView* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            ret++;
        }
    }
    return ret;
}
-(CGPoint)getMenuCenter:(int)count{
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    CGFloat xval=(count%column*w+w/2.0)/column+w*(ceilingf((count+1.0)/(column*row))-1);
    CGFloat yval=((int)(count%(row*column)/column)*h+h/2.0)/row;
    return CGPointMake(xval, yval+5);
}
-(void)setPropertyForMenu:(OldMenuModel*)aMenu withIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name mark:(NSString *)mark badge:(NSInteger)badge active:(BOOL)yesOrNo selects:(BOOL)selc{
    aMenu.seriel=index;
    aMenu.frame=CGRectMake(0, 5, elementWidth, elementHeight);
    aMenu.center=[self getMenuCenter:index]; 
    aMenu.icon=iconName;
    aMenu.title=name;
    aMenu.mark=mark;
    aMenu.badge=badge;
    aMenu.isActive=yesOrNo;
    aMenu.delegate=self;
    aMenu.selects = selc;
    if (enableEdit) {
        UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        longPress.delegate=self;
        [aMenu addGestureRecognizer:longPress];
        [longPress release];
    }
}

-(void)addMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name mark:(NSString*)mark{
    OldMenuModel* menu=[[OldMenuModel alloc] init];
    [self setPropertyForMenu:menu withIndex:index icon:iconName title:name mark:mark badge:0 active:NO selects:YES];
    
    [self addSubview:menu];
    [menu release];
}
-(void)addMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name badge:(NSInteger)badge active:(BOOL)yesOrNo selects:(BOOL)selc{
    
    OldMenuModel* menu=[[OldMenuModel alloc]init];
    [self setPropertyForMenu:menu withIndex:index icon:iconName title:name mark:nil badge:badge active:yesOrNo selects:selc];
    
    [self addSubview:menu];
    [menu release];
}
-(void)insertMenuForIndex:(NSInteger)index icon:(NSString *)iconName title:(NSString *)name badge:(NSInteger)badge active:(BOOL)yesOrNo selects:(BOOL)selc{
    [self resetSerielAfterInsertMenu:index];
    [self sortAllMenu];
    [self addMenuForIndex:index icon:iconName title:name badge:badge active:yesOrNo selects:selc];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollEnabled=YES;
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    NSUInteger total=[self fetchTotalNum];
    self.contentSize=CGSizeMake(w*(ceilingf(1.0*total/(row*column))), h);
}
-(void)resetSerielAfterDeleteMenu:(NSInteger)seriel{
    for (UIView*v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            if (((OldMenuModel*)v).seriel>seriel) {
                ((OldMenuModel*)v).seriel--;
            }
        }
    }
}
-(void)resetSerielAfterInsertMenu:(NSInteger)seriel{
    for (UIView*v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            if (((OldMenuModel*)v).seriel>=seriel) {
                ((OldMenuModel*)v).seriel++;
            }
        }
    }
}
-(void)deletemenutoindex:(NSInteger)index
{
    [self resetSerielAfterDeleteMenu:index];
    [self sortAllMenu];

}
-(BOOL)deleteMenuForIndex:(NSInteger)index title:(NSString *)menuTitle{

    if ([menuDelegate respondsToSelector:@selector(menuView:shouldDeleteMenuForIndex:title:)]) {
        BOOL shouldDelete=[menuDelegate menuView:self shouldDeleteMenuForIndex:index title:menuTitle];
        if (!shouldDelete) return NO;
    }
    [self resetSerielAfterDeleteMenu:index];
    [self sortAllMenu];
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(menuView:deleteMenuAtIndex:title:)]) {
        [menuDelegate menuView:self deleteMenuAtIndex:index title:menuTitle];
    }
    return YES;
}
-(void)selectMenuForIndex:(NSInteger)index mark:(NSString *)mark title:(NSString *)menuTitle{
    if (multiplicationMenu && multiplicationMenu.seriel==index) {
        // 点击繁殖按钮---弹出可选菜单
        NSLog(@"进入选人界面");
        multiplicationMenu.icon = @"multiply3.png";
        if (menuDelegate && [menuDelegate respondsToSelector:@selector(menuView:clickedMultiplicationMenu:)]) {
            [menuDelegate menuView:self clickedMultiplicationMenu:index];
        }
        
    }else{
        if ([menuDelegate respondsToSelector:@selector(menuView:clickedMenuWithMark:title:)]) {
            [menuDelegate menuView:self clickedMenuWithMark:mark title:menuTitle];
        }
    }
}
-(BOOL)selectMenuForIndex:(NSInteger)index title:(NSString *)menuTitle{
    BOOL rtn=NO;
    
    if (multiplicationMenu && multiplicationMenu.seriel==index) {
        // 点击繁殖按钮---弹出可选菜单
        NSLog(@"进入选人界面");
        multiplicationMenu.icon = @"multiply3.png";
        if (menuDelegate && [menuDelegate respondsToSelector:@selector(menuView:clickedMultiplicationMenu:)]) {
            rtn= YES;
            [menuDelegate menuView:self clickedMultiplicationMenu:index];
        }
        
    }else{
        if ([menuDelegate respondsToSelector:@selector(menuView:clickedMenuAtIndex:title:)]) {
            rtn = YES;
            [menuDelegate menuView:self clickedMenuAtIndex:index title:menuTitle];
            
        }
    }
    return rtn;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (touch.view==self) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}
-(void)addTapGesture{
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    [tap release];
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state==UIGestureRecognizerStateBegan) {
        current=[self areaContainsPoint:[gesture locationInView:self]]; 
        
        for (UIView*v in [self subviews]) {
            if ([v isKindOfClass:[OldMenuModel class]]) {
                OldMenuModel*menu =(OldMenuModel*)v;
                if (menu.seriel!=current) {
                    menu.isActive=YES;
                    if (multiplicationMenu) {
                        multiplicationMenu.isActive=NO;
                    }
                }else{
                    currentMenu=menu;
                }
                
            }
        }
        self.scrollEnabled=NO;
        
        loc0=[gesture locationInView:self];
        previous=loc0;
        
    }
    if (gesture.state==UIGestureRecognizerStateChanged) {
        
        CGPoint loc=[gesture locationInView:self]; 
        
        currentMenu.center=CGPointMake(loc.x-previous.x+currentMenu.center.x, loc.y-previous.y+currentMenu.center.y);
        
        previous=loc;
    }
    
    if (gesture.state==UIGestureRecognizerStateEnded) {
        currentMenu.isActive=YES;
        if (!CGPointEqualToPoint(previous, loc0)) {
            [self resetSerielAfterMoveMenu:currentMenu];
            [self sortAllMenu];
        }
        self.scrollEnabled=YES;
        
        if (multiplicationMenu) NSLog(@"multiply:%d",multiplicationMenu.seriel);
        CGPoint position=[gesture locationInView:self];
        NSInteger serl=[self areaContainsPoint:position];
        [self awakenMultiplication:serl];
        [self addTapGesture];
    }
}

-(void)addMenuaddbtn:(NSInteger)fromIndex
{
    NSInteger total=[self fetchTotalNum];
    
    multiplicationMenu=[[OldMenuModel alloc]init];
    multiplicationMenu.frame=CGRectMake(0, 0, elementWidth, elementHeight);
    multiplicationMenu.icon=@"multiply3.png";
    multiplicationMenu.delegate=self;
    multiplicationMenu.alpha=0.2;
    multiplicationMenu.transform=CGAffineTransformMakeScale(0.2, 0.2);
    if (param) {
        multiplicationMenu.seriel=fromIndex;
        multiplicationMenu.center=[self getMenuCenter:fromIndex];
        [self resetSerielAfterInsertMenu:fromIndex];
        [self sortAllMenu];
    }else{
        multiplicationMenu.seriel=total;
        multiplicationMenu.center=[self getMenuCenter:total];
    }
    [self addSubview:multiplicationMenu];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        multiplicationMenu.alpha=1.0;
        multiplicationMenu.transform=CGAffineTransformMakeScale(1.0, 1.0);
        
    }];

}

-(void)awakenMultiplication:(NSInteger)fromIndex{
    if (!enableMultiply) return;
    if (multiplicationMenu) return;
    
    NSInteger total=[self fetchTotalNum];
    
    multiplicationMenu=[[OldMenuModel alloc]init];
    multiplicationMenu.frame=CGRectMake(0, -4, elementWidth, elementHeight);
    multiplicationMenu.icon=@"multiply3.png";
    multiplicationMenu.delegate=self;
    multiplicationMenu.alpha=0.2;
    multiplicationMenu.transform=CGAffineTransformMakeScale(0.2, 0.2);
    if (param) {
        multiplicationMenu.seriel=fromIndex;
        multiplicationMenu.center=[self getMenuCenter:fromIndex];
        [self resetSerielAfterInsertMenu:fromIndex];
        [self sortAllMenu];
    }else{
        multiplicationMenu.seriel=total;
        multiplicationMenu.center=[self getMenuCenter:total]; 
    }
    [self addSubview:multiplicationMenu];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        multiplicationMenu.alpha=1.0;
        multiplicationMenu.transform=CGAffineTransformMakeScale(1.0, 1.0);
        
    }];

}
-(void)endEditing{
    if (tap==nil) return;
    CGPoint loc=CGPointMake(1.0, 1.0);
    current=[self areaContainsPoint:loc];
    
    for (OldMenuModel* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            [(OldMenuModel*)v setIsActive:NO];
        }
    }
    if (multiplicationMenu&&enableMultiply==YES) {
        [multiplicationMenu animateRemoveSelf];
        
        [self resetSerielAfterDeleteMenu:multiplicationMenu.seriel];
        [self sortAllMenu];
        [multiplicationMenu release];
        multiplicationMenu=nil;
        
    }
    NSLog(@"gesture2222:%p",tap);
    [self removeGestureRecognizer:tap];
    tap=nil;
    NSMutableArray* ma=[[NSMutableArray alloc]init];
    
    for (OldMenuModel* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            OldMenuModel* menu=(OldMenuModel*)v;
            if (menu.title) {
                NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:menu.title,@"title",[NSNumber numberWithInt:menu.seriel],@"seriel" ,nil];
                [ma addObject:dict];
                [dict release];
            } 
        }
    }
    [ma sortUsingFunction:compareSeriel context:nil];
//    for (int i=0; i<ma.count; i++) {
//        NSDictionary* dict=[ma objectAtIndex:i];
//        NSLog(@"---%@---%d",[dict objectForKey:@"title"],[[dict objectForKey:@"seriel"] intValue]);
//    }
    
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(menuView:didEndEditing:)]) {
        [menuDelegate menuView:self didEndEditing:ma];
    }
    [ma release];
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    
    CGPoint loc=[gesture locationInView:self];
    current=[self areaContainsPoint:loc];
    
    for (OldMenuModel* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            [(OldMenuModel*)v setIsActive:NO];
        }
    }
    if (multiplicationMenu&&enableMultiply==YES) {
        [multiplicationMenu animateRemoveSelf];

        [self resetSerielAfterDeleteMenu:multiplicationMenu.seriel];
        [self sortAllMenu];
        [multiplicationMenu release];
        multiplicationMenu=nil;
      
    }
    NSLog(@"gesture1111:%p",gesture);
    gesture=nil;
    [self removeGestureRecognizer:gesture];
    
    NSMutableArray* ma=[[NSMutableArray alloc]init];
    
    for (OldMenuModel* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            OldMenuModel* menu=(OldMenuModel*)v;
            if (menu.title) {
                NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:menu.title,@"title",[NSNumber numberWithInt:menu.seriel],@"seriel" ,nil];
                [ma addObject:dict];
                [dict release];
            } 
        }
    }
    [ma sortUsingFunction:compareSeriel context:nil];
//    for (int i=0; i<ma.count; i++) {
//        NSDictionary* dict=[ma objectAtIndex:i];
//        NSLog(@"---%@---%d",[dict objectForKey:@"title"],[[dict objectForKey:@"seriel"] intValue]);
//    }
    
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(menuView:didEndEditing:)]) {
        [menuDelegate menuView:self didEndEditing:ma];
    }
    [ma release];
}

NSComparisonResult compareSeriel(NSDictionary *firstDict,NSDictionary *secondDict, void *context){
    if ([[firstDict objectForKey:@"seriel"] intValue] < [[secondDict objectForKey:@"seriel"] intValue])
        
        return NSOrderedAscending;
    
    else if ([[firstDict objectForKey:@"seriel"] intValue] > [[secondDict objectForKey:@"seriel"] intValue])
        
        return NSOrderedDescending;
    
    else
        
        return NSOrderedSame;
}

int ceilingf(float f){
    return f>(int)f?(int)f+1:(int)f;
}

-(NSUInteger)areaContainsPoint:(CGPoint)loc{
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    int menuPerPage=(int)(loc.x/w)*(row*column);
    CGFloat xInPage=loc.x-(int)(loc.x/w)*w;
    int numInPage=(int)(loc.y/(h/row))*column+ceilingf((xInPage/(w/column)));
    return menuPerPage+numInPage-1;
}

-(void)sortAllMenu{
    for (UIView* v in [self subviews]) {
        if ([v isKindOfClass:[OldMenuModel class]]) {
            int count=((OldMenuModel*)v).seriel;
            
            CGPoint center=[self getMenuCenter:count];
            [UIView animateWithDuration:0.20 animations:^{
                v.center=center;
            }];
        }
    }
}

-(void)resetSerielAfterMoveMenu:(OldMenuModel *)menu{
    
    
    CGPoint loc=menu.center;
    NSUInteger area=[self areaContainsPoint:loc];
    NSLog(@"area:%d",area);
    NSUInteger total=[self fetchTotalNum];
    NSLog(@"count:%d",total);
    
    if (area>=total) {
        
        for (UIView* v in [self subviews]) {
            if ([v isKindOfClass:[OldMenuModel class]]) {
                if (((OldMenuModel*)v).seriel>menu.seriel) {
                    ((OldMenuModel*)v).seriel--;
                }
            }
        }
        
        menu.seriel=total-1;

        
        for (UIView* v in [self subviews]) {
            if ([v isKindOfClass:[OldMenuModel class]]) {
                NSLog(@"%@---%d",((OldMenuModel*)v).title,((OldMenuModel*)v).seriel);
                
            }
        }
        
    }else {
        for (UIView* v in [self subviews]){
            if ([v isKindOfClass:[OldMenuModel class]]) {
                if (((OldMenuModel*)v).seriel==area) {
                    ((OldMenuModel*)v).seriel=menu.seriel;
                    menu.seriel=area;

                    break;
                }
            }
            
        }
    }
    

    
}

@end
