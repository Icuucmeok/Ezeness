part of app_res;

class AppData {
  AppData();
  List<DayTime> dayList = [
    DayTime(id: 0, dayName: S.current.Sunday, dayCode: "Sun"),
    DayTime(id: 1, dayName: S.current.Monday, dayCode: "Mon"),
    DayTime(id: 2, dayName: S.current.Tuesday, dayCode: "Tues"),
    DayTime(id: 3, dayName: S.current.Wednesday, dayCode: "Wed"),
    DayTime(id: 4, dayName: S.current.Thursday, dayCode: "Thurs"),
    DayTime(id: 5, dayName: S.current.Friday, dayCode: "Fri"),
    DayTime(id: 6, dayName: S.current.Saturday, dayCode: "Sat"),
  ];
  static late List<ReportReasons> reasonsList;
  static late String privacyPolicy;
  static late String liftUpCoinRate;
  static late List<SingleLiftupModel>? liftUps;
  static late String termOfUse;
  static late bool isUserProfileLocationRequired;
  static late bool isUserProfileBirthDateRequired;
  static late bool isUserProfileGenderRequired;
  static late bool isUserProfileNationalityRequired;
  static bool isShowBoostButton = false;
  static bool isShowGoogleButton = false;

  static final Category vipCategory = Category(
      name: "VIP",
      image: Constants.vipImage,
      type: Constants.categoryTypeVipKey);

  static final List<CurrencyModel> appCurrencyList = [
    CurrencyModel(
        currency: S.current.defaultCurrency,
        countryName: S.current.defaultCurrency),
    CurrencyModel(currency: 'AED', countryName: 'UAE Dirham'),
    CurrencyModel(currency: 'EUR', countryName: 'Euro'),
    CurrencyModel(currency: 'USD', countryName: 'United States Dollar'),
    CurrencyModel(currency: 'PKR', countryName: 'Pakistani Rupee'),
    CurrencyModel(currency: 'INR', countryName: 'Indian Rupee'),
  ];

