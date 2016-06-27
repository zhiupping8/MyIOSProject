//
//  ZiZhiChooseTimeViewController.m
//  ZiZhiGZW
//
//  Created by zyz on 12/13/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#import "ZiZhiChooseTimeViewController.h"
#import "ZiZhiProgramDetailModel.h"

@interface ZiZhiChooseTimeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ZiZhiChooseTimeViewController

- (void)initUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cctv_log"]];
    imageView.frame = CGRectMake(0, 0, 120, 37);
    self.navigationItem.titleView = imageView;
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
    barImageView.image = [UIImage imageNamed:@"bar"];
    [self.navigationController.navigationBar addSubview:barImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.records.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defalut"];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defalut"];
    }
    if(indexPath.row==self.selectedIndex){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    ZiZhiRecordModel *model = [self.records objectAtIndex:indexPath.row];
    cell.textLabel.text = model.recordtime;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    self.timeText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [tableView reloadData];
    self.returnInfoBlock(self.selectedIndex, self.timeText);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
