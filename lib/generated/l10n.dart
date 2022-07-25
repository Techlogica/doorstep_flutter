// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Close`
  String get navi {
    return Intl.message(
      'Close',
      name: 'navi',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Unable to import database. Retry`
  String get unableToImportDatabaseRetry {
    return Intl.message(
      'Unable to import database. Retry',
      name: 'unableToImportDatabaseRetry',
      desc: '',
      args: [],
    );
  }

  /// `Database Import Completed`
  String get databaseImportCompleted {
    return Intl.message(
      'Database Import Completed',
      name: 'databaseImportCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Backup Completed Successfully`
  String get backupCompletedSuccessfully {
    return Intl.message(
      'Backup Completed Successfully',
      name: 'backupCompletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unable to backup database. Retry`
  String get unableToBackupDatabaseRetry {
    return Intl.message(
      'Unable to backup database. Retry',
      name: 'unableToBackupDatabaseRetry',
      desc: '',
      args: [],
    );
  }

  /// `No network connection`
  String get noNetworkConnection {
    return Intl.message(
      'No network connection',
      name: 'noNetworkConnection',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Rate your delivery`
  String get rateYourDeliveryAgent {
    return Intl.message(
      'Rate your delivery',
      name: 'rateYourDeliveryAgent',
      desc: '',
      args: [],
    );
  }

  /// `Agent Name`
  String get agentName {
    return Intl.message(
      'Agent Name',
      name: 'agentName',
      desc: '',
      args: [],
    );
  }

  /// `Hi,`
  String get hi {
    return Intl.message(
      'Hi,',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Enter your PIN`
  String get enterYourPin {
    return Intl.message(
      'Enter your PIN',
      name: 'enterYourPin',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get singUp {
    return Intl.message(
      'Sign up',
      name: 'singUp',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobileNumber {
    return Intl.message(
      'Mobile number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mobile number`
  String get enterYourMobileNumber {
    return Intl.message(
      'Enter your mobile number',
      name: 'enterYourMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Get OTP`
  String get getOtp {
    return Intl.message(
      'Get OTP',
      name: 'getOtp',
      desc: '',
      args: [],
    );
  }

  /// `Already you have an account?`
  String get alreadyYouHaveAnAccount {
    return Intl.message(
      'Already you have an account?',
      name: 'alreadyYouHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `My orders`
  String get myOrders {
    return Intl.message(
      'My orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `KNOCK, KNOCK! WHO'S THERE?`
  String get knockKnockWhosThere {
    return Intl.message(
      'KNOCK, KNOCK! WHO\'S THERE?',
      name: 'knockKnockWhosThere',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any addresses saved. Saving address helps you checkout faster`
  String get youDontHaveAnyAddressesSavedSavingAddressHelpsYouCheckoutFaster {
    return Intl.message(
      'You don\'t have any addresses saved. Saving address helps you checkout faster',
      name: 'youDontHaveAnyAddressesSavedSavingAddressHelpsYouCheckoutFaster',
      desc: '',
      args: [],
    );
  }

  /// `Add address`
  String get addAnAddress {
    return Intl.message(
      'Add address',
      name: 'addAnAddress',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Sent to your`
  String get sentToYour {
    return Intl.message(
      'Sent to your',
      name: 'sentToYour',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get the OTP?`
  String get didntGetOtp {
    return Intl.message(
      'Didn\'t get the OTP?',
      name: 'didntGetOtp',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get the code?`
  String get didntGetCode {
    return Intl.message(
      'Didn\'t get the code?',
      name: 'didntGetCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOtp {
    return Intl.message(
      'Resend OTP',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Manage Address`
  String get manageAddress {
    return Intl.message(
      'Manage Address',
      name: 'manageAddress',
      desc: '',
      args: [],
    );
  }

  /// `Order List`
  String get orderList {
    return Intl.message(
      'Order List',
      name: 'orderList',
      desc: '',
      args: [],
    );
  }

  /// `Get QR code`
  String get getQrCode {
    return Intl.message(
      'Get QR code',
      name: 'getQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Please provide this QR code to our agent to complete your order`
  String get pleaseProviderThisQrCodeToOurAgentToCompleteYourOrder {
    return Intl.message(
      'Please provide this QR code to our agent to complete your order',
      name: 'pleaseProviderThisQrCodeToOurAgentToCompleteYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Report Complaint`
  String get complaintReport {
    return Intl.message(
      'Report Complaint',
      name: 'complaintReport',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Select address`
  String get selectAddress {
    return Intl.message(
      'Select address',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Work`
  String get work {
    return Intl.message(
      'Work',
      name: 'work',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `No address added`
  String get noAddressAdded {
    return Intl.message(
      'No address added',
      name: 'noAddressAdded',
      desc: '',
      args: [],
    );
  }

  /// `Home / Flat / Block no.`
  String get homeFlatBlockNo {
    return Intl.message(
      'Home / Flat / Block no.',
      name: 'homeFlatBlockNo',
      desc: '',
      args: [],
    );
  }

  /// `Landmark`
  String get landmark {
    return Intl.message(
      'Landmark',
      name: 'landmark',
      desc: '',
      args: [],
    );
  }

  /// `My cart`
  String get myCart {
    return Intl.message(
      'My cart',
      name: 'myCart',
      desc: '',
      args: [],
    );
  }

  /// `Add Custom Note`
  String get addCustomNote {
    return Intl.message(
      'Add Custom Note',
      name: 'addCustomNote',
      desc: '',
      args: [],
    );
  }

  /// `Check delivery charge`
  String get deliveryCharge {
    return Intl.message(
      'Check delivery charge',
      name: 'deliveryCharge',
      desc: '',
      args: [],
    );
  }

  /// `You seem to be in a new Location`
  String get youSeemToBeInANewLocation {
    return Intl.message(
      'You seem to be in a new Location',
      name: 'youSeemToBeInANewLocation',
      desc: '',
      args: [],
    );
  }

  /// `Add address`
  String get addAddress {
    return Intl.message(
      'Add address',
      name: 'addAddress',
      desc: '',
      args: [],
    );
  }

  /// `ATM Service`
  String get atmService {
    return Intl.message(
      'ATM Service',
      name: 'atmService',
      desc: '',
      args: [],
    );
  }

  /// `Cash Withdrawal`
  String get cashWithdrawal {
    return Intl.message(
      'Cash Withdrawal',
      name: 'cashWithdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Enter the amount`
  String get enterTheAmount {
    return Intl.message(
      'Enter the amount',
      name: 'enterTheAmount',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Update cart`
  String get updateCart {
    return Intl.message(
      'Update cart',
      name: 'updateCart',
      desc: '',
      args: [],
    );
  }

  /// `Items Selected`
  String get itemsSelected {
    return Intl.message(
      'Items Selected',
      name: 'itemsSelected',
      desc: '',
      args: [],
    );
  }

  /// `Add cart`
  String get addCart {
    return Intl.message(
      'Add cart',
      name: 'addCart',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLocation {
    return Intl.message(
      'Current Location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Save as`
  String get saveAs {
    return Intl.message(
      'Save as',
      name: 'saveAs',
      desc: '',
      args: [],
    );
  }

  /// `e.g.: Dad's Place, John's Home`
  String get egDadPlaceJohnsHome {
    return Intl.message(
      'e.g.: Dad\'s Place, John\'s Home',
      name: 'egDadPlaceJohnsHome',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get saveAddress {
    return Intl.message(
      'Save Address',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirm`
  String get orderConform {
    return Intl.message(
      'Order Confirm',
      name: 'orderConform',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message(
      'Delivered',
      name: 'delivered',
      desc: '',
      args: [],
    );
  }

  /// `Please provide our service feedback`
  String get pleaseProvideOurServiceFeedback {
    return Intl.message(
      'Please provide our service feedback',
      name: 'pleaseProvideOurServiceFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback makes ATM Bharath better.`
  String get yourFeedbackMakesAtmBharathBetter {
    return Intl.message(
      'Your feedback makes ATM Bharath better.',
      name: 'yourFeedbackMakesAtmBharathBetter',
      desc: '',
      args: [],
    );
  }

  /// `REORDER`
  String get reorder {
    return Intl.message(
      'REORDER',
      name: 'reorder',
      desc: '',
      args: [],
    );
  }

  /// `RATE ORDER`
  String get rateOrder {
    return Intl.message(
      'RATE ORDER',
      name: 'rateOrder',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Help Line`
  String get helpLine {
    return Intl.message(
      'Help Line',
      name: 'helpLine',
      desc: '',
      args: [],
    );
  }

  /// `App info`
  String get appInfo {
    return Intl.message(
      'App info',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `Invite a friend`
  String get inviteAFriend {
    return Intl.message(
      'Invite a friend',
      name: 'inviteAFriend',
      desc: '',
      args: [],
    );
  }

  /// `from`
  String get from {
    return Intl.message(
      'from',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `ATM BHARATH`
  String get atmBharath {
    return Intl.message(
      'ATM BHARATH',
      name: 'atmBharath',
      desc: '',
      args: [],
    );
  }

  /// `Door Step Banking`
  String get doorStepBanking {
    return Intl.message(
      'Door Step Banking',
      name: 'doorStepBanking',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Full Address`
  String get fullAddress {
    return Intl.message(
      'Full Address',
      name: 'fullAddress',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to log out?`
  String get logoutAlert {
    return Intl.message(
      'Are you sure want to log out?',
      name: 'logoutAlert',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message(
      'Wishlist',
      name: 'wishlist',
      desc: '',
      args: [],
    );
  }

  /// `Do you need to select another address?`
  String get doYouNeedToSelectAnotherAddress {
    return Intl.message(
      'Do you need to select another address?',
      name: 'doYouNeedToSelectAnotherAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset`
  String get passwordReset {
    return Intl.message(
      'Password Reset',
      name: 'passwordReset',
      desc: '',
      args: [],
    );
  }

  /// `Request Password`
  String get requestPassword {
    return Intl.message(
      'Request Password',
      name: 'requestPassword',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Account`
  String get findYourAccount {
    return Intl.message(
      'Find Your Account',
      name: 'findYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mobile number to search for your account.`
  String get pleaseEnterYourMobileNumberToSearchForYourAccount {
    return Intl.message(
      'Please enter your mobile number to search for your account.',
      name: 'pleaseEnterYourMobileNumberToSearchForYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found`
  String get noDataFound {
    return Intl.message(
      'No Data Found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get oops {
    return Intl.message(
      'Oops!',
      name: 'oops',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get mcontinue {
    return Intl.message(
      'Continue',
      name: 'mcontinue',
      desc: '',
      args: [],
    );
  }

  /// `Create a new password`
  String get createANewPassword {
    return Intl.message(
      'Create a new password',
      name: 'createANewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter the security code`
  String get enterTheSecurityCode {
    return Intl.message(
      'Enter the security code',
      name: 'enterTheSecurityCode',
      desc: '',
      args: [],
    );
  }

  /// `Check your phone for a text message with your code. Your code is 4 length`
  String get checkYourPhoneForATextMessageWithYourCodeYourCodeIs4Length {
    return Intl.message(
      'Check your phone for a text message with your code. Your code is 4 length',
      name: 'checkYourPhoneForATextMessageWithYourCodeYourCodeIs4Length',
      desc: '',
      args: [],
    );
  }

  /// `We sent your code to:`
  String get weSentYourCodeTo {
    return Intl.message(
      'We sent your code to:',
      name: 'weSentYourCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `Password Updated!`
  String get passwordUpdated {
    return Intl.message(
      'Password Updated!',
      name: 'passwordUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been changed successfully. Use your new password to login.`
  String get yourPasswordHasBeenChangedSuccessfullyUseYourNewPasswordToLogin {
    return Intl.message(
      'Your password has been changed successfully. Use your new password to login.',
      name: 'yourPasswordHasBeenChangedSuccessfullyUseYourNewPasswordToLogin',
      desc: '',
      args: [],
    );
  }

  /// `View Status`
  String get viewStatus {
    return Intl.message(
      'View Status',
      name: 'viewStatus',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `Invalid UserName`
  String get invalidUsername {
    return Intl.message(
      'Invalid UserName',
      name: 'invalidUsername',
      desc: '',
      args: [],
    );
  }

  /// `InValid Email Address`
  String get invalidAddress {
    return Intl.message(
      'InValid Email Address',
      name: 'invalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Email Address`
  String get wrongMail {
    return Intl.message(
      'Wrong Email Address',
      name: 'wrongMail',
      desc: '',
      args: [],
    );
  }

  /// `sucessfully added to wishlist`
  String get sucessWishlist {
    return Intl.message(
      'sucessfully added to wishlist',
      name: 'sucessWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Invalid PIN`
  String get invalidPin {
    return Intl.message(
      'Invalid PIN',
      name: 'invalidPin',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Mobile Number`
  String get invalidNumber {
    return Intl.message(
      'Invalid Mobile Number',
      name: 'invalidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get invalidPassword {
    return Intl.message(
      'Invalid Password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Location added successfully`
  String get locationSuccess {
    return Intl.message(
      'Location added successfully',
      name: 'locationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Choose Location`
  String get chooseLocation {
    return Intl.message(
      'Choose Location',
      name: 'chooseLocation',
      desc: '',
      args: [],
    );
  }

  /// `Select save type`
  String get selectSaveType {
    return Intl.message(
      'Select save type',
      name: 'selectSaveType',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get invalidOtp {
    return Intl.message(
      'Invalid OTP',
      name: 'invalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP expired`
  String get otpTimeout {
    return Intl.message(
      'OTP expired',
      name: 'otpTimeout',
      desc: '',
      args: [],
    );
  }

  /// `OTP Received`
  String get otpReceived {
    return Intl.message(
      'OTP Received',
      name: 'otpReceived',
      desc: '',
      args: [],
    );
  }

  /// `The countdown timer is over`
  String get countdownTimer {
    return Intl.message(
      'The countdown timer is over',
      name: 'countdownTimer',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Password`
  String get wrongPassword {
    return Intl.message(
      'Wrong Password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Email Address`
  String get wrongEmail {
    return Intl.message(
      'Wrong Email Address',
      name: 'wrongEmail',
      desc: '',
      args: [],
    );
  }

  /// `InValid Email Address`
  String get invalidEmail {
    return Intl.message(
      'InValid Email Address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `ORDER #`
  String get orderNumber {
    return Intl.message(
      'ORDER #',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select the language of your choice`
  String get chooseYourPreferredLanguage {
    return Intl.message(
      'Select the language of your choice',
      name: 'chooseYourPreferredLanguage',
      desc: '',
      args: [],
    );
  }

  /// `OTP:`
  String get otp {
    return Intl.message(
      'OTP:',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Successfully added to cart`
  String get cartSuccessMsg {
    return Intl.message(
      'Successfully added to cart',
      name: 'cartSuccessMsg',
      desc: '',
      args: [],
    );
  }

  /// `The product already exists in the cart`
  String get cartFailMsg {
    return Intl.message(
      'The product already exists in the cart',
      name: 'cartFailMsg',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge:`
  String get deliveryChargeTitle {
    return Intl.message(
      'Delivery Charge:',
      name: 'deliveryChargeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please set the old password`
  String get invalidOldPassword {
    return Intl.message(
      'Please set the old password',
      name: 'invalidOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Set a new password`
  String get setNewpassword {
    return Intl.message(
      'Set a new password',
      name: 'setNewpassword',
      desc: '',
      args: [],
    );
  }

  /// `Set a confirmation password`
  String get setConfirmPassword {
    return Intl.message(
      'Set a confirmation password',
      name: 'setConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Check Password`
  String get checkPassword {
    return Intl.message(
      'Check Password',
      name: 'checkPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change Address`
  String get changeAddress {
    return Intl.message(
      'Change Address',
      name: 'changeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge : Rs.`
  String get deliverycharge {
    return Intl.message(
      'Delivery Charge : Rs.',
      name: 'deliverycharge',
      desc: '',
      args: [],
    );
  }

  /// `Delivery charge also vary according to location`
  String get deliverychargeDescription {
    return Intl.message(
      'Delivery charge also vary according to location',
      name: 'deliverychargeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Estimated delivery charge: Rs.`
  String get estimatedDeliveryCharge {
    return Intl.message(
      'Estimated delivery charge: Rs.',
      name: 'estimatedDeliveryCharge',
      desc: '',
      args: [],
    );
  }

  /// `For future purpose`
  String get forFuturePurpose {
    return Intl.message(
      'For future purpose',
      name: 'forFuturePurpose',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `The product in the cart will be discarded when the order is repeated`
  String get reorderAlert {
    return Intl.message(
      'The product in the cart will be discarded when the order is repeated',
      name: 'reorderAlert',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this order?`
  String get deleteOrderAlert {
    return Intl.message(
      'Are you sure you want to cancel this order?',
      name: 'deleteOrderAlert',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel confirmation`
  String get cancelConfirmation {
    return Intl.message(
      'Cancel confirmation',
      name: 'cancelConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `ATM Withdrawal`
  String get atmWithdrawal {
    return Intl.message(
      'ATM Withdrawal',
      name: 'atmWithdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Press once again to exit!`
  String get pressOnceAgainToExit {
    return Intl.message(
      'Press once again to exit!',
      name: 'pressOnceAgainToExit',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed`
  String get orderPlaced {
    return Intl.message(
      'Order Placed',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmed`
  String get orderConfirmed {
    return Intl.message(
      'Order Confirmed',
      name: 'orderConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Order Processed`
  String get orderProcessed {
    return Intl.message(
      'Order Processed',
      name: 'orderProcessed',
      desc: '',
      args: [],
    );
  }

  /// `Agent Arrived`
  String get agentArrived {
    return Intl.message(
      'Agent Arrived',
      name: 'agentArrived',
      desc: '',
      args: [],
    );
  }

  /// `Order Verified`
  String get orderVerified {
    return Intl.message(
      'Order Verified',
      name: 'orderVerified',
      desc: '',
      args: [],
    );
  }

  /// `Order Delivered`
  String get orderDelivered {
    return Intl.message(
      'Order Delivered',
      name: 'orderDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Order Completed`
  String get orderCompleted {
    return Intl.message(
      'Order Completed',
      name: 'orderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `View Track`
  String get viewTrack {
    return Intl.message(
      'View Track',
      name: 'viewTrack',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'hi', countryCode: 'IN'),
      Locale.fromSubtags(languageCode: 'ml', countryCode: 'IN'),
      Locale.fromSubtags(languageCode: 'mr', countryCode: 'IN'),
      Locale.fromSubtags(languageCode: 'ta', countryCode: 'IN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
