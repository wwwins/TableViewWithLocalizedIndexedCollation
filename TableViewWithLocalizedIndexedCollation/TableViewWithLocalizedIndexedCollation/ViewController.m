//
//  ViewController.m
//  TableViewWithLocalizedIndexedCollation
//
//  Created by wwwins on 2015/4/9.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSMutableArray *arrDataSource;
@property NSMutableArray *arrSessions;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  [self initDataSource];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initDataSource
{
  NSArray *arr = @[
                   @"大魚兒",
                   @"Jason",
                   @"肥貓貓",
                   @"Service",
                   @"辦公室",
                   @"Superman",
                   @"Jacky",
                   @"isobar",
                   @"duck",
                   @"魚爸",
                   @"cll",
                   @"愛心捐款",
                   @"Polo",
                   @"dcjea",
                   @"鴨媽",
                   @"Poly",
                   @"小襪子",
                   @"zooZooo",
                   @"房客陳太太",
                   @"Albert",
                   @"Joely",
                   @"阿丟",
                   @"Fish",
                   @"魚大哥",
                   @"kiwi",
                   @"Ma",
                   @"Dad",
                   @"Gurooo",
                   @"鴨爸",
                   @"Bob",
                   @"Akin",
                   @"ivan",
                   @"kini",
                   @"lamber",
                   @"BBo",
                   @"二哥"];
  
  // 指定 locale
  NSLocale *strokeSortingLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
  arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [obj1 compare:obj2 options:0 range:NSMakeRange(0, [obj1 length]) locale:strokeSortingLocale];
  }];
  
  [self updateContacts:arr];
}

#pragma mark - prepare objects

// http://stackoverflow.com/questions/6278960/uilocalizedindexedcollation-only-returns-an-english-collation
// Localized resources can be mixed = YES in Info.plist
- (void)updateContacts:(NSArray *)objects {
  // 取得群組: 1畫/2畫/3畫...A/B/C/...Z/#
  //NSLog(@"sectionTitles=%@",[[UILocalizedIndexedCollation currentCollation] sectionTitles]);
  // 總共幾個群組
  NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
  // 建立群組陣列
  NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
  for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
    [mutableSections addObject:[NSMutableArray array]];
  }
  
  // 將每個物件放到對應的 section
  for (id object in objects) {
    NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:@selector(description)];
    [[mutableSections objectAtIndex:sectionNumber] addObject:object];
  }
  
  // remove empty sections and titles
  NSMutableArray *existTitleSections = [NSMutableArray array];
  for (NSArray *section in mutableSections) {
    if ([section count] > 0) {
      [existTitleSections addObject:section];
    }
  }
  
  NSMutableArray *existTitles = [NSMutableArray array];
  NSArray *allSections = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
  for (NSUInteger i = 0; i < [allSections count]; i++) {
    if ([mutableSections[i] count] > 0) {
      [existTitles addObject:allSections[i]];
    }
  }
  
  //NSLog(@"sections:%@\ntitles:%@",existTitleSections,existTitles);
  _arrDataSource = existTitleSections;
  _arrSessions = existTitles;
  
  [self.tableView reloadData];
}

#pragma mark - Session

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  //return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
  return _arrSessions[section];
}

/*
 - (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
 }
 */

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  //return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
  return index;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  //return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
  return _arrSessions;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return [_arrDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [_arrDataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
  // Configure the cell...
  cell.textLabel.text = _arrDataSource[indexPath.section][indexPath.row];
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