  static final List<CurrencyModel> postCurrencyList = [
    CurrencyModel(currency: 'AED', countryName: 'United Arab Emirates Dirham'),
    CurrencyModel(currency: 'AFN', countryName: 'Afghan Afghani'),
    CurrencyModel(currency: 'ALL', countryName: 'Albanian Lek'),
    CurrencyModel(currency: 'AMD', countryName: 'Armenian Dram'),
    CurrencyModel(
        currency: 'ANG', countryName: 'Netherlands Antillean Guilder'),
    CurrencyModel(currency: 'AOA', countryName: 'Angolan Kwanza'),
    CurrencyModel(currency: 'ARS', countryName: 'Argentine Peso'),
    CurrencyModel(currency: 'AUD', countryName: 'Australian Dollar'),
    CurrencyModel(currency: 'AWG', countryName: 'Aruban Florin'),
    CurrencyModel(currency: 'AZN', countryName: 'Azerbaijani Manat'),
    CurrencyModel(
        currency: 'BAM',
        countryName: 'Bosnia and Herzegovina Convertible Mark'),
    CurrencyModel(currency: 'BBD', countryName: 'Barbadian Dollar'),
    CurrencyModel(currency: 'BDT', countryName: 'Bangladeshi Taka'),
    CurrencyModel(currency: 'BGN', countryName: 'Bulgarian Lev'),
    CurrencyModel(currency: 'BHD', countryName: 'Bahraini Dinar'),
    CurrencyModel(currency: 'BIF', countryName: 'Burundian Franc'),
    CurrencyModel(currency: 'BMD', countryName: 'Bermudian Dollar'),
    CurrencyModel(currency: 'BND', countryName: 'Brunei Dollar'),
    CurrencyModel(currency: 'BOB', countryName: 'Bolivian Boliviano'),
    CurrencyModel(currency: 'BRL', countryName: 'Brazilian Real'),
    CurrencyModel(currency: 'BSD', countryName: 'Bahamian Dollar'),
    CurrencyModel(currency: 'BTC', countryName: 'Bitcoin'),
    CurrencyModel(currency: 'BTN', countryName: 'Bhutanese Ngultrum'),
    CurrencyModel(currency: 'BWP', countryName: 'Botswana Pula'),
    CurrencyModel(currency: 'BYN', countryName: 'Belarusian Ruble'),
    CurrencyModel(currency: 'BZD', countryName: 'Belize Dollar'),
    CurrencyModel(currency: 'CAD', countryName: 'Canadian Dollar'),
    CurrencyModel(currency: 'CDF', countryName: 'Congolese Franc'),
    CurrencyModel(currency: 'CHF', countryName: 'Swiss Franc'),
    CurrencyModel(currency: 'CLF', countryName: 'Chilean Unit of Account (UF)'),
    CurrencyModel(currency: 'CLP', countryName: 'Chilean Peso'),
    CurrencyModel(currency: 'CNH', countryName: 'Chinese Yuan (Offshore)'),
    CurrencyModel(currency: 'CNY', countryName: 'Chinese Yuan'),
    CurrencyModel(currency: 'COP', countryName: 'Colombian Peso'),
    CurrencyModel(currency: 'CRC', countryName: 'Costa Rican Colón'),
    CurrencyModel(currency: 'CUC', countryName: 'Cuban Convertible Peso'),
    CurrencyModel(currency: 'CUP', countryName: 'Cuban Peso'),
    CurrencyModel(currency: 'CVE', countryName: 'Cape Verdean Escudo'),
    CurrencyModel(currency: 'CZK', countryName: 'Czech Koruna'),
    CurrencyModel(currency: 'DJF', countryName: 'Djiboutian Franc'),
    CurrencyModel(currency: 'DKK', countryName: 'Danish Krone'),
    CurrencyModel(currency: 'DOP', countryName: 'Dominican Peso'),
    CurrencyModel(currency: 'DZD', countryName: 'Algerian Dinar'),
    CurrencyModel(currency: 'EGP', countryName: 'Egyptian Pound'),
    CurrencyModel(currency: 'ERN', countryName: 'Eritrean Nakfa'),
    CurrencyModel(currency: 'ETB', countryName: 'Ethiopian Birr'),
    CurrencyModel(currency: 'EUR', countryName: 'Euro'),
    CurrencyModel(currency: 'FJD', countryName: 'Fijian Dollar'),
    CurrencyModel(currency: 'FKP', countryName: 'Falkland Islands Pound'),
    CurrencyModel(currency: 'GBP', countryName: 'British Pound Sterling'),
    CurrencyModel(currency: 'GEL', countryName: 'Georgian Lari'),
    CurrencyModel(currency: 'GGP', countryName: 'Guernsey Pound'),
    CurrencyModel(currency: 'GHS', countryName: 'Ghanaian Cedi'),
    CurrencyModel(currency: 'GIP', countryName: 'Gibraltar Pound'),
    CurrencyModel(currency: 'GMD', countryName: 'Gambian Dalasi'),
    CurrencyModel(currency: 'GNF', countryName: 'Guinean Franc'),
    CurrencyModel(currency: 'GTQ', countryName: 'Guatemalan Quetzal'),
    CurrencyModel(currency: 'GYD', countryName: 'Guyanese Dollar'),
    CurrencyModel(currency: 'HKD', countryName: 'Hong Kong Dollar'),
    CurrencyModel(currency: 'HNL', countryName: 'Honduran Lempira'),
    CurrencyModel(currency: 'HRK', countryName: 'Croatian Kuna'),
    CurrencyModel(currency: 'HTG', countryName: 'Haitian Gourde'),
    CurrencyModel(currency: 'HUF', countryName: 'Hungarian Forint'),
    CurrencyModel(currency: 'IDR', countryName: 'Indonesian Rupiah'),
    CurrencyModel(currency: 'ILS', countryName: 'Israeli New Shekel'),
    CurrencyModel(currency: 'IMP', countryName: 'Isle of Man Pound'),
    CurrencyModel(currency: 'INR', countryName: 'Indian Rupee'),
    CurrencyModel(currency: 'IQD', countryName: 'Iraqi Dinar'),
    CurrencyModel(currency: 'IRR', countryName: 'Iranian Rial'),
    CurrencyModel(currency: 'ISK', countryName: 'Icelandic Króna'),
    CurrencyModel(currency: 'JEP', countryName: 'Jersey Pound'),
    CurrencyModel(currency: 'JMD', countryName: 'Jamaican Dollar'),
    CurrencyModel(currency: 'JOD', countryName: 'Jordanian Dinar'),
    CurrencyModel(currency: 'JPY', countryName: 'Japanese Yen'),
    CurrencyModel(currency: 'KES', countryName: 'Kenyan Shilling'),
    CurrencyModel(currency: 'KGS', countryName: 'Kyrgyzstani Som'),
    CurrencyModel(currency: 'KHR', countryName: 'Cambodian Riel'),
    CurrencyModel(currency: 'KMF', countryName: 'Comorian Franc'),
    CurrencyModel(currency: 'KPW', countryName: 'North Korean Won'),
    CurrencyModel(currency: 'KRW', countryName: 'South Korean Won'),
    CurrencyModel(currency: 'KWD', countryName: 'Kuwaiti Dinar'),
    CurrencyModel(currency: 'KYD', countryName: 'Cayman Islands Dollar'),
    CurrencyModel(currency: 'KZT', countryName: 'Kazakhstani Tenge'),
    CurrencyModel(currency: 'LAK', countryName: 'Lao Kip'),
    CurrencyModel(currency: 'LBP', countryName: 'Lebanese Pound'),
    CurrencyModel(currency: 'LKR', countryName: 'Sri Lankan Rupee'),
    CurrencyModel(currency: 'LRD', countryName: 'Liberian Dollar'),
    CurrencyModel(currency: 'LSL', countryName: 'Lesotho Loti'),
    CurrencyModel(currency: 'LYD', countryName: 'Libyan Dinar'),
    CurrencyModel(currency: 'MAD', countryName: 'Moroccan Dirham'),
    CurrencyModel(currency: 'MDL', countryName: 'Moldovan Leu'),
    CurrencyModel(currency: 'MGA', countryName: 'Malagasy Ariary'),
    CurrencyModel(currency: 'MKD', countryName: 'Macedonian Denar'),
    CurrencyModel(currency: 'MMK', countryName: 'Myanma Kyat'),
    CurrencyModel(currency: 'MNT', countryName: 'Mongolian Tögrög'),
    CurrencyModel(currency: 'MOP', countryName: 'Macanese Pataca'),
    CurrencyModel(currency: 'MRU', countryName: 'Mauritanian Ouguiya'),
    CurrencyModel(currency: 'MUR', countryName: 'Mauritian Rupee'),
    CurrencyModel(currency: 'MVR', countryName: 'Maldivian Rufiyaa'),
    CurrencyModel(currency: 'MWK', countryName: 'Malawian Kwacha'),
    CurrencyModel(currency: 'MXN', countryName: 'Mexican Peso'),
    CurrencyModel(currency: 'MYR', countryName: 'Malaysian Ringgit'),
    CurrencyModel(currency: 'MZN', countryName: 'Mozambican Metical'),
    CurrencyModel(currency: 'NAD', countryName: 'Namibian Dollar'),
    CurrencyModel(currency: 'NGN', countryName: 'Nigerian Naira'),
    CurrencyModel(currency: 'NIO', countryName: 'Nicaraguan Córdoba'),
    CurrencyModel(currency: 'NOK', countryName: 'Norwegian Krone'),
    CurrencyModel(currency: 'NPR', countryName: 'Nepalese Rupee'),
    CurrencyModel(currency: 'NZD', countryName: 'New Zealand Dollar'),
    CurrencyModel(currency: 'OMR', countryName: 'Omani Rial'),
    CurrencyModel(currency: 'PAB', countryName: 'Panamanian Balboa'),
    CurrencyModel(currency: 'PEN', countryName: 'Peruvian Sol'),
    CurrencyModel(currency: 'PGK', countryName: 'Papua New Guinean Kina'),
    CurrencyModel(currency: 'PHP', countryName: 'Philippine Peso'),
    CurrencyModel(currency: 'PKR', countryName: 'Pakistani Rupee'),
    CurrencyModel(currency: 'PLN', countryName: 'Polish Zloty'),
    CurrencyModel(currency: 'PYG', countryName: 'Paraguayan Guarani'),
    CurrencyModel(currency: 'QAR', countryName: 'Qatari Rial'),
    CurrencyModel(currency: 'RON', countryName: 'Romanian Leu'),
    CurrencyModel(currency: 'RSD', countryName: 'Serbian Dinar'),
    CurrencyModel(currency: 'RUB', countryName: 'Russian Ruble'),
    CurrencyModel(currency: 'RWF', countryName: 'Rwandan Franc'),
    CurrencyModel(currency: 'SAR', countryName: 'Saudi Riyal'),
    CurrencyModel(currency: 'SBD', countryName: 'Solomon Islands Dollar'),
    CurrencyModel(currency: 'SCR', countryName: 'Seychellois Rupee'),
    CurrencyModel(currency: 'SDG', countryName: 'Sudanese Pound'),
    CurrencyModel(currency: 'SEK', countryName: 'Swedish Krona'),
    CurrencyModel(currency: 'SGD', countryName: 'Singapore Dollar'),
    CurrencyModel(currency: 'SHP', countryName: 'Saint Helena Pound'),
    CurrencyModel(currency: 'SLL', countryName: 'Sierra Leonean Leone'),
    CurrencyModel(currency: 'SOS', countryName: 'Somali Shilling'),
    CurrencyModel(currency: 'SRD', countryName: 'Surinamese Dollar'),
    CurrencyModel(currency: 'SSP', countryName: 'South Sudanese Pound'),
    CurrencyModel(currency: 'STD', countryName: 'São Tomé and Príncipe Dobra'),
    CurrencyModel(
        currency: 'STN', countryName: 'São Tomé and Príncipe Dobra (new)'),
    CurrencyModel(currency: 'SVC', countryName: 'Salvadoran Colón'),
    CurrencyModel(currency: 'SYP', countryName: 'Syrian Pound'),
    CurrencyModel(currency: 'SZL', countryName: 'Swazi Lilangeni'),
    CurrencyModel(currency: 'THB', countryName: 'Thai Baht'),
    CurrencyModel(currency: 'TJS', countryName: 'Tajikistani Somoni'),
    CurrencyModel(currency: 'TMT', countryName: 'Turkmenistani Manat'),
    CurrencyModel(currency: 'TND', countryName: 'Tunisian Dinar'),
    CurrencyModel(currency: 'TOP', countryName: 'Tongan Paʻanga'),
    CurrencyModel(currency: 'TRY', countryName: 'Turkish Lira'),
    CurrencyModel(currency: 'TTD', countryName: 'Trinidad and Tobago Dollar'),
    CurrencyModel(currency: 'TWD', countryName: 'New Taiwan Dollar'),
    CurrencyModel(currency: 'TZS', countryName: 'Tanzanian Shilling'),
    CurrencyModel(currency: 'UAH', countryName: 'Ukrainian Hryvnia'),
    CurrencyModel(currency: 'UGX', countryName: 'Ugandan Shilling'),
    CurrencyModel(currency: 'USD', countryName: 'United States Dollar'),
    CurrencyModel(currency: 'UYU', countryName: 'Uruguayan Peso'),
    CurrencyModel(currency: 'UZS', countryName: 'Uzbekistani Som'),
    CurrencyModel(currency: 'VES', countryName: 'Venezuelan Bolívar Soberano'),
    CurrencyModel(currency: 'VND', countryName: 'Vietnamese Dong'),
    CurrencyModel(currency: 'VUV', countryName: 'Vanuatu Vatu'),
    CurrencyModel(currency: 'WST', countryName: 'Samoan Tala'),
    CurrencyModel(currency: 'XAF', countryName: 'Central African CFA Franc'),
    CurrencyModel(currency: 'XAG', countryName: 'Silver Ounce'),
    CurrencyModel(currency: 'XAU', countryName: 'Gold Ounce'),
    CurrencyModel(currency: 'XCD', countryName: 'East Caribbean Dollar'),
    CurrencyModel(currency: 'XDR', countryName: 'Special Drawing Rights'),
    CurrencyModel(currency: 'XOF', countryName: 'West African CFA Franc'),
    CurrencyModel(currency: 'XPD', countryName: 'Palladium Ounce'),
    CurrencyModel(currency: 'XPF', countryName: 'CFP Franc'),
    CurrencyModel(currency: 'XPT', countryName: 'Platinum Ounce'),
    CurrencyModel(currency: 'YER', countryName: 'Yemeni Rial'),
    CurrencyModel(currency: 'ZAR', countryName: 'South African Rand'),
    CurrencyModel(currency: 'ZMW', countryName: 'Zambian Kwacha'),
    CurrencyModel(currency: 'ZWL', countryName: 'Zimbabwean Dollar'),
  ];

