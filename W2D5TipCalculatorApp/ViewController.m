//
//  ViewController.m
//  W2D5TipCalculatorApp
//
//  Created by Karlo Pagtakhan on 03/18/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (strong, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, assign) CGFloat bottomConstraintConstant;
@property (strong, nonatomic) IBOutlet UISlider *tipSlider;
@property (strong, nonatomic) NSString *currency;


@end

@implementation ViewController
//MARK: View methods
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self prepareView];
  [self prepareNotificationCenter];
  [self prepareDelegates];
  [self prepareConstraints];
  
}


//MARK: Preparation
-(void)prepareView{
  self.currency = @"$";
}
-(void)prepareNotificationCenter{
  //Add listener to the keyboard display
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  
  //Add listener to the keyboard hide
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)prepareDelegates{
  self.billAmountTextField.delegate = self;
  self.tipPercentageTextField.delegate = self;
}
-(void)prepareConstraints{
  self.bottomConstraintConstant = self.bottomConstraint.constant;
}

//MARK: IBActions

- (IBAction)calculateTip:(id)sender {
  float tipAmount = 0;
  float billAmount = 0;
  float tipPercentage = 0;
  NSString *tipAmountWith2Decimals = @"";
  
  //Convert the text fields to float
  billAmount = [self.billAmountTextField.text floatValue];
  tipPercentage = [self.tipPercentageTextField.text floatValue];
  
  //String to hold tip amount with 2 decimal places
  tipAmountWith2Decimals = [NSString stringWithFormat:@"%.2f", billAmount * (tipPercentage/100)];
  
  self.tipAmountLabel.text = [NSString stringWithFormat:@"%@ %@",self.currency,tipAmountWith2Decimals];
  
  [self textFieldShouldReturn:self.billAmountTextField];
  [self textFieldShouldReturn:self.tipPercentageTextField];
}
- (IBAction)tipSliderMoved:(id)sender {
  self.tipPercentageTextField.text = [@((int)self.tipSlider.value) stringValue];
}
- (IBAction)tipTextFieldValueChanged:(id)sender {
  
  [self.tipSlider setValue:(float)[self.tipPercentageTextField.text integerValue] animated:YES];
}

//MARK:TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

//MARK: Notification selectors
-(void)keyboardShow:(NSNotification *)notification{
  
  
  NSValue *value = notification.userInfo[UIKeyboardFrameBeginUserInfoKey];
  CGRect frame = [value CGRectValue];
  CGFloat keyboardHeight = CGRectGetHeight(frame);
  
  //Adjust the bottom constraint to move the UIElements above the keyboard
  self.bottomConstraint.constant = self.bottomConstraintConstant + keyboardHeight;

}

-(void)keyboardHide:(NSNotification *)notification{

  //Adjust the bottom constraint to move the UIElements back
  self.bottomConstraint.constant = self.bottomConstraintConstant;
}

@end
