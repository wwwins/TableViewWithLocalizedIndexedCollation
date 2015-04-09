//
//  ViewController.h
//  TableViewWithLocalizedIndexedCollation
//
//  Created by wwwins on 2015/4/9.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