  static List<CountryModel> countries = [
    CountryModel(id: 0, title: 'AFGHANISTAN', value: 'AF'),
    CountryModel(id: 1, title: 'ALBANIA', value: 'AL'),
    CountryModel(id: 2, title: 'ALGERIA', value: 'DZ'),
    CountryModel(id: 3, title: 'ANDORRA', value: 'AD'),
    CountryModel(id: 4, title: 'ANGOLA', value: 'AO'),
    CountryModel(id: 5, title: 'ANTIGUA AND BARBUDA', value: 'AG'),
    CountryModel(id: 6, title: 'ARGENTINA', value: 'AR'),
    CountryModel(id: 7, title: 'ARMENIA', value: 'AM'),
    CountryModel(id: 8, title: 'AUSTRALIA', value: 'AU'),
    CountryModel(id: 9, title: 'AUSTRIA', value: 'AT'),
    CountryModel(id: 10, title: 'AZERBAIJAN', value: 'AZ'),
    CountryModel(id: 11, title: 'BAHAMAS', value: 'BS'),
    CountryModel(id: 12, title: 'BAHRAIN', value: 'BH'),
    CountryModel(id: 13, title: 'BANGLADESH', value: 'BD'),
    CountryModel(id: 14, title: 'BARBADOS', value: 'BB'),
    CountryModel(id: 15, title: 'BELARUS', value: 'BY'),
    CountryModel(id: 16, title: 'BELGIUM', value: 'BE'),
    CountryModel(id: 17, title: 'BELIZE', value: 'BZ'),
    CountryModel(id: 18, title: 'BENIN', value: 'BJ'),
    CountryModel(id: 19, title: 'BHUTAN', value: 'BT'),
    CountryModel(id: 20, title: 'BOLIVIA', value: 'BO'),
    CountryModel(id: 21, title: 'BOSNIA AND HERZEGOVINA', value: 'BA'),
    CountryModel(id: 22, title: 'BOTSWANA', value: 'BW'),
    CountryModel(id: 23, title: 'BRAZIL', value: 'BR'),
    CountryModel(id: 24, title: 'BRUNEI', value: 'BN'),
    CountryModel(id: 25, title: 'BULGARIA', value: 'BG'),
    CountryModel(id: 26, title: 'BURKINA FASO', value: 'BF'),
    CountryModel(id: 27, title: 'BURUNDI', value: 'BI'),
    CountryModel(id: 28, title: 'CABO VERDE', value: 'CV'),
    CountryModel(id: 29, title: 'CAMBODIA', value: 'KH'),
    CountryModel(id: 30, title: 'CAMEROON', value: 'CM'),
    CountryModel(id: 31, title: 'CANADA', value: 'CA'),
    CountryModel(id: 32, title: 'CENTRAL AFRICAN REPUBLIC', value: 'CF'),
    CountryModel(id: 33, title: 'CHAD', value: 'TD'),
    CountryModel(id: 34, title: 'CHILE', value: 'CL'),
    CountryModel(id: 35, title: 'CHINA', value: 'CN'),
    CountryModel(id: 36, title: 'COLOMBIA', value: 'CO'),
    CountryModel(id: 37, title: 'COMOROS', value: 'KM'),
    CountryModel(id: 38, title: 'CONGO BRAZZAVILLE', value: 'CG'),
    CountryModel(id: 39, title: 'CONGO KINSHASA', value: 'CD'),
    CountryModel(id: 40, title: 'COSTA RICA', value: 'CR'),
    CountryModel(id: 41, title: 'CROATIA', value: 'HR'),
    CountryModel(id: 42, title: 'CUBA', value: 'CU'),
    CountryModel(id: 43, title: 'CYPRUS', value: 'CY'),
    CountryModel(id: 44, title: 'CZECH REPUBLIC', value: 'CZ'),
    CountryModel(id: 45, title: 'DENMARK', value: 'DK'),
    CountryModel(id: 46, title: 'DJIBOUTI', value: 'DJ'),
    CountryModel(id: 47, title: 'DOMINICA', value: 'DM'),
    CountryModel(id: 48, title: 'DOMINICAN REPUBLIC', value: 'DO'),
    CountryModel(id: 49, title: 'ECUADOR', value: 'EC'),
    CountryModel(id: 50, title: 'EGYPT', value: 'EG'),
    CountryModel(id: 51, title: 'EL SALVADOR', value: 'SV'),
    CountryModel(id: 52, title: 'EQUATORIAL GUINEA', value: 'GQ'),
    CountryModel(id: 53, title: 'ERITREA', value: 'ER'),
    CountryModel(id: 54, title: 'ESTONIA', value: 'EE'),
    CountryModel(id: 55, title: 'ESWATINI', value: 'SZ'),
    CountryModel(id: 56, title: 'ETHIOPIA', value: 'ET'),
    CountryModel(id: 57, title: 'FIJI', value: 'FJ'),
    CountryModel(id: 58, title: 'FINLAND', value: 'FI'),
    CountryModel(id: 59, title: 'FRANCE', value: 'FR'),
    CountryModel(id: 60, title: 'GABON', value: 'GA'),
    CountryModel(id: 61, title: 'GAMBIA', value: 'GM'),
    CountryModel(id: 62, title: 'GEORGIA', value: 'GE'),
    CountryModel(id: 63, title: 'GERMANY', value: 'DE'),
    CountryModel(id: 64, title: 'GHANA', value: 'GH'),
    CountryModel(id: 65, title: 'GREECE', value: 'GR'),
    CountryModel(id: 66, title: 'GRENADA', value: 'GD'),
    CountryModel(id: 67, title: 'GUATEMALA', value: 'GT'),
    CountryModel(id: 68, title: 'GUINEA', value: 'GN'),
    CountryModel(id: 69, title: 'GUINEA BISSAU', value: 'GW'),
    CountryModel(id: 70, title: 'GUYANA', value: 'GY'),
    CountryModel(id: 71, title: 'HAITI', value: 'HT'),
    CountryModel(id: 72, title: 'HONDURAS', value: 'HN'),
    CountryModel(id: 73, title: 'HUNGARY', value: 'HU'),
    CountryModel(id: 74, title: 'ICELAND', value: 'IS'),
    CountryModel(id: 75, title: 'INDIA', value: 'IN'),
    CountryModel(id: 76, title: 'INDONESIA', value: 'ID'),
    CountryModel(id: 77, title: 'IRAN', value: 'IR'),
    CountryModel(id: 78, title: 'IRAQ', value: 'IQ'),
    CountryModel(id: 79, title: 'IRELAND', value: 'IE'),
    CountryModel(id: 80, title: 'ISRAEL', value: 'IL'),
    CountryModel(id: 81, title: 'ITALY', value: 'IT'),
    CountryModel(id: 82, title: 'JAMAICA', value: 'JM'),
    CountryModel(id: 83, title: 'JAPAN', value: 'JP'),
    CountryModel(id: 84, title: 'JORDAN', value: 'JO'),
    CountryModel(id: 85, title: 'KAZAKHSTAN', value: 'KZ'),
    CountryModel(id: 86, title: 'KENYA', value: 'KE'),
    CountryModel(id: 87, title: 'KIRIBATI', value: 'KI'),
    CountryModel(id: 88, title: 'KOSOVO', value: 'XK'),
    CountryModel(id: 89, title: 'KUWAIT', value: 'KW'),
    CountryModel(id: 90, title: 'KYRGYZSTAN', value: 'KG'),
    CountryModel(id: 91, title: 'LAOS', value: 'LA'),
    CountryModel(id: 92, title: 'LATVIA', value: 'LV'),
    CountryModel(id: 93, title: 'LEBANON', value: 'LB'),
    CountryModel(id: 94, title: 'LESOTHO', value: 'LS'),
    CountryModel(id: 95, title: 'LIBERIA', value: 'LR'),
    CountryModel(id: 96, title: 'LIBYA', value: 'LY'),
    CountryModel(id: 97, title: 'LIECHTENSTEIN', value: 'LI'),
    CountryModel(id: 98, title: 'LITHUANIA', value: 'LT'),
    CountryModel(id: 99, title: 'LUXEMBOURG', value: 'LU'),
    CountryModel(id: 100, title: 'MADAGASCAR', value: 'MG'),
    CountryModel(id: 101, title: 'MALAWI', value: 'MW'),
    CountryModel(id: 102, title: 'MALAYSIA', value: 'MY'),
    CountryModel(id: 103, title: 'MALDIVES', value: 'MV'),
    CountryModel(id: 104, title: 'MALI', value: 'ML'),
    CountryModel(id: 105, title: 'MALTA', value: 'MT'),
    CountryModel(id: 106, title: 'MARSHALL ISLANDS', value: 'MH'),
    CountryModel(id: 107, title: 'MAURITANIA', value: 'MR'),
    CountryModel(id: 108, title: 'MAURITIUS', value: 'MU'),
    CountryModel(id: 109, title: 'MEXICO', value: 'MX'),
    CountryModel(id: 110, title: 'MICRONESIA', value: 'FM'),
    CountryModel(id: 111, title: 'MOLDOVA', value: 'MD'),
    CountryModel(id: 112, title: 'MONACO', value: 'MC'),
    CountryModel(id: 113, title: 'MONGOLIA', value: 'MN'),
    CountryModel(id: 114, title: 'MONTENEGRO', value: 'ME'),
    CountryModel(id: 115, title: 'MOROCCO', value: 'MA'),
    CountryModel(id: 116, title: 'MOZAMBIQUE', value: 'MZ'),
    CountryModel(id: 117, title: 'MYANMAR', value: 'MM'),
    CountryModel(id: 118, title: 'NAMIBIA', value: 'NA'),
    CountryModel(id: 119, title: 'NAURU', value: 'NR'),
    CountryModel(id: 120, title: 'NEPAL', value: 'NP'),
    CountryModel(id: 121, title: 'NETHERLANDS', value: 'NL'),
    CountryModel(id: 122, title: 'NEW ZEALAND', value: 'NZ'),
    CountryModel(id: 123, title: 'NICARAGUA', value: 'NI'),
    CountryModel(id: 124, title: 'NIGER', value: 'NE'),
    CountryModel(id: 125, title: 'NIGERIA', value: 'NG'),
    CountryModel(id: 126, title: 'NORTH KOREA', value: 'KP'),
    CountryModel(id: 127, title: 'NORTH MACEDONIA', value: 'MK'),
    CountryModel(id: 128, title: 'NORWAY', value: 'NO'),
    CountryModel(id: 129, title: 'OMAN', value: 'OM'),
    CountryModel(id: 130, title: 'PAKISTAN', value: 'PK'),
    CountryModel(id: 131, title: 'PALAU', value: 'PW'),
    CountryModel(id: 132, title: 'PALESTINE', value: 'PS'),
    CountryModel(id: 133, title: 'PANAMA', value: 'PA'),
    CountryModel(id: 134, title: 'PAPUA NEW GUINEA', value: 'PG'),
    CountryModel(id: 135, title: 'PARAGUAY', value: 'PY'),
    CountryModel(id: 136, title: 'PERU', value: 'PE'),
    CountryModel(id: 137, title: 'PHILIPPINES', value: 'PH'),
    CountryModel(id: 138, title: 'POLAND', value: 'PL'),
    CountryModel(id: 139, title: 'PORTUGAL', value: 'PT'),
    CountryModel(id: 140, title: 'QATAR', value: 'QA'),
    CountryModel(id: 141, title: 'ROMANIA', value: 'RO'),
    CountryModel(id: 142, title: 'RUSSIA', value: 'RU'),
    CountryModel(id: 143, title: 'RWANDA', value: 'RW'),
    CountryModel(id: 144, title: 'SAINT KITTS AND NEVIS', value: 'KN'),
    CountryModel(id: 145, title: 'SAINT LUCIA', value: 'LC'),
    CountryModel(
        id: 146, title: 'SAINT VINCENT AND THE GRENADINES', value: 'VC'),
    CountryModel(id: 147, title: 'SAMOA', value: 'WS'),
    CountryModel(id: 148, title: 'SAN MARINO', value: 'SM'),
    CountryModel(id: 149, title: 'SAO TOME AND PRINCIPE', value: 'ST'),
    CountryModel(id: 150, title: 'SAUDI ARABIA', value: 'SA'),
    CountryModel(id: 151, title: 'SENEGAL', value: 'SN'),
    CountryModel(id: 152, title: 'SERBIA', value: 'RS'),
    CountryModel(id: 153, title: 'SEYCHELLES', value: 'SC'),
    CountryModel(id: 154, title: 'SIERRA LEONE', value: 'SL'),
    CountryModel(id: 155, title: 'SINGAPORE', value: 'SG'),
    CountryModel(id: 156, title: 'SLOVAKIA', value: 'SK'),
    CountryModel(id: 157, title: 'SLOVENIA', value: 'SI'),
    CountryModel(id: 158, title: 'SOLOMON ISLANDS', value: 'SB'),
    CountryModel(id: 159, title: 'SOMALIA', value: 'SO'),
    CountryModel(id: 160, title: 'SOUTH AFRICA', value: 'ZA'),
    CountryModel(id: 161, title: 'SOUTH KOREA', value: 'KR'),
    CountryModel(id: 162, title: 'SOUTH SUDAN', value: 'SS'),
    CountryModel(id: 163, title: 'SPAIN', value: 'ES'),
    CountryModel(id: 164, title: 'SRI LANKA', value: 'LK'),
    CountryModel(id: 165, title: 'SUDAN', value: 'SD'),
    CountryModel(id: 166, title: 'SURINAME', value: 'SR'),
    CountryModel(id: 167, title: 'SWEDEN', value: 'SE'),
    CountryModel(id: 168, title: 'SWITZERLAND', value: 'CH'),
    CountryModel(id: 169, title: 'SYRIA', value: 'SY'),
    CountryModel(id: 170, title: 'TAIWAN', value: 'TW'),
    CountryModel(id: 171, title: 'TAJIKISTAN', value: 'TJ'),
    CountryModel(id: 172, title: 'TANZANIA', value: 'TZ'),
    CountryModel(id: 173, title: 'THAILAND', value: 'TH'),
    CountryModel(id: 174, title: 'TIMOR LESTE', value: 'TL'),
    CountryModel(id: 175, title: 'TOGO', value: 'TG'),
    CountryModel(id: 176, title: 'TONGA', value: 'TO'),
    CountryModel(id: 177, title: 'TRINIDAD AND TOBAGO', value: 'TT'),
    CountryModel(id: 178, title: 'TUNISIA', value: 'TN'),
    CountryModel(id: 179, title: 'TURKEY', value: 'TR'),
    CountryModel(id: 180, title: 'TURKMENISTAN', value: 'TM'),
    CountryModel(id: 181, title: 'TUVALU', value: 'TV'),
    CountryModel(id: 182, title: 'UKRAINE', value: 'UA'),
    CountryModel(id: 183, title: 'UNITED ARAB EMIRATES', value: 'AE'),
    CountryModel(id: 184, title: 'UNITED KINGDOM', value: 'GB'),
    CountryModel(id: 185, title: 'UNITED STATES', value: 'US'),
    CountryModel(id: 186, title: 'URUGUAY', value: 'UY'),
    CountryModel(id: 187, title: 'UZBEKISTAN', value: 'UZ'),
    CountryModel(id: 188, title: 'VANUATU', value: 'VU'),
    CountryModel(id: 189, title: 'VATICAN CITY', value: 'VA'),
    CountryModel(id: 190, title: 'VENEZUELA', value: 'VE'),
    CountryModel(id: 191, title: 'VIETNAM', value: 'VN'),
    CountryModel(id: 192, title: 'YEMEN', value: 'YE'),
    CountryModel(id: 193, title: 'ZAMBIA', value: 'ZM'),
    CountryModel(id: 194, title: 'ZIMBABWE', value: 'ZW'),
    CountryModel(id: 195, title: 'UGANDA', value: 'UG'),
  ];
}
