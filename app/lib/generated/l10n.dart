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

  /// `Session expired`
  String get sessionExpired {
    return Intl.message(
      'Session expired',
      name: 'sessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `No Internet`
  String get noInternetConnection {
    return Intl.message(
      'No Internet',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `An error occured`
  String get anErrorOccured {
    return Intl.message(
      'An error occured',
      name: 'anErrorOccured',
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

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Email is not valid`
  String get emailIsNotValid {
    return Intl.message(
      'Email is not valid',
      name: 'emailIsNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Website is not valid`
  String get websiteIsNotValid {
    return Intl.message(
      'Website is not valid',
      name: 'websiteIsNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Mobile is not valid`
  String get mobileIsNotValid {
    return Intl.message(
      'Mobile is not valid',
      name: 'mobileIsNotValid',
      desc: '',
      args: [],
    );
  }

  /// `must be at least {count}`
  String minLengthValidator(Object count) {
    return Intl.message(
      'must be at least $count',
      name: 'minLengthValidator',
      desc: '',
      args: [count],
    );
  }

  /// `must be at most {count}`
  String maxLengthValidator(Object count) {
    return Intl.message(
      'must be at most $count',
      name: 'maxLengthValidator',
      desc: '',
      args: [count],
    );
  }

  /// `required Field`
  String get requiredField {
    return Intl.message(
      'required Field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `There Is Required Fields`
  String get thereIsRequiredFields {
    return Intl.message(
      'There Is Required Fields',
      name: 'thereIsRequiredFields',
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

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
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

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get business {
    return Intl.message(
      'Business',
      name: 'business',
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

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get colors {
    return Intl.message(
      'Colors',
      name: 'colors',
      desc: '',
      args: [],
    );
  }

  /// `L.S`
  String get ls {
    return Intl.message(
      'L.S',
      name: 'ls',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Zipper Number`
  String get zipper_number {
    return Intl.message(
      'Zipper Number',
      name: 'zipper_number',
      desc: '',
      args: [],
    );
  }

  /// `Carry Method`
  String get carry_method {
    return Intl.message(
      'Carry Method',
      name: 'carry_method',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `No Items To Display`
  String get no_items_to_display {
    return Intl.message(
      'No Items To Display',
      name: 'no_items_to_display',
      desc: '',
      args: [],
    );
  }

  /// `Added Successfully`
  String get addedSuccessfully {
    return Intl.message(
      'Added Successfully',
      name: 'addedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Successfully`
  String get editSuccessfully {
    return Intl.message(
      'Edit Successfully',
      name: 'editSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Deleted Successfully`
  String get deletedSuccessfully {
    return Intl.message(
      'Deleted Successfully',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sent Successfully`
  String get sentSuccessfully {
    return Intl.message(
      'Sent Successfully',
      name: 'sentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Blocked Successfully`
  String get blockedSuccessfully {
    return Intl.message(
      'Blocked Successfully',
      name: 'blockedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Tap To Select Date`
  String get tapToSelectDate {
    return Intl.message(
      'Tap To Select Date',
      name: 'tapToSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message(
      'Light Theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign with email address`
  String get signWithEmail {
    return Intl.message(
      'Sign with email address',
      name: 'signWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Sign with Mobile number`
  String get signWithNumber {
    return Intl.message(
      'Sign with Mobile number',
      name: 'signWithNumber',
      desc: '',
      args: [],
    );
  }

  /// `Already Have Account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already Have Account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Don't Have Account`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t Have Account',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message(
      'Remember Me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
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

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthdate {
    return Intl.message(
      'Birth Date',
      name: 'birthdate',
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

  /// `Are You Invited?`
  String get areYouInvited {
    return Intl.message(
      'Are You Invited?',
      name: 'areYouInvited',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Code`
  String get invitationCode {
    return Intl.message(
      'Invitation Code',
      name: 'invitationCode',
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

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Resend The Code`
  String get resendCode {
    return Intl.message(
      'Resend The Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get media {
    return Intl.message(
      'Media',
      name: 'media',
      desc: '',
      args: [],
    );
  }

  /// `Caption`
  String get caption {
    return Intl.message(
      'Caption',
      name: 'caption',
      desc: '',
      args: [],
    );
  }

  /// `It's Made For Kids`
  String get isPostForKids {
    return Intl.message(
      'It\'s Made For Kids',
      name: 'isPostForKids',
      desc: '',
      args: [],
    );
  }

  /// `Tag Up Posts`
  String get tagUpPost {
    return Intl.message(
      'Tag Up Posts',
      name: 'tagUpPost',
      desc: '',
      args: [],
    );
  }

  /// `Tag Up Profile`
  String get tagUpProfile {
    return Intl.message(
      'Tag Up Profile',
      name: 'tagUpProfile',
      desc: '',
      args: [],
    );
  }

  /// `Hash Tags`
  String get hashTags {
    return Intl.message(
      'Hash Tags',
      name: 'hashTags',
      desc: '',
      args: [],
    );
  }

  /// `Post Type`
  String get postType {
    return Intl.message(
      'Post Type',
      name: 'postType',
      desc: '',
      args: [],
    );
  }

  /// `Post Up`
  String get postUp {
    return Intl.message(
      'Post Up',
      name: 'postUp',
      desc: '',
      args: [],
    );
  }

  /// `Call Up`
  String get callUp {
    return Intl.message(
      'Call Up',
      name: 'callUp',
      desc: '',
      args: [],
    );
  }

  /// `Shop Up`
  String get shopUp {
    return Intl.message(
      'Shop Up',
      name: 'shopUp',
      desc: '',
      args: [],
    );
  }

  /// `Book Up`
  String get bookUp {
    return Intl.message(
      'Book Up',
      name: 'bookUp',
      desc: '',
      args: [],
    );
  }

  /// `Sub Category`
  String get subCategory {
    return Intl.message(
      'Sub Category',
      name: 'subCategory',
      desc: '',
      args: [],
    );
  }

  /// `Child Category`
  String get childCategory {
    return Intl.message(
      'Child Category',
      name: 'childCategory',
      desc: '',
      args: [],
    );
  }

  /// `Additional Info`
  String get additionalInfo {
    return Intl.message(
      'Additional Info',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message(
      'Publish',
      name: 'publish',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stock {
    return Intl.message(
      'Stock',
      name: 'stock',
      desc: '',
      args: [],
    );
  }

  /// `Item Availability Times`
  String get itemAvailabilityTimes {
    return Intl.message(
      'Item Availability Times',
      name: 'itemAvailabilityTimes',
      desc: '',
      args: [],
    );
  }

  /// `Specifications`
  String get specifications {
    return Intl.message(
      'Specifications',
      name: 'specifications',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charges`
  String get deliveryCharges {
    return Intl.message(
      'Delivery Charges',
      name: 'deliveryCharges',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Range`
  String get deliveryRange {
    return Intl.message(
      'Delivery Range',
      name: 'deliveryRange',
      desc: '',
      args: [],
    );
  }

  /// `Same To Daily Store Timing`
  String get sameToDailyStoreTiming {
    return Intl.message(
      'Same To Daily Store Timing',
      name: 'sameToDailyStoreTiming',
      desc: '',
      args: [],
    );
  }

  /// `Specific Daily Timing`
  String get specificDailyTiming {
    return Intl.message(
      'Specific Daily Timing',
      name: 'specificDailyTiming',
      desc: '',
      args: [],
    );
  }

  /// `Store Timing`
  String get storeTiming {
    return Intl.message(
      'Store Timing',
      name: 'storeTiming',
      desc: '',
      args: [],
    );
  }

  /// `Vip Item`
  String get vipItem {
    return Intl.message(
      'Vip Item',
      name: 'vipItem',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message(
      'Images',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `Owner Details`
  String get ownerDetails {
    return Intl.message(
      'Owner Details',
      name: 'ownerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Identify Card`
  String get identifyCard {
    return Intl.message(
      'Identify Card',
      name: 'identifyCard',
      desc: '',
      args: [],
    );
  }

  /// `Issue Date`
  String get issueDate {
    return Intl.message(
      'Issue Date',
      name: 'issueDate',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiryDate {
    return Intl.message(
      'Expiry Date',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Upload Images`
  String get uploadImages {
    return Intl.message(
      'Upload Images',
      name: 'uploadImages',
      desc: '',
      args: [],
    );
  }

  /// `Account Holder Name`
  String get accountHolderName {
    return Intl.message(
      'Account Holder Name',
      name: 'accountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Details`
  String get bankDetails {
    return Intl.message(
      'Bank Details',
      name: 'bankDetails',
      desc: '',
      args: [],
    );
  }

  /// `Store Details`
  String get storeDetails {
    return Intl.message(
      'Store Details',
      name: 'storeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Individual Licence`
  String get individualLicence {
    return Intl.message(
      'Individual Licence',
      name: 'individualLicence',
      desc: '',
      args: [],
    );
  }

  /// `Corporate Licence`
  String get corporateLicence {
    return Intl.message(
      'Corporate Licence',
      name: 'corporateLicence',
      desc: '',
      args: [],
    );
  }

  /// `Identification Verification`
  String get identificationVerification {
    return Intl.message(
      'Identification Verification',
      name: 'identificationVerification',
      desc: '',
      args: [],
    );
  }

  /// `Bank Statement`
  String get bankStatement {
    return Intl.message(
      'Bank Statement',
      name: 'bankStatement',
      desc: '',
      args: [],
    );
  }

  /// `Front Image`
  String get frontImage {
    return Intl.message(
      'Front Image',
      name: 'frontImage',
      desc: '',
      args: [],
    );
  }

  /// `Back Image`
  String get backImage {
    return Intl.message(
      'Back Image',
      name: 'backImage',
      desc: '',
      args: [],
    );
  }

  /// `Upload Files`
  String get uploadFiles {
    return Intl.message(
      'Upload Files',
      name: 'uploadFiles',
      desc: '',
      args: [],
    );
  }

  /// `Pike Files`
  String get pikeFiles {
    return Intl.message(
      'Pike Files',
      name: 'pikeFiles',
      desc: '',
      args: [],
    );
  }

  /// `Primary Store Plan`
  String get primaryStorePlan {
    return Intl.message(
      'Primary Store Plan',
      name: 'primaryStorePlan',
      desc: '',
      args: [],
    );
  }

  /// `Standard Store Plan`
  String get standardStorePlan {
    return Intl.message(
      'Standard Store Plan',
      name: 'standardStorePlan',
      desc: '',
      args: [],
    );
  }

  /// `24 Store Plan`
  String get Store24Plan {
    return Intl.message(
      '24 Store Plan',
      name: 'Store24Plan',
      desc: '',
      args: [],
    );
  }

  /// `Include`
  String get include {
    return Intl.message(
      'Include',
      name: 'include',
      desc: '',
      args: [],
    );
  }

  /// `24 Tag`
  String get Tag24 {
    return Intl.message(
      '24 Tag',
      name: 'Tag24',
      desc: '',
      args: [],
    );
  }

  /// `Store Licence Details`
  String get storeLicenceDetails {
    return Intl.message(
      'Store Licence Details',
      name: 'storeLicenceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Licence Name`
  String get licenceName {
    return Intl.message(
      'Licence Name',
      name: 'licenceName',
      desc: '',
      args: [],
    );
  }

  /// `Commercial Card`
  String get commercialCard {
    return Intl.message(
      'Commercial Card',
      name: 'commercialCard',
      desc: '',
      args: [],
    );
  }

  /// `Date Of Registration`
  String get dateOfRegistration {
    return Intl.message(
      'Date Of Registration',
      name: 'dateOfRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Store Name`
  String get storeName {
    return Intl.message(
      'Store Name',
      name: 'storeName',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Years`
  String get years {
    return Intl.message(
      'Years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Top Profile Plan`
  String get topProfilePlan {
    return Intl.message(
      'Top Profile Plan',
      name: 'topProfilePlan',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion`
  String get suggestion {
    return Intl.message(
      'Suggestion',
      name: 'suggestion',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Standard Invite`
  String get standardInvite {
    return Intl.message(
      'Standard Invite',
      name: 'standardInvite',
      desc: '',
      args: [],
    );
  }

  /// `Special Invite`
  String get specialInvite {
    return Intl.message(
      'Special Invite',
      name: 'specialInvite',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get invite {
    return Intl.message(
      'Invite',
      name: 'invite',
      desc: '',
      args: [],
    );
  }

  /// `Single Invite`
  String get singleInvite {
    return Intl.message(
      'Single Invite',
      name: 'singleInvite',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Invite`
  String get multipleInvite {
    return Intl.message(
      'Multiple Invite',
      name: 'multipleInvite',
      desc: '',
      args: [],
    );
  }

  /// `Invites`
  String get inviteUsers {
    return Intl.message(
      'Invites',
      name: 'inviteUsers',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get Saturday {
    return Intl.message(
      'Saturday',
      name: 'Saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get Sunday {
    return Intl.message(
      'Sunday',
      name: 'Sunday',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get Monday {
    return Intl.message(
      'Monday',
      name: 'Monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get Tuesday {
    return Intl.message(
      'Tuesday',
      name: 'Tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get Wednesday {
    return Intl.message(
      'Wednesday',
      name: 'Wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get Thursday {
    return Intl.message(
      'Thursday',
      name: 'Thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get Friday {
    return Intl.message(
      'Friday',
      name: 'Friday',
      desc: '',
      args: [],
    );
  }

  /// `From Time`
  String get fromTime {
    return Intl.message(
      'From Time',
      name: 'fromTime',
      desc: '',
      args: [],
    );
  }

  /// `To Time`
  String get toTime {
    return Intl.message(
      'To Time',
      name: 'toTime',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `General Posts`
  String get generalPosts {
    return Intl.message(
      'General Posts',
      name: 'generalPosts',
      desc: '',
      args: [],
    );
  }

  /// `Password Not Match`
  String get passwordNotMatch {
    return Intl.message(
      'Password Not Match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Pick Location`
  String get pickLocation {
    return Intl.message(
      'Pick Location',
      name: 'pickLocation',
      desc: '',
      args: [],
    );
  }

  /// `Tap To Pick Location`
  String get tapToPickLocation {
    return Intl.message(
      'Tap To Pick Location',
      name: 'tapToPickLocation',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Select To Continue`
  String get selectToContinue {
    return Intl.message(
      'Select To Continue',
      name: 'selectToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get upgrade {
    return Intl.message(
      'Upgrade',
      name: 'upgrade',
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

  /// `Upgrade To Store`
  String get upgradeToStore {
    return Intl.message(
      'Upgrade To Store',
      name: 'upgradeToStore',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Valid Until`
  String get validUntil {
    return Intl.message(
      'Valid Until',
      name: 'validUntil',
      desc: '',
      args: [],
    );
  }

  /// `Until`
  String get until {
    return Intl.message(
      'Until',
      name: 'until',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get plan {
    return Intl.message(
      'Plan',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  /// `POSTS`
  String get posts {
    return Intl.message(
      'POSTS',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Edit To Continue`
  String get editToContinue {
    return Intl.message(
      'Edit To Continue',
      name: 'editToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Store Account`
  String get storeAccount {
    return Intl.message(
      'Store Account',
      name: 'storeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `You Have To Select {time} For {day}`
  String youHaveToSelectTimeForDay(Object time, Object day) {
    return Intl.message(
      'You Have To Select $time For $day',
      name: 'youHaveToSelectTimeForDay',
      desc: '',
      args: [time, day],
    );
  }

  /// `You Have To Select At Least One Working Time`
  String get youHaveToSelectAtLeastOneWorkingTime {
    return Intl.message(
      'You Have To Select At Least One Working Time',
      name: 'youHaveToSelectAtLeastOneWorkingTime',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Pickup`
  String get pickup {
    return Intl.message(
      'Pickup',
      name: 'pickup',
      desc: '',
      args: [],
    );
  }

  /// `Specific Order Date`
  String get specificOrderDate {
    return Intl.message(
      'Specific Order Date',
      name: 'specificOrderDate',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message(
      'Add To Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `View Cart`
  String get viewCart {
    return Intl.message(
      'View Cart',
      name: 'viewCart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Wallet`
  String get rechargeWallet {
    return Intl.message(
      'Recharge Wallet',
      name: 'rechargeWallet',
      desc: '',
      args: [],
    );
  }

  /// `There is not enough balance`
  String get noEnoughBalance {
    return Intl.message(
      'There is not enough balance',
      name: 'noEnoughBalance',
      desc: '',
      args: [],
    );
  }

  /// `Continue As`
  String get continueAs {
    return Intl.message(
      'Continue As',
      name: 'continueAs',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `You have to sign in first`
  String get youHaveToSignInFirst {
    return Intl.message(
      'You have to sign in first',
      name: 'youHaveToSignInFirst',
      desc: '',
      args: [],
    );
  }

  /// `One Time Stock`
  String get oneTimeStock {
    return Intl.message(
      'One Time Stock',
      name: 'oneTimeStock',
      desc: '',
      args: [],
    );
  }

  /// `Daily Stock Schedule`
  String get dailyStockSchedule {
    return Intl.message(
      'Daily Stock Schedule',
      name: 'dailyStockSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Write Comment`
  String get writeComment {
    return Intl.message(
      'Write Comment',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Write Review`
  String get writeReview {
    return Intl.message(
      'Write Review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews To Show`
  String get noReviewsToShow {
    return Intl.message(
      'No Reviews To Show',
      name: 'noReviewsToShow',
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

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `You Must Fill Phone Or Email To Continue`
  String get youMustFillPhoneOrEmailToContinue {
    return Intl.message(
      'You Must Fill Phone Or Email To Continue',
      name: 'youMustFillPhoneOrEmailToContinue',
      desc: '',
      args: [],
    );
  }

  /// `EQUITY`
  String get equity {
    return Intl.message(
      'EQUITY',
      name: 'equity',
      desc: '',
      args: [],
    );
  }

  /// `TAG UP`
  String get tagUp {
    return Intl.message(
      'TAG UP',
      name: 'tagUp',
      desc: '',
      args: [],
    );
  }

  /// `TAGGING`
  String get uTagging {
    return Intl.message(
      'TAGGING',
      name: 'uTagging',
      desc: '',
      args: [],
    );
  }

  /// `TAGGING U`
  String get taggingU {
    return Intl.message(
      'TAGGING U',
      name: 'taggingU',
      desc: '',
      args: [],
    );
  }

  /// `TAGGERS`
  String get taggers {
    return Intl.message(
      'TAGGERS',
      name: 'taggers',
      desc: '',
      args: [],
    );
  }

  /// `FRIENDS`
  String get taggingUp {
    return Intl.message(
      'FRIENDS',
      name: 'taggingUp',
      desc: '',
      args: [],
    );
  }

  /// `TAG UP`
  String get tagUpHim {
    return Intl.message(
      'TAG UP',
      name: 'tagUpHim',
      desc: '',
      args: [],
    );
  }

  /// `Use Current Location`
  String get useCurrentLocation {
    return Intl.message(
      'Use Current Location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Kids`
  String get kids {
    return Intl.message(
      'Kids',
      name: 'kids',
      desc: '',
      args: [],
    );
  }

  /// `Kids Mode`
  String get kidsMode {
    return Intl.message(
      'Kids Mode',
      name: 'kidsMode',
      desc: '',
      args: [],
    );
  }

  /// `Items Price`
  String get itemsPrice {
    return Intl.message(
      'Items Price',
      name: 'itemsPrice',
      desc: '',
      args: [],
    );
  }

  /// `Price After Discount`
  String get priceAfterDiscount {
    return Intl.message(
      'Price After Discount',
      name: 'priceAfterDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Receiving Method`
  String get receivingMethod {
    return Intl.message(
      'Receiving Method',
      name: 'receivingMethod',
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

  /// `Order Date`
  String get orderDate {
    return Intl.message(
      'Order Date',
      name: 'orderDate',
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

  /// `No Posts To Display`
  String get NoPostsToDisplay {
    return Intl.message(
      'No Posts To Display',
      name: 'NoPostsToDisplay',
      desc: '',
      args: [],
    );
  }

  /// `No Comments To Display`
  String get NoCommentsToDisplay {
    return Intl.message(
      'No Comments To Display',
      name: 'NoCommentsToDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Cash On Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash On Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Payment`
  String get walletPayment {
    return Intl.message(
      'Wallet Payment',
      name: 'walletPayment',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Since`
  String get since {
    return Intl.message(
      'Since',
      name: 'since',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `add credit card`
  String get addCreditCard {
    return Intl.message(
      'Add Card',
      name: 'addCreditCard',
      desc: '',
      args: [],
    );
  }

  /// `How Much You Want To Recharge?`
  String get howMuchYouWantToRecharge {
    return Intl.message(
      'How Much You Want To Recharge?',
      name: 'howMuchYouWantToRecharge',
      desc: '',
      args: [],
    );
  }

  /// `leftUpPay?`
  String get leftUpPay {
    return Intl.message(
      'LEFTUP PAY',
      name: 'leftUpPay',
      desc: '',
      args: [],
    );
  }

  /// `enterLiftUpPay14DigitCode?`
  String get enterLiftUpPay14DigitCode {
    return Intl.message(
      'Enter Lift Up Pay 14 Digit Code',
      name: 'enterLiftUpPay14DigitCode',
      desc: '',
      args: [],
    );
  }

  /// `enterAmount?`
  String get enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `topUpUsingBankCard`
  String get topUpUsingBankCard {
    return Intl.message(
      'Top up using bank card',
      name: 'topUpUsingBankCard',
      desc: '',
      args: [],
    );
  }

  /// `cardHolderName?`
  String get cardHolderName {
    return Intl.message(
      'Card Holder Name',
      name: 'cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `cardNumber?`
  String get cardNumber {
    return Intl.message(
      'Card Number',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `expirtDate?`
  String get expirtDate {
    return Intl.message(
      'Expiry Date (MM/YYYY)',
      name: 'expirtDate',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `Post Details`
  String get postDetails {
    return Intl.message(
      'Post Details',
      name: 'postDetails',
      desc: '',
      args: [],
    );
  }

  /// `REVIEWS`
  String get reviews {
    return Intl.message(
      'REVIEWS',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `User Name Is Not Valid`
  String get userNameIsNotValid {
    return Intl.message(
      'User Name Is Not Valid',
      name: 'userNameIsNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get contactNumber {
    return Intl.message(
      'Contact Number',
      name: 'contactNumber',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
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

  /// `Blocked Users`
  String get blockedUsers {
    return Intl.message(
      'Blocked Users',
      name: 'blockedUsers',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message(
      'Block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Un Block`
  String get unBlock {
    return Intl.message(
      'Un Block',
      name: 'unBlock',
      desc: '',
      args: [],
    );
  }

  /// `Post Not Available`
  String get postNotAvailable {
    return Intl.message(
      'Post Not Available',
      name: 'postNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure?`
  String get areYouSure {
    return Intl.message(
      'Are You Sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `No data to display`
  String get no_data_to_display {
    return Intl.message(
      'No data to display',
      name: 'no_data_to_display',
      desc: '',
      args: [],
    );
  }

  /// `Hashtags Must Be In Correct Form`
  String get hashtagsMustBeInCorrectForm {
    return Intl.message(
      'Hashtags Must Be In Correct Form',
      name: 'hashtagsMustBeInCorrectForm',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account for ever?`
  String get areYouSureDeleteAccount {
    return Intl.message(
      'Are you sure you want to delete your account for ever?',
      name: 'areYouSureDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `I Don't Have Invitation Code?`
  String get doNotHaveInvitation {
    return Intl.message(
      'I Don\'t Have Invitation Code?',
      name: 'doNotHaveInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Thank You For Reporting`
  String get thankYouForReporting {
    return Intl.message(
      'Thank You For Reporting',
      name: 'thankYouForReporting',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Term of use`
  String get termOfUse {
    return Intl.message(
      'Term of use',
      name: 'termOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Un Save`
  String get unSave {
    return Intl.message(
      'Un Save',
      name: 'unSave',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message(
      'Saved',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Time Must Be After {time}`
  String timeMustBeAfter(Object time) {
    return Intl.message(
      'Time Must Be After $time',
      name: 'timeMustBeAfter',
      desc: '',
      args: [time],
    );
  }

  /// `Time Must Be Before {time}`
  String timeMustBeBefore(Object time) {
    return Intl.message(
      'Time Must Be Before $time',
      name: 'timeMustBeBefore',
      desc: '',
      args: [time],
    );
  }

  /// `Write details about your post`
  String get writeDetailsAboutYourPost {
    return Intl.message(
      'Write details about your post',
      name: 'writeDetailsAboutYourPost',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details`
  String get paymentDetails {
    return Intl.message(
      'Payment Details',
      name: 'paymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Send Invitation Code`
  String get getInvitationCode {
    return Intl.message(
      'Send Invitation Code',
      name: 'getInvitationCode',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `We send code to`
  String get weSendCodeTo {
    return Intl.message(
      'We send code to',
      name: 'weSendCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Selected Currency`
  String get selectedCurrency {
    return Intl.message(
      'Selected Currency',
      name: 'selectedCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `View {count} replies`
  String viewReplies(Object count) {
    return Intl.message(
      'View $count replies',
      name: 'viewReplies',
      desc: '',
      args: [count],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Hide Replies`
  String get hideReplies {
    return Intl.message(
      'Hide Replies',
      name: 'hideReplies',
      desc: '',
      args: [],
    );
  }

  /// `Reply to {name}`
  String replyTo(Object name) {
    return Intl.message(
      'Reply to $name',
      name: 'replyTo',
      desc: '',
      args: [name],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Default Currency`
  String get defaultCurrency {
    return Intl.message(
      'Default Currency',
      name: 'defaultCurrency',
      desc: '',
      args: [],
    );
  }

  /// `You Will Lose Post Info that You  Entered`
  String get youWillLosePostInfoThatYouEntered {
    return Intl.message(
      'You Will Lose Post Info that You  Entered',
      name: 'youWillLosePostInfoThatYouEntered',
      desc: '',
      args: [],
    );
  }

  /// `Post Social`
  String get postSocial {
    return Intl.message(
      'Post Social',
      name: 'postSocial',
      desc: '',
      args: [],
    );
  }

  /// `Post Product`
  String get postProduct {
    return Intl.message(
      'Post Product',
      name: 'postProduct',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled`
  String get locationServicesDisabled {
    return Intl.message(
      'Location services are disabled',
      name: 'locationServicesDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get enable {
    return Intl.message(
      'Enable',
      name: 'enable',
      desc: '',
      args: [],
    );
  }

  /// `Play List`
  String get playList {
    return Intl.message(
      'Play List',
      name: 'playList',
      desc: '',
      args: [],
    );
  }

  /// `Not Now`
  String get notNow {
    return Intl.message(
      'Not Now',
      name: 'notNow',
      desc: '',
      args: [],
    );
  }

  /// `Enter your invitation code below to continue or tap I don't have invitation code to register without invitation code`
  String get invitationText {
    return Intl.message(
      'Enter your invitation code below to continue or tap I don\'t have invitation code to register without invitation code',
      name: 'invitationText',
      desc: '',
      args: [],
    );
  }

  /// `What's your email?`
  String get whatYourEmail {
    return Intl.message(
      'What\'s your email?',
      name: 'whatYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email where you can be contacted, No one will see this on your profile.`
  String get emailText {
    return Intl.message(
      'Enter the email where you can be contacted, No one will see this on your profile.',
      name: 'emailText',
      desc: '',
      args: [],
    );
  }

  /// `What's your mobile?`
  String get whatYourMobile {
    return Intl.message(
      'What\'s your mobile?',
      name: 'whatYourMobile',
      desc: '',
      args: [],
    );
  }

  /// `Enter the mobile where you can be contacted, No one will see this on your profile.`
  String get mobileText {
    return Intl.message(
      'Enter the mobile where you can be contacted, No one will see this on your profile.',
      name: 'mobileText',
      desc: '',
      args: [],
    );
  }

  /// `Enter the confirmation code`
  String get enterConfirmationCode {
    return Intl.message(
      'Enter the confirmation code',
      name: 'enterConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `To confirm your account, enter 4 digit code we sent to`
  String get confirmationText {
    return Intl.message(
      'To confirm your account, enter 4 digit code we sent to',
      name: 'confirmationText',
      desc: '',
      args: [],
    );
  }

  /// `Create a password`
  String get createPassword {
    return Intl.message(
      'Create a password',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create a password with at least 6 letters include capital letters, small letters, numbers and symbols example Ee174#`
  String get createPasswordText {
    return Intl.message(
      'Create a password with at least 6 letters include capital letters, small letters, numbers and symbols example Ee174#',
      name: 'createPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `What's your birthday?`
  String get whatYourBirthday {
    return Intl.message(
      'What\'s your birthday?',
      name: 'whatYourBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Use your own birthday, even if this account is for a business, no one will see this unless you share it,`
  String get birthdayText {
    return Intl.message(
      'Use your own birthday, even if this account is for a business, no one will see this unless you share it,',
      name: 'birthdayText',
      desc: '',
      args: [],
    );
  }

  /// `What's your Name?`
  String get whatYourName {
    return Intl.message(
      'What\'s your Name?',
      name: 'whatYourName',
      desc: '',
      args: [],
    );
  }

  /// `Write Your Full Name`
  String get nameText {
    return Intl.message(
      'Write Your Full Name',
      name: 'nameText',
      desc: '',
      args: [],
    );
  }

  /// `What's your Nationality?`
  String get whatYourNationality {
    return Intl.message(
      'What\'s your Nationality?',
      name: 'whatYourNationality',
      desc: '',
      args: [],
    );
  }

  /// `Select your nationality`
  String get nationalityText {
    return Intl.message(
      'Select your nationality',
      name: 'nationalityText',
      desc: '',
      args: [],
    );
  }

  /// `The application uses the gender to display the unique account color for specific genders`
  String get genderText {
    return Intl.message(
      'The application uses the gender to display the unique account color for specific genders',
      name: 'genderText',
      desc: '',
      args: [],
    );
  }

  /// `Select your gender`
  String get selectYourGender {
    return Intl.message(
      'Select your gender',
      name: 'selectYourGender',
      desc: '',
      args: [],
    );
  }

  /// `Add a username or use our suggestion. You can change this at any time`
  String get userNmeText {
    return Intl.message(
      'Add a username or use our suggestion. You can change this at any time',
      name: 'userNmeText',
      desc: '',
      args: [],
    );
  }

  /// `Create a username`
  String get createUsername {
    return Intl.message(
      'Create a username',
      name: 'createUsername',
      desc: '',
      args: [],
    );
  }

  /// `Agree to EZENESS's terms and conditions`
  String get agreeTermsConditions {
    return Intl.message(
      'Agree to EZENESS\'s terms and conditions',
      name: 'agreeTermsConditions',
      desc: '',
      args: [],
    );
  }

  /// `People who use our services may have uploaded your contact information to EZENESS\nBy tapping I agree, you agree to create an account with EZENESS`
  String get termsConditionsText {
    return Intl.message(
      'People who use our services may have uploaded your contact information to EZENESS\nBy tapping I agree, you agree to create an account with EZENESS',
      name: 'termsConditionsText',
      desc: '',
      args: [],
    );
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Please Enable Location Service`
  String get pleaseEnableLocationService {
    return Intl.message(
      'Please Enable Location Service',
      name: 'pleaseEnableLocationService',
      desc: '',
      args: [],
    );
  }

  /// `You currently have disabled location service for this device ,please enable location service in setting`
  String get locationServiceText {
    return Intl.message(
      'You currently have disabled location service for this device ,please enable location service in setting',
      name: 'locationServiceText',
      desc: '',
      args: [],
    );
  }

  /// `Location Permanently Denied`
  String get locationPermanentlyDenied {
    return Intl.message(
      'Location Permanently Denied',
      name: 'locationPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied,please Go setting to allow`
  String get locationPermanentlyDeniedText {
    return Intl.message(
      'Location permissions are permanently denied,please Go setting to allow',
      name: 'locationPermanentlyDeniedText',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get shop {
    return Intl.message(
      'Shop',
      name: 'shop',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explore {
    return Intl.message(
      'Explore',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Explore Ezeness`
  String get exploreEzeness {
    return Intl.message(
      'Explore Ezeness',
      name: 'exploreEzeness',
      desc: '',
      args: [],
    );
  }

  /// `Tap To Select`
  String get tapToSelect {
    return Intl.message(
      'Tap To Select',
      name: 'tapToSelect',
      desc: '',
      args: [],
    );
  }

  /// `Gold Coins Dashboard`
  String get goldCoinsDashboard {
    return Intl.message(
      'Gold Coins Dashboard',
      name: 'goldCoinsDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Track your gold coins here`
  String get trackYourGoldCoinsHere {
    return Intl.message(
      'Track your gold coins here',
      name: 'trackYourGoldCoinsHere',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Gold Coins`
  String get goldCoins {
    return Intl.message(
      'Gold Coins',
      name: 'goldCoins',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `What are Gold Coins and how does it work? `
  String get whatIsLiftUpGoldCoins {
    return Intl.message(
      'What are Gold Coins and how does it work? ',
      name: 'whatIsLiftUpGoldCoins',
      desc: '',
      args: [],
    );
  }

  /// `Each Lift Up Coins is equal to {value} 24K Gold`
  String eachLiftUpCoinsIsEqualTo(Object value) {
    return Intl.message(
      'Each Lift Up Coins is equal to $value 24K Gold',
      name: 'eachLiftUpCoinsIsEqualTo',
      desc: '',
      args: [value],
    );
  }

  /// `How to make Lift Up coins?`
  String get howToMakeLiftUpCoins {
    return Intl.message(
      'How to make Lift Up coins?',
      name: 'howToMakeLiftUpCoins',
      desc: '',
      args: [],
    );
  }

  /// `Turn On Location`
  String get turnOnLocation {
    return Intl.message(
      'Turn On Location',
      name: 'turnOnLocation',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up like rate`
  String get liftUpLikeRate {
    return Intl.message(
      'Lift Up like rate',
      name: 'liftUpLikeRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up comment rate`
  String get liftUpCommentRate {
    return Intl.message(
      'Lift Up comment rate',
      name: 'liftUpCommentRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up tag users rate`
  String get liftUpTagUsersRate {
    return Intl.message(
      'Lift Up tag users rate',
      name: 'liftUpTagUsersRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up tag posts rate`
  String get liftUpTagPostsRate {
    return Intl.message(
      'Lift Up tag posts rate',
      name: 'liftUpTagPostsRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up invite rate`
  String get liftUpInviteRate {
    return Intl.message(
      'Lift Up invite rate',
      name: 'liftUpInviteRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up social post rate`
  String get liftUpSocialPostRate {
    return Intl.message(
      'Lift Up social post rate',
      name: 'liftUpSocialPostRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up business post rate`
  String get liftUpBusinessPostRate {
    return Intl.message(
      'Lift Up business post rate',
      name: 'liftUpBusinessPostRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up VIP post rate`
  String get liftUpVipPostRate {
    return Intl.message(
      'Lift Up VIP post rate',
      name: 'liftUpVipPostRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up kids social post rate`
  String get liftUpKidsSocialPostRate {
    return Intl.message(
      'Lift Up kids social post rate',
      name: 'liftUpKidsSocialPostRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up kids business post rate`
  String get liftUpKidsBusinessPostRate {
    return Intl.message(
      'Lift Up kids business post rate',
      name: 'liftUpKidsBusinessPostRate',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up coin rate`
  String get liftUpCoinRate {
    return Intl.message(
      'Lift Up coin rate',
      name: 'liftUpCoinRate',
      desc: '',
      args: [],
    );
  }

  /// `Gold gram price`
  String get goldGramPrice {
    return Intl.message(
      'Gold gram price',
      name: 'goldGramPrice',
      desc: '',
      args: [],
    );
  }

  /// `Lift up`
  String get liftup {
    return Intl.message(
      'Lift up',
      name: 'liftup',
      desc: '',
      args: [],
    );
  }

  /// `Convert`
  String get convert {
    return Intl.message(
      'Convert',
      name: 'convert',
      desc: '',
      args: [],
    );
  }

  /// `Wallet balance`
  String get walletBalance {
    return Intl.message(
      'Wallet balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Coins Conversion`
  String get coinsConversion {
    return Intl.message(
      'Coins Conversion',
      name: 'coinsConversion',
      desc: '',
      args: [],
    );
  }

  /// `Total Coins`
  String get totalCoins {
    return Intl.message(
      'Total Coins',
      name: 'totalCoins',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Rate`
  String get exchangeRate {
    return Intl.message(
      'Exchange Rate',
      name: 'exchangeRate',
      desc: '',
      args: [],
    );
  }

  /// `VAT`
  String get vat {
    return Intl.message(
      'VAT',
      name: 'vat',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Charges`
  String get transferCharges {
    return Intl.message(
      'Transfer Charges',
      name: 'transferCharges',
      desc: '',
      args: [],
    );
  }

  /// `Handling`
  String get handling {
    return Intl.message(
      'Handling',
      name: 'handling',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Coins`
  String get coins {
    return Intl.message(
      'Coins',
      name: 'coins',
      desc: '',
      args: [],
    );
  }

  /// `Coins converted successfully`
  String get coinsConvertedSuccessfully {
    return Intl.message(
      'Coins converted successfully',
      name: 'coinsConvertedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Long press to un like`
  String get unlikeText {
    return Intl.message(
      'Long press to un like',
      name: 'unlikeText',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get othersLikesOnMyPosts {
    return Intl.message(
      'Likes',
      name: 'othersLikesOnMyPosts',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get othersCommentOnMyPosts {
    return Intl.message(
      'Comment',
      name: 'othersCommentOnMyPosts',
      desc: '',
      args: [],
    );
  }

  /// `Tag Up My Profile`
  String get othersTagUpMyProfile {
    return Intl.message(
      'Tag Up My Profile',
      name: 'othersTagUpMyProfile',
      desc: '',
      args: [],
    );
  }

  /// `Tag Up My Posts`
  String get othersTagUpMyPosts {
    return Intl.message(
      'Tag Up My Posts',
      name: 'othersTagUpMyPosts',
      desc: '',
      args: [],
    );
  }

  /// `Invitations`
  String get iInviteOtherPeople {
    return Intl.message(
      'Invitations',
      name: 'iInviteOtherPeople',
      desc: '',
      args: [],
    );
  }

  /// `Add Social Posts`
  String get addSocialPost {
    return Intl.message(
      'Add Social Posts',
      name: 'addSocialPost',
      desc: '',
      args: [],
    );
  }

  /// `Add Product Posts`
  String get addProductPost {
    return Intl.message(
      'Add Product Posts',
      name: 'addProductPost',
      desc: '',
      args: [],
    );
  }

  /// `Add VIP Posts`
  String get addVipPost {
    return Intl.message(
      'Add VIP Posts',
      name: 'addVipPost',
      desc: '',
      args: [],
    );
  }

  /// `Add Kids Social Posts`
  String get addKidsSocialPost {
    return Intl.message(
      'Add Kids Social Posts',
      name: 'addKidsSocialPost',
      desc: '',
      args: [],
    );
  }

  /// `Add Kids Product Posts`
  String get addKidsProductPost {
    return Intl.message(
      'Add Kids Product Posts',
      name: 'addKidsProductPost',
      desc: '',
      args: [],
    );
  }

  /// `Drive up`
  String get driveUp {
    return Intl.message(
      'Drive up',
      name: 'driveUp',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get min {
    return Intl.message(
      'Min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `KM`
  String get km {
    return Intl.message(
      'KM',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `Gold`
  String get gold {
    return Intl.message(
      'Gold',
      name: 'gold',
      desc: '',
      args: [],
    );
  }

  /// `Buy Gold`
  String get buyGold {
    return Intl.message(
      'Buy Gold',
      name: 'buyGold',
      desc: '',
      args: [],
    );
  }

  /// `BUSINESS ACCOUNT`
  String get businessAccount {
    return Intl.message(
      'BUSINESS ACCOUNT',
      name: 'businessAccount',
      desc: '',
      args: [],
    );
  }

  /// `Regular Account`
  String get regularAccount {
    return Intl.message(
      'Regular Account',
      name: 'regularAccount',
      desc: '',
      args: [],
    );
  }

  /// `Social Posts`
  String get socialPosts {
    return Intl.message(
      'Social Posts',
      name: 'socialPosts',
      desc: '',
      args: [],
    );
  }

  /// `Search Post`
  String get searchPost {
    return Intl.message(
      'Search Post',
      name: 'searchPost',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get social {
    return Intl.message(
      'Social',
      name: 'social',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get service {
    return Intl.message(
      'Service',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Continue With Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue With Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue With Apple`
  String get continueWithApple {
    return Intl.message(
      'Continue With Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Select Plan`
  String get selectPlan {
    return Intl.message(
      'Select Plan',
      name: 'selectPlan',
      desc: '',
      args: [],
    );
  }

  /// `Selling online \nwas never so easy`
  String get sellingOnline {
    return Intl.message(
      'Selling online \nwas never so easy',
      name: 'sellingOnline',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up your business by boosting your products as banner on app, where users can interact with you freely`
  String get liftUpYourBusiness {
    return Intl.message(
      'Lift Up your business by boosting your products as banner on app, where users can interact with you freely',
      name: 'liftUpYourBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message(
      'Item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Ad & Boost Plans`
  String get adBoostPlans {
    return Intl.message(
      'Ad & Boost Plans',
      name: 'adBoostPlans',
      desc: '',
      args: [],
    );
  }

  /// `BOOST AS POST`
  String get boostAsPost {
    return Intl.message(
      'BOOST AS POST',
      name: 'boostAsPost',
      desc: '',
      args: [],
    );
  }

  /// `BOOST AS BANNER`
  String get boostAsBanner {
    return Intl.message(
      'BOOST AS BANNER',
      name: 'boostAsBanner',
      desc: '',
      args: [],
    );
  }

  /// `People who use our services may have uploaded your contact information to EZENESS. By tapping I agree, you agree to create an account with EZENESS`
  String get peopleUseServices {
    return Intl.message(
      'People who use our services may have uploaded your contact information to EZENESS. By tapping I agree, you agree to create an account with EZENESS',
      name: 'peopleUseServices',
      desc: '',
      args: [],
    );
  }

  /// `EZENESS's Terms`
  String get terms {
    return Intl.message(
      'EZENESS\'s Terms',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Banner preview`
  String get bannerPreview {
    return Intl.message(
      'Banner preview',
      name: 'bannerPreview',
      desc: '',
      args: [],
    );
  }

  /// `Note: Incase of long queues the time to place banner live might be affected`
  String get noteLongQueues {
    return Intl.message(
      'Note: Incase of long queues the time to place banner live might be affected',
      name: 'noteLongQueues',
      desc: '',
      args: [],
    );
  }

  /// `Banners will be added here`
  String get bannersAddedHere {
    return Intl.message(
      'Banners will be added here',
      name: 'bannersAddedHere',
      desc: '',
      args: [],
    );
  }

  /// `Banner Boost Payment`
  String get bannerBoostPayment {
    return Intl.message(
      'Banner Boost Payment',
      name: 'bannerBoostPayment',
      desc: '',
      args: [],
    );
  }

  /// `Post Boost Payment`
  String get postBoostPayment {
    return Intl.message(
      'Post Boost Payment',
      name: 'postBoostPayment',
      desc: '',
      args: [],
    );
  }

  /// `Sub total`
  String get subTotal {
    return Intl.message(
      'Sub total',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Boost Requested successfully`
  String get boostRequestedSuccessfully {
    return Intl.message(
      'Boost Requested successfully',
      name: 'boostRequestedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `AED`
  String get aed {
    return Intl.message(
      'AED',
      name: 'aed',
      desc: '',
      args: [],
    );
  }

  /// `Banner Image`
  String get bannerImage {
    return Intl.message(
      'Banner Image',
      name: 'bannerImage',
      desc: '',
      args: [],
    );
  }

  /// `Month live`
  String get monthLive {
    return Intl.message(
      'Month live',
      name: 'monthLive',
      desc: '',
      args: [],
    );
  }

  /// `Days live`
  String get daysLive {
    return Intl.message(
      'Days live',
      name: 'daysLive',
      desc: '',
      args: [],
    );
  }

  /// `I Agree`
  String get iAgree {
    return Intl.message(
      'I Agree',
      name: 'iAgree',
      desc: '',
      args: [],
    );
  }

  /// `Search and select your product to link it to the banner`
  String get searchAndSelectProduct {
    return Intl.message(
      'Search and select your product to link it to the banner',
      name: 'searchAndSelectProduct',
      desc: '',
      args: [],
    );
  }

  /// `will be available on:`
  String get bannerAvailableOn {
    return Intl.message(
      'will be available on:',
      name: 'bannerAvailableOn',
      desc: '',
      args: [],
    );
  }

  /// `No posts are available to choose from`
  String get noPostsAvailable {
    return Intl.message(
      'No posts are available to choose from',
      name: 'noPostsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add Pro Invite`
  String get addProInvite {
    return Intl.message(
      'Add Pro Invite',
      name: 'addProInvite',
      desc: '',
      args: [],
    );
  }

  /// `New Pro Code`
  String get newProCode {
    return Intl.message(
      'New Pro Code',
      name: 'newProCode',
      desc: '',
      args: [],
    );
  }

  /// `Pro Invites`
  String get proInvites {
    return Intl.message(
      'Pro Invites',
      name: 'proInvites',
      desc: '',
      args: [],
    );
  }

  /// `Add Special Invite`
  String get addSpecialInvite {
    return Intl.message(
      'Add Special Invite',
      name: 'addSpecialInvite',
      desc: '',
      args: [],
    );
  }

  /// `Special Invites`
  String get specialInvites {
    return Intl.message(
      'Special Invites',
      name: 'specialInvites',
      desc: '',
      args: [],
    );
  }

  /// `Pro Invite`
  String get proInvite {
    return Intl.message(
      'Pro Invite',
      name: 'proInvite',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `Total Joined`
  String get totalJoined {
    return Intl.message(
      'Total Joined',
      name: 'totalJoined',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Codes Generated`
  String get codesGenerated {
    return Intl.message(
      'Codes Generated',
      name: 'codesGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Generated Date`
  String get generatedDate {
    return Intl.message(
      'Generated Date',
      name: 'generatedDate',
      desc: '',
      args: [],
    );
  }

  /// `Invited Name:`
  String get invitedName {
    return Intl.message(
      'Invited Name:',
      name: 'invitedName',
      desc: '',
      args: [],
    );
  }

  /// `Invite your friends and family and get Lift Up gold coins`
  String get inviteFriendsAndFamily {
    return Intl.message(
      'Invite your friends and family and get Lift Up gold coins',
      name: 'inviteFriendsAndFamily',
      desc: '',
      args: [],
    );
  }

  /// `Code Generated on`
  String get codeGeneratedOn {
    return Intl.message(
      'Code Generated on',
      name: 'codeGeneratedOn',
      desc: '',
      args: [],
    );
  }

  /// `Can you accept my invitation so that I can get a gold coin?\nI'm claiming free gold 24K`
  String get acceptInvitation {
    return Intl.message(
      'Can you accept my invitation so that I can get a gold coin?\nI\'m claiming free gold 24K',
      name: 'acceptInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Your Code Is`
  String get yourCodeIs {
    return Intl.message(
      'Your Code Is',
      name: 'yourCodeIs',
      desc: '',
      args: [],
    );
  }

  /// `Click the link to join Ezeness app`
  String get clickLinkToJoinApp {
    return Intl.message(
      'Click the link to join Ezeness app',
      name: 'clickLinkToJoinApp',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Copied to Clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to Clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Shop Page`
  String get shopPage {
    return Intl.message(
      'Shop Page',
      name: 'shopPage',
      desc: '',
      args: [],
    );
  }

  /// `Social Page`
  String get socialPage {
    return Intl.message(
      'Social Page',
      name: 'socialPage',
      desc: '',
      args: [],
    );
  }

  /// `No business post, Add some products to link with banner`
  String get noBusinessPost {
    return Intl.message(
      'No business post, Add some products to link with banner',
      name: 'noBusinessPost',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message(
      'Nationality',
      name: 'nationality',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `No Products To Display`
  String get NoProductsToDisplay {
    return Intl.message(
      'No Products To Display',
      name: 'NoProductsToDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to {action} this code?`
  String confirmationMessage(Object action) {
    return Intl.message(
      'Are you sure you want to $action this code?',
      name: 'confirmationMessage',
      desc: '',
      args: [action],
    );
  }

  /// `disable`
  String get disable {
    return Intl.message(
      'disable',
      name: 'disable',
      desc: '',
      args: [],
    );
  }

  /// `Stop the invites?`
  String get stopInvites {
    return Intl.message(
      'Stop the invites?',
      name: 'stopInvites',
      desc: '',
      args: [],
    );
  }

  /// `Continue the invites?`
  String get continueInvites {
    return Intl.message(
      'Continue the invites?',
      name: 'continueInvites',
      desc: '',
      args: [],
    );
  }

  /// `Select Gender`
  String get selectGender {
    return Intl.message(
      'Select Gender',
      name: 'selectGender',
      desc: '',
      args: [],
    );
  }

  /// `Post as Kids Content`
  String get postAsKidsContent {
    return Intl.message(
      'Post as Kids Content',
      name: 'postAsKidsContent',
      desc: '',
      args: [],
    );
  }

  /// `Post as Islamic Content`
  String get postAsIslamicContent {
    return Intl.message(
      'Post as Islamic Content',
      name: 'postAsIslamicContent',
      desc: '',
      args: [],
    );
  }

  /// `Add your caption and #hashtags here`
  String get addCaptionAndHashtags {
    return Intl.message(
      'Add your caption and #hashtags here',
      name: 'addCaptionAndHashtags',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get payments {
    return Intl.message(
      'Payments',
      name: 'payments',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message(
      'Requests',
      name: 'requests',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get activities {
    return Intl.message(
      'Activities',
      name: 'activities',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get seeMore {
    return Intl.message(
      'More',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `See More`
  String get seeMoreI {
    return Intl.message(
      'See More',
      name: 'seeMoreI',
      desc: '',
      args: [],
    );
  }

  /// `For You`
  String get forYou {
    return Intl.message(
      'For You',
      name: 'forYou',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get trending {
    return Intl.message(
      'Trending',
      name: 'trending',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Connect people and stores near you`
  String get getUserLocationTitle {
    return Intl.message(
      'Connect people and stores near you',
      name: 'getUserLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `By allowing location access, you can find people and stores near you`
  String get getUserLocationText {
    return Intl.message(
      'By allowing location access, you can find people and stores near you',
      name: 'getUserLocationText',
      desc: '',
      args: [],
    );
  }

  /// `Select From Map`
  String get selectFromMap {
    return Intl.message(
      'Select From Map',
      name: 'selectFromMap',
      desc: '',
      args: [],
    );
  }

  /// `Long press to Un Follow`
  String get longPressUnFollow {
    return Intl.message(
      'Long press to Un Follow',
      name: 'longPressUnFollow',
      desc: '',
      args: [],
    );
  }

  /// `Profiles`
  String get profiles {
    return Intl.message(
      'Profiles',
      name: 'profiles',
      desc: '',
      args: [],
    );
  }

  /// `The post is Liftted Up`
  String get postLifttedUp {
    return Intl.message(
      'The post is Liftted Up',
      name: 'postLifttedUp',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Pro Username`
  String get upgradeProUsername {
    return Intl.message(
      'Upgrade Pro Username',
      name: 'upgradeProUsername',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Shop Info`
  String get upgradeShopInfo {
    return Intl.message(
      'Upgrade Shop Info',
      name: 'upgradeShopInfo',
      desc: '',
      args: [],
    );
  }

  /// `Add something about yourself or your business, what you do and what you sell for a better interaction`
  String get addSomethingAboutYourself {
    return Intl.message(
      'Add something about yourself or your business, what you do and what you sell for a better interaction',
      name: 'addSomethingAboutYourself',
      desc: '',
      args: [],
    );
  }

  /// `Edit Bio`
  String get editBio {
    return Intl.message(
      'Edit Bio',
      name: 'editBio',
      desc: '',
      args: [],
    );
  }

  /// `Account Type`
  String get accountType {
    return Intl.message(
      'Account Type',
      name: 'accountType',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Account Type`
  String get upgradeAccountType {
    return Intl.message(
      'Upgrade Account Type',
      name: 'upgradeAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Verification Tag`
  String get verificationTag {
    return Intl.message(
      'Verification Tag',
      name: 'verificationTag',
      desc: '',
      args: [],
    );
  }

  /// `Get Top Profile Username`
  String get getTopProfileUsername {
    return Intl.message(
      'Get Top Profile Username',
      name: 'getTopProfileUsername',
      desc: '',
      args: [],
    );
  }

  /// `Invite & Get paid`
  String get inviteAndGetPaid {
    return Intl.message(
      'Invite & Get paid',
      name: 'inviteAndGetPaid',
      desc: '',
      args: [],
    );
  }

  /// `Make yourself identical and noticeable`
  String get makeYourselfIdentical {
    return Intl.message(
      'Make yourself identical and noticeable',
      name: 'makeYourselfIdentical',
      desc: '',
      args: [],
    );
  }

  /// `Select a verification and name reservation plan option that suits you, to enter the next level of ezeness life`
  String get selectVerificationPlan {
    return Intl.message(
      'Select a verification and name reservation plan option that suits you, to enter the next level of ezeness life',
      name: 'selectVerificationPlan',
      desc: '',
      args: [],
    );
  }

  /// `Select an online shop plan option that suits you, to enter the next level of ezeness life`
  String get selectShopPlan {
    return Intl.message(
      'Select an online shop plan option that suits you, to enter the next level of ezeness life',
      name: 'selectShopPlan',
      desc: '',
      args: [],
    );
  }

  /// `INDIVIDUAL STORE`
  String get individualStore {
    return Intl.message(
      'INDIVIDUAL STORE',
      name: 'individualStore',
      desc: '',
      args: [],
    );
  }

  /// `STANDARD BUSINESS`
  String get standardBusiness {
    return Intl.message(
      'STANDARD BUSINESS',
      name: 'standardBusiness',
      desc: '',
      args: [],
    );
  }

  /// `LICENSED PLAN`
  String get licensedPlan {
    return Intl.message(
      'LICENSED PLAN',
      name: 'licensedPlan',
      desc: '',
      args: [],
    );
  }

  /// `Get Tag`
  String get getTag {
    return Intl.message(
      'Get Tag',
      name: 'getTag',
      desc: '',
      args: [],
    );
  }

  /// `Create a username`
  String get createAUsername {
    return Intl.message(
      'Create a username',
      name: 'createAUsername',
      desc: '',
      args: [],
    );
  }

  /// `Add a username or use our suggestion. You can change this at any time`
  String get addUsernameDescription {
    return Intl.message(
      'Add a username or use our suggestion. You can change this at any time',
      name: 'addUsernameDescription',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to ezeness life`
  String get welcomeToEzenessLife {
    return Intl.message(
      'Welcome to ezeness life',
      name: 'welcomeToEzenessLife',
      desc: '',
      args: [],
    );
  }

  /// `The first entertaining social business media app`
  String get firstSocialBusinessMediaApp {
    return Intl.message(
      'The first entertaining social business media app',
      name: 'firstSocialBusinessMediaApp',
      desc: '',
      args: [],
    );
  }

  /// `ezeness creates opportunities for every individual and businesses, small retailers and service providers can now have full option social media + e-commerce features for free on a single platform`
  String get ezenessCreatesOpportunities {
    return Intl.message(
      'ezeness creates opportunities for every individual and businesses, small retailers and service providers can now have full option social media + e-commerce features for free on a single platform',
      name: 'ezenessCreatesOpportunities',
      desc: '',
      args: [],
    );
  }

  /// `So don't wait, open your business and start your income now`
  String get dontWaitOpenBusiness {
    return Intl.message(
      'So don\'t wait, open your business and start your income now',
      name: 'dontWaitOpenBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Log in / Signup`
  String get loginSignup {
    return Intl.message(
      'Log in / Signup',
      name: 'loginSignup',
      desc: '',
      args: [],
    );
  }

  /// `Select an online shop plan option that's suits you, to enter the next level of ezeness life`
  String get selectOnlineShopPlanOption {
    return Intl.message(
      'Select an online shop plan option that\'s suits you, to enter the next level of ezeness life',
      name: 'selectOnlineShopPlanOption',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Country`
  String get selectYourCountry {
    return Intl.message(
      'Select Your Country',
      name: 'selectYourCountry',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Authorization`
  String get authorization {
    return Intl.message(
      'Authorization',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Do You have invitation code?`
  String get doYouHaveInvitationCode {
    return Intl.message(
      'Do You have invitation code?',
      name: 'doYouHaveInvitationCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your invitation code below to continue or tap I don't have invitation code to register without invitation code`
  String get enterYourInvitationCode {
    return Intl.message(
      'Enter your invitation code below to continue or tap I don\'t have invitation code to register without invitation code',
      name: 'enterYourInvitationCode',
      desc: '',
      args: [],
    );
  }

  /// `Add pro invite group`
  String get addProInviteGroup {
    return Intl.message(
      'Add pro invite group',
      name: 'addProInviteGroup',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Connect to people around you`
  String get tapToConnect {
    return Intl.message(
      'Tap to Connect to people around you',
      name: 'tapToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Kids Lock`
  String get kidsLock {
    return Intl.message(
      'Kids Lock',
      name: 'kidsLock',
      desc: '',
      args: [],
    );
  }

  /// `Location is off`
  String get locationIsOff {
    return Intl.message(
      'Location is off',
      name: 'locationIsOff',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up Post`
  String get liftUpPost {
    return Intl.message(
      'Lift Up Post',
      name: 'liftUpPost',
      desc: '',
      args: [],
    );
  }

  /// `LiftUp Posts`
  String get liftUpPosts {
    return Intl.message(
      'LiftUp Posts',
      name: 'liftUpPosts',
      desc: '',
      args: [],
    );
  }

  /// `Lift Up Profile`
  String get liftUpProfile {
    return Intl.message(
      'Lift Up Profile',
      name: 'liftUpProfile',
      desc: '',
      args: [],
    );
  }

  /// `LiftUp Profiles`
  String get liftUpProfiles {
    return Intl.message(
      'LiftUp Profiles',
      name: 'liftUpProfiles',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Security`
  String get privacyAndSecurity {
    return Intl.message(
      'Privacy & Security',
      name: 'privacyAndSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Interested`
  String get interested {
    return Intl.message(
      'Interested',
      name: 'interested',
      desc: '',
      args: [],
    );
  }

  /// `Inspire`
  String get inspire {
    return Intl.message(
      'Inspire',
      name: 'inspire',
      desc: '',
      args: [],
    );
  }

  /// `Best Sellers`
  String get bestSeller {
    return Intl.message(
      'Best Sellers',
      name: 'bestSeller',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure the content is made for kids?`
  String get confirmKidsContent {
    return Intl.message(
      'Are you sure the content is made for kids?',
      name: 'confirmKidsContent',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure the content is Islamic?`
  String get confirmIslamicContent {
    return Intl.message(
      'Are you sure the content is Islamic?',
      name: 'confirmIslamicContent',
      desc: '',
      args: [],
    );
  }

  /// `If you confirm the submit, your post goes for review.`
  String get confirmSubmitForReview {
    return Intl.message(
      'If you confirm the submit, your post goes for review.',
      name: 'confirmSubmitForReview',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fa'),
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
