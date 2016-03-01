//
//  HTDistrictSearchViewController.m
//  WriteRecord
//
//  Created by 杨晓伟 on 16/1/27.
//  Copyright © 2016年 杨晓伟. All rights reserved.
//

#import "HTDistrictSearchViewController.h"
#import "HTNavigationBar.h"
#import "GetDataTools.h"
#import "HTDistrictSearchModel.h"

#define kSearchURL @"http://q.chanyouji.com/api/v1/districts/search.json?latitude=0&longitude=0&name=%@"

@interface HTDistrictSearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *resultArray;

@end

@implementation HTDistrictSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    HTNavigationBar *htBar = [HTNavigationBar new];

    self.districtSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10 , 0, htBar.frame.size.width - 60, htBar.frame.size.height - 20)];
    self.districtSearchBar.delegate = self;
    
    [htBar addSubview:self.districtSearchBar];
    
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(htBar.frame.size.width - 45, 20, 40, htBar.frame.size.height - 20);
    [commitButton setTitle:@"取消" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [htBar.barColorView addSubview:commitButton];
    
    [self.navigationController setValue:htBar forKey:@"navigationBar"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --搜索框的代理方法--
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"%@",searchBar.text);
    
    NSCharacterSet *characterSet = [NSCharacterSet letterCharacterSet];
    
    NSString *string = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    NSLog(@"%@",string);
    
    NSString *urlString = [NSString stringWithFormat:kSearchURL,string];
    
    [[GetDataTools shareGetDataTools] getDataWithUrlString:urlString data:^(NSDictionary *dataDict) {
        
        self.resultArray = [NSMutableArray array];
        
        if (dataDict != nil) {
            
            for (NSDictionary *dict in dataDict[@"data"]) {
                
                HTDistrictSearchModel *model = [HTDistrictSearchModel new];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.resultArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }
        
    }];
    
}

#pragma mark --tableView代理方法--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
    
    HTDistrictSearchModel *model = self.resultArray[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HTDistrictSearchModel *model = self.resultArray[indexPath.row];
    
    self.districtPassBlock(model);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
