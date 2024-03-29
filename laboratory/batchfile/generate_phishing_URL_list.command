#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

function create_phishing_URL_list () {
  main_file="$current_dir/JPCERT_phishing_URL_list.csv"
  sub_file=$(find "$current_dir" -type d -name "phishurl-list-main" 2>/dev/null)

  cd "$sub_file/2019" || exit
  for i in {1..12}; do
    CAT_2019=$(echo "20190$i.csv" | sed -e 's/010/10/g' -e 's/011/11/g' -e 's/012/12/g')
    echo "$CAT_2019 >> $main_file"
    cat "$CAT_2019" >> "$main_file"
  done

  cd "$sub_file/2020" || exit
  for i in {1..12}; do
    CAT_2020=$(echo "20200$i.csv" | sed -e 's/010/10/g' -e 's/011/11/g' -e 's/012/12/g')
    echo "$CAT_2020 >> $main_file"
    cat "$CAT_2020" >> "$main_file"
  done

  cd "$sub_file/2021" || exit
  for i in {1..12}; do
    CAT_2021=$(echo "20210$i.csv" | sed -e 's/010/10/g' -e 's/011/11/g' -e 's/012/12/g')
    echo "$CAT_2021 >> $main_file"
    cat "$CAT_2021" >> "$main_file"
  done

  cd "$sub_file/2022" || exit
  for i in {1..12}; do
    CAT_2022=$(echo "20220$i.csv" | sed -e 's/010/10/g' -e 's/011/11/g' -e 's/012/12/g')
    echo "$CAT_2022 >> $main_file"
    cat "$CAT_2022" >> "$main_file"
  done

  cd "$sub_file/2023" || exit
  for i in {1..12}; do
    CAT_2023=$(echo "20230$i.csv" | sed -e 's/010/10/g' -e 's/011/11/g' -e 's/012/12/g')
    echo "$CAT_2023 >> $main_file"
    cat "$CAT_2023" >> "$main_file"
  done

  sed -i '' '/date/d' "$main_file"
  rm -rf "$sub_file"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mJPCERT_phishing_URL_list.csv は $current_dir に格納されています。\033[0m"
  echo
}

function generate_phishing_URL_list () {
  main_file="$current_dir/block.txt"
  main_file_csv="$current_dir/block.csv"
  sub_file="$current_dir/JPCERT_phishing_URL_list.csv"
  sub_copy="$current_dir/JPCERT_phishing_URL_list_copy.csv"

  At_nifty=true
  At_TCOM=true
  one_and_one_Ionos=true
  second_STREET=true
  Three_D_secure=true
  Aone_Telekom_Austria=true
  ABSA_Bank=true
  ACCESSTRADE=true
  ACROSS_Webmail=true
  Active_mail=true
  Adobe=true
  Agencia_Tributaria=true
  AGRIBANK=true
  airbnb=true
  Alaska_USA=true
  Alibaba_com=true
  Alpha_Bank=true
  Amazon=true
  Americas_First_Federal_Credit_Union=true
  American_Express=true
  Americanas=true
  AMP_Limited=true
  ANA=true
  ANZ=true
  AOL=true
  Apple_ID=true
  Apple_Pay=true
  Apple_Store=true
  Aramex=true
  Arcor=true
  Argenta=true
  ARNES=true
  Aruba_SpA=true
  ASAHI_net=true
  ACB=true
  ASOVIEW=true
  AT_and_T=true
  ATB_Financial=true
  au=true
  Australia_Post=true
  Australian_Government=true
  AutoScout24=true
  avis=true
  AXA=true
  AXIS_BANK=true
  BAN_BAN_networks=true
  Banca_Intesa=true
  BMdPdS=true
  Banco_do_Brasil=true
  Banco_Galicia=true
  Banco_Sabadell=true
  Banco_Santander=true
  Banco_Supervielle=true
  BancoEstado=true
  Bancolombia=true
  BancorpSouth=true
  Bangkok_Bank=true
  Bank_AL_Habib=true
  Bank_of_America=true
  Bank_of_China=true
  Bank_of_China_HK=true
  Bank_of_Cyprus=true
  Bank_of_Ireland=true
  Bank_Of_Montreal=true
  Bank_of_New_Zealand=true
  Bank_of_the_Philippine_Islands=true
  BankID_BankAxept=true
  BANQUE_NATIONALE_DU_CANADA=true
  Barclays_Bank=true
  BAWAG_PSK=true
  BB_and_T=true
  BBIQ=true
  BBIQ_Kyushu_Communication_Network=true
  BBVA=true
  BDO_Unibank=true
  Bell_Canada=true
  Bendigo_Bank=true
  BFCU=true
  biccamera=true
  BIGLOBE=true
  BINANCE=true
  bitbank=true
  BitCash=true
  bitFlyer=true
  BitMEX=true
  Bitstamp=true
  BitTrade=true
  Blackboard=true
  Blockchain=true
  BMO=true
  BNL=true
  BNP_Paribas=true
  Booking_com=true
  Boursorama=true
  box=true
  BPER_Banca=true
  BPI=true
  bpost=true
  Bradesco=true
  Brazil_Ministry=true
  BT=true
  BTCBOX=true
  Caixa=true
  Canada_Revenue_Agency=true
  Canonet=true
  Capital_One=true
  Capitec_bank=true
  Carrefour=true
  Casas_Bahia=true
  Cashplus=true
  Cathay_Pacific_Airways=true
  CenturyLink=true
  Charles_Schwab=true
  Charles_Sturt_University=true
  CHASE=true
  China_CITIC_Bank=true
  China_Construction_Bank=true
  China_Merchants_Bank=true
  CIBC=true
  CIC=true
  CIMB_Bank=true
  cims=true
  CitiBank=true
  Citizens_Bank=true
  Cloudn=true
  Club_J_WEST=true
  Co_operative_Bank=true
  coinbase=true
  Coincheck=true
  Columbia_University=true
  Commerce_Bank=true
  Commercial_Bank_of_Ceylon=true
  Commonwealth_Bank=true
  Compte_Nickel=true
  Consorsbank=true
  CONVERSE_JAPAN=true
  cookpad=true
  Coremail=true
  Correos=true
  Correos_Chile=true
  Costco=true
  Cox_Communications=true
  cPanel=true
  Craigslist=true
  Credit_Agricole=true
  Crelan=true
  CSOB=true
  Cybozu=true
  DanskeBank=true
  Daum=true
  DBS_Bank=true
  DBS_PayLah=true
  DeCurret=true
  Deloitte_Touche_Tohmatsu=true
  Desjardins=true
  Deutsche_Post_DHL=true
  Deutsche_Telekom_AG=true
  DHL=true
  DIE_POST=true
  Discover_bank=true
  Disney=true
  DMM=true
  docomo=true
  DocuSign=true
  DPDgroup=true
  Dropbox=true
  DTI=true
  Dyson=true
  e_Boks=true
  E_TRADE=true
  eBay=true
  EDION_Internet_Service=true
  eharmony=true
  Emirates_NBD=true
  Endesa=true
  eNETS=true
  ENGIE=true
  eoWEB_mail=true
  eo_mypage=true
  ETC_usage_inquiry_service=true
  ete=true
  Evernote=true
  Facebook=true
  FamilyMart=true
  Federal_Credit_Union=true
  Federal_Public_Service_Finance=true
  FedEx=true
  Fibank=true
  Fidelity=true
  First_Bank=true
  First_National_Bank=true
  First_National_Bank_of_Oklahoma=true
  First_Tech_Federal_Credit_Union=true
  FOREX_com=true
  forexwap=true
  FXCM=true
  FXcoin=true
  FxPro=true
  GameTrade=true
  GECU=true
  GitHub=true
  Global_Credit_Union=true
  Global_Sources=true
  GLS_Group=true
  GMO=true
  GMO_Aozora_Net_Bank=true
  GMO_click_securities=true
  GMO_coin=true
  GMX=true
  GM_coin=true
  GoDaddy=true
  GolfDigest_Online=true
  goo=true
  Google=true
  Google_Play=true
  GOV_UK=true
  Government_of_Canada=true
  Great_Southern_Bank=true
  HALIFAX=true
  Hang_Seng_Bank=true
  heteml=true
  hi_ho=true
  HiNet=true
  Home_Depot=true
  HomeAway=true
  HongKong_Post=true
  Host_Europe=true
  HSBC=true
  Hulu=true
  Huntington_Bank=true
  Huobi=true
  iAEON=true
  IBERCAJA=true
  iberCaja_Banco=true
  Iceland_Post=true
  iCloud=true
  iD=true
  Idaho_Central_Credit_Union=true
  Immowelt_AG=true
  Impots_gouv_fr=true
  Indiana_University=true
  ING=true
  Instagram=true
  Interac=true
  Intesa_Sanpaolo=true
  Intuit=true
  IOC=true
  IONOS=true
  IRISPLAZA=true
  IRS=true
  ISETAN_MITSUKOSHI=true
  Israel_Postal_Company=true
  Itau=true
  iTSCOM=true
  iTunes_Connect=true
  J_COM=true
  JACCS=true
  JAL=true
  JA_bank=true
  JCB=true
  Joshin=true
  JPMorgan_Chase=true
  KC_Card=true
  KCN_Kyoto=true
  KDDI=true
  Keesler_Federal_Credit=true
  keio_jp=true
  Key_Bank=true
  Kiwibank=true
  Knet=true
  KONAMI=true
  KuCoin=true
  La_Banque_Postale=true
  LCV=true
  LIFE_CARD=true
  LINE=true
  Linio=true
  Linked_in=true
  LinkedIn=true
  LLOYDS_BANK=true
  Locaweb=true
  Loft=true
  LOWYA=true
  Luno=true
  M_and_T_Bank=true
  Made_in_China_com=true
  MAERSK=true
  Magazine_Luiza=true
  Magyar_Posta=true
  majica=true
  Mastercard=true
  MB_Bank=true
  MBH_Bank=true
  McKinsey_and_Campany=true
  MEGA_EGG=true
  MercadoPago=true
  Merpay=true
  Meta=true
  MetaBank=true
  Metamask=true
  Metro_Bank=true
  MHB_Bank=true
  MICARD=true
  Microsoft=true
  MIKIMOTO=true
  MitID=true
  Mizuno=true
  MKB_Bank=true
  mobile_de=true
  Mondial_Relay=true
  MoneyGram=true
  Monster_Strike=true
  mont_bell=true
  Mountain_America_Credit_Union=true
  MTR_Corporation=true
  MUFG_Nicos=true
  MVM_next=true
  MWEB=true
  MY_TS3=true
  MyEtherWallet=true
  MyLink=true
  N_PLANET=true
  NAB=true
  National_Bank_of_Canada=true
  National_Health_Service=true
  National_Tax_and_Customs_A_of_H=true
  NatWest=true
  NAVER=true
  Navy_Federal_Credit_Union=true
  NEDBANK=true
  NemID=true
  NET_EASE=true
  NetBank=true
  NetCologne=true
  Neteller=true
  Netflix=true
  Nets=true
  New_Balance=true
  New_Zealand_Post=true
  Nexi_Payments=true
  NHK=true
  NHK_plus=true
  Nickel=true
  NICOS=true
  nifty=true
  Nojima=true
  Nominalia=true
  Nordea=true
  Northeastern_University=true
  Novo_Banco=true
  NTT_docomo=true
  NTT_if=true
  OANDA_japan=true
  OC_CARD=true
  OCBC_Bank=true
  OCN=true
  ODN=true
  Office365=true
  OKEx=true
  Okta=true
  OKX=true
  OneDrive=true
  OP_Bank=true
  Optimum=true
  Optus=true
  Orico=true
  Orsted=true
  Osaka_University=true
  OTP_Bank=true
  Our_Earth_Project=true
  Outlook_Web_App=true
  Outlook_com=true
  OVH=true
  Pacific_Western_Bank=true
  PagSeguro=true
  Paidy=true
  PARCO=true
  Park_National_Bank=true
  PayLife=true
  PayPal=true
  PayPal_JP=true
  PayPay=true
  PayPay_Bank=true
  PayPay_bank=true
  PBZ_CARD=true
  PCMAX=true
  Pentagon_Federal_Credit_Union=true
  Piraeus_Bank=true
  PKO_Bank_Polski=true
  PNC=true
  Ponta_Web=true
  Post_Nord=true
  Postbank=true
  Poste_Italiane=true
  Posten_Norge=true
  PROX_SYSTEM_DESIGN=true
  QuickBooks=true
  Rabobank=true
  Rackspace=true
  Raiffeisen_Bank=true
  Rakuten=true
  Randolph_Brooks_Federal_Credit_Union=true
  Ray_Ban=true
  RBC_Financial_Group=true
  RBC_Royal_Bank=true
  RBL_BANK=true
  RECRUIT=true
  Recruit=true
  RegioBank=true
  REGIONS=true
  Register_it=true
  RESTA=true
  RisuMail=true
  Roundcube_Webmail=true
  Royal_Mail=true
  Sacombank=true
  Sagawa_Express=true
  SAISON_CARD=true
  SAISON_FUNDEX=true
  Sakura_Internet=true
  Santander=true
  SARS_eFILING=true
  Saxo_Bank=true
  SBI_VC_Trade=true
  SBJ_bank=true
  Scotiabank=true
  SecureMX=true
  SF_Express=true
  SharePoint=true
  Simmons_University=true
  Simplii_Financial=true
  Singapore_Exchange_Limited=true
  Singapore_Police_Force=true
  Singapore_Post=true
  Singtel=true
  sixcore=true
  SMBC_Card=true
  SMBC_Finance_Service=true
  SMBC_Mobit=true
  Smiles=true
  Snapchat=true
  SNKRDUNK=true
  SNS_Bank=true
  so_net=true
  softbank=true
  South_African_Revenue_Service=true
  SpareBank_1=true
  Sparkasse=true
  SPD_BANK=true
  SpinNet=true
  Spotify=true
  SQUARE_ENIX=true
  Squarespace=true
  Standard_Bank=true
  STCU=true
  Steam=true
  Steam_Community=true
  STNet=true
  STRATO=true
  Suncoast_Credit_Union=true
  Suncorp_Bank=true
  SUNTRUST=true
  Sure=true
  Svenska_Handelsbanken=true
  Swiss_Post=true
  Swisscom=true
  Symantec=true
  SYNCDOT_WebMailer=true
  TARGOBANK=true
  TASAKI=true
  TD_Bank=true
  Telegram=true
  Telenor=true
  Telia=true
  TEPCO=true
  TESCO=true
  The_Co_operative_Bank=true
  The_University_of_British_Columbia=true
  THERMOS=true
  TikTok=true
  Tinkoff_Bank=true
  TOKAI_network_club=true
  Trip_com=true
  Truist_Bank=true
  Trust_Wallet=true
  TS_CUBIC_CARD=true
  TS_CUBIC_CARD_MY_TS3=true
  TSB_bank=true
  TUYA=true
  TV_Licensing=true
  Twitter=true
  U_S_Bank=true
  Uber=true
  UbiqMail=true
  UC_Card=true
  UCOM=true
  UCS_card=true
  Unicaja_Banco=true
  UniCredit_Banca=true
  UniCredit_Banca_di_Roma=true
  UniCredit_Bulbank=true
  Union_Bank_of_the_Philippines=true
  UNIQLO=true
  United_Bulgarian_Bank=true
  United_Overseas_Bank=true
  United_Parcel_Service_Inc=true
  University_at_Buffalo=true
  University_of_Innsbruck=true
  University_of_Turku=true
  University_of_Wollongong=true
  UPC_Switzerland=true
  USAA=true
  USPS=true
  Vanilla_Visa_gift_card=true
  Vantage_West_Credit_Union=true
  Verizon=true
  Vietcombank=true
  Viewcard=true
  Virgin_Media=true
  Virgin_Money=true
  VISA=true
  VISA_MasterCard=true
  VIVA_HOME=true
  Vodafone=true
  Volksbanken_Raiffeisenbanken=true
  Vpass=true
  VPBank=true
  WADAX=true
  WAKWAK=true
  WalletConnect=true
  WebMail=true
  WebMoney=true
  Wells_Fargo=true
  Western_Union=true
  WeTransfer=true
  WhatsApp=true
  Wise=true
  workday=true
  Wpc_ONLINE_STORE=true
  XFINITY=true
  XPRICE=true
  XT_COM=true
  Yahoo=true
  Yahoo_JAPAN=true
  Yodobashi_Camera=true
  Zaif=true
  ZERO=true
  Ziggo=true
  zimbra=true
  ZoomInfo=true
  ZOZOTOWN=true
  ACOM=true
  Aplus=true
  Aflac_life_insurance=true
  Alpha_Webmail=true
  alpha_mail=true
  AEON_card=true
  AEON_bank=true
  Ekinet=true
  X_Server=true
  X_Server_Co_Ltd=true
  Edion=true
  epos_card=true
  Work_picara_webmail=true
  name_com=true
  Medicine_navigation=true
  Kagoya_Japan=true
  Credit_Saison=true
  sakura_internet=true
  Sunmark_Publishing=true
  jibun_bank=true
  Japanet_Takata=true
  Japan_Net_Bank=true
  Jalan=true
  star_jewelry=true
  Suruga_Bank=true
  seven_bank=true
  Sogo=true
  sony_bank=true
  chocom_credit=true
  tv_komatsu=true
  toyota_finance=true
  Nissenlen_Escort=true
  Nippon_Renta_Car=true
  Nitori=true
  net_owl=true
  Bermuda=true
  Hikari_TV=true
  Bic_camera=true
  bit_point_japan=true
  Plala=true
  promise=true
  Bunbun_Net=true
  pocket_card=true
  Mizuho_Financial_Group=true
  Mizuho_Bank=true
  Mizuho_Securities=true
  Mizuho_Trust_Bank=true
  Minato_Bank=true
  media_wars=true
  mercari=true
  Mobile_Suica=true
  yamato_financial=true
  Yamato_Transport=true
  Japan_Post_Bank=true
  dream_card=true
  yodobashi_camera=true
  lifenet_life=true
  Rakuma=true
  Resona_card=true
  Resona_Bank=true
  Remise=true
  Lawson_Bank=true
  Works_Mobile_Japan=true
  Ehime_CATV=true
  Yokohama_Bank=true
  Okinawa_Bank=true
  Okinawa_Electric_Power=true
  furniture_350=true
  Gaitame_com=true
  rakuten=true
  rakuten_card=true
  rakuten_Bank=true
  Rakuten_Securities=true
  Cable_Joy=true
  Kansai_Mirai_Bank=true
  Kansai_Electric_Power=true
  Kiyo_Bank=true
  Keihan_Department_Store=true
  Kyoto_Bank=true
  Kanazawa_University=true
  kyushu_card=true
  Kyushu_University=true
  Keio_University=true
  Ministry_of_Health=true
  National_Tax_Agency=true
  Ministry_of_Finance=true
  Saitama_Resona_Bank=true
  Sapporo_Medical_University=true
  Mitsui_Sumitomo_Bank_Card=true
  Sumitomo_Mitsui_Trust_Club=true
  Sumitomo_Mitsui_Banking_Corporation=true
  Sumitomo_Mitsui_Trust_Bank=true
  Mitsukoshi_Isetan=true
  Mitsubishi_HC_Capital=true
  Mitsubishi_UFJ_Nicos=true
  Mitsubishi_UFJ_Financial_Group=true
  Mitsubishi_UFJ_Bank=true
  Mitsubishi_UFJ_Trust_and_Banking=true
  Yamaguchi_Cable_Vision=true
  Yamazen=true
  Shiga_University_of_Medical_Science=true
  Kagoshima_University=true
  seventy_seven_bank=true
  Akita_Bank=true
  Sumishin_SBI_Net_Bank=true
  sumitomo_life=true
  Eighteen_Shinwa_Bank=true
  Juroku_Bank=true
  Idemitsu_credit=true
  Delivery_hall=true
  Odakyu_Department_Store=true
  Zojirushi_Direct=true
  Shanghai_Pudong_Development_Bank=true
  Niigata_University=true
  Shinsei_Financial=true
  Shinsei_Bank=true
  Kanagawa_Bank=true
  Kanagawa_University=true
  Nishinippon_City_Bank=true
  Shizuoka_Bank=true
  Customs=true
  Chiba_Bank=true
  Ministry_of_Internal_Affairs_and_Communications=true
  Daimaru_Matsuzakaya_Card=true
  Osaka_Shinkin_Bank=true
  Osaka_University=true
  Daiwa_Next_Bank=true
  Industrial_and_Commercial_Bank_of_China=true
  Agricultural_Bank_of_China=true
  Asahi_Life_Insurance=true
  tokyu_card=true
  Tokyo_Gas=true
  Tokyo_Medical_and_Dental_University=true
  University_of_Tokyo=true
  Tokyo_Metropolitan_Bureau_of_Waterworks=true
  Tohoku_University=true
  Tohoku_Electric_Power=true
  Fujii_Daimaru=true
  Japan_UNICEF_Association=true
  bank_of_japan=true
  Japan_Exchange_Group=true
  Nippon_Life_Insurance=true
  Japanese_Red_Cross_Society=true
  Nihon_University=true
  Japan_Pension_Service=true
  Japan_Post=true
  Certified_NPO_Florence=true
  Fukui_cable_television=true
  Fukuoka_Bank=true
  Heian_Bank=true
  Hokkaido_Bank=true
  Hokkaido_Electric_Power=true
  North_Pacific_Bank=true
  Kitasato_University=true
  Nagoya_City_University=true
  Nagoya_University=true
  Meiji_Yasuda_Life_Insurance=true
  Nomura=true
  Nomura_Holdings=true
  RIKEN=true
  Ryukyu_Bank=true
  Reinan_Cable_Network=true

  comment=$(
    cat << EOF
# phishing URL List
# Blocking Web Browser
#
# References: https://github.com/JPCERTCC/phishurl-list/
# definition: https://virtualitypage.github.io/DNS_BlockList/phishing/block.txt
#
# Last modified: 25 March 2024
#
EOF
  )
  echo "$comment" >> "$main_file"

  if [ -e "$sub_file" ]; then
    sed -e 's/[^,]*,//' "$sub_file" > "$sub_copy" # 1列目を削除
    while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
      col1=$(echo "$col1" | sed -e 's/http:\/\//0.0.0.0 /g' -e 's/https:\/\//0.0.0.0 /g' -e 's/\/$//')
      col2=$(echo "$col2" | tr -d '\r')
      if $At_nifty && [ "$col2" = "@nifty" ]; then
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        At_nifty=false
      elif $At_TCOM && [ "$col2" = "@TCOM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        At_TCOM=false
      elif $one_and_one_Ionos && [ "$col2" = "1&1 Ionos" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        one_and_one_Ionos=false
      elif $second_STREET && [ "$col2" = "2nd STREET" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        second_STREET=false
      elif $Three_D_secure && [ "$col2" = "3Dセキュア" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Three_D_secure=false
      elif $Aone_Telekom_Austria && [ "$col2" = "A1 Telekom Austria" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Aone_Telekom_Austria=false
      elif $ABSA_Bank && [ "$col2" = "ABSA Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ABSA_Bank=false
      elif $ACCESSTRADE && [ "$col2" = "ACCESSTRADE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ACCESSTRADE=false
      elif $ACROSS_Webmail && [ "$col2" = "ACROSS Webmail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ACROSS_Webmail=false
      elif $Active_mail && [ "$col2" = "Active!mail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Active_mail=false
      elif $Adobe && [ "$col2" = "Adobe" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Adobe=false
      elif $Agencia_Tributaria && [ "$col2" = "Agencia Tributaria" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Agencia_Tributaria=false
      elif $AGRIBANK && [ "$col2" = "AGRIBANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AGRIBANK=false
      elif $airbnb && [ "$col2" = "airbnb" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        airbnb=false
      elif $Alaska_USA && [ "$col2" = "Alaska USA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Alaska_USA=false
      elif $Alibaba_com && [ "$col2" = "Alibaba.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Alibaba_com=false
      elif $Alpha_Bank && [ "$col2" = "Alpha Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Alpha_Bank=false
      elif $Amazon && [ "$col2" = "Amazon" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Amazon=false
      elif $Americas_First_Federal_Credit_Union && [ "$col2" = "America's First Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Americas_First_Federal_Credit_Union=false
      elif $American_Express && [ "$col2" = "American Express" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        American_Express=false
      elif $Americanas && [ "$col2" = "Americanas" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Americanas=false
      elif $AMP_Limited && [ "$col2" = "AMP Limited" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AMP_Limited=false
      elif $ANA && [ "$col2" = "ANA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ANA=false
      elif $ANZ && [ "$col2" = "ANZ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ANZ=false
      elif $AOL && [ "$col2" = "AOL" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AOL=false
      elif $Apple_ID && [ "$col2" = "Apple ID" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Apple_ID=false
      elif $Apple_Pay && [ "$col2" = "Apple Pay" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Apple_Pay=false
      elif $Apple_Store && [ "$col2" = "Apple Store" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Apple_Store=false
      elif $Aramex && [ "$col2" = "Aramex" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Aramex=false
      elif $Arcor && [ "$col2" = "Arcor" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Arcor=false
      elif $Argenta && [ "$col2" = "Argenta" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Argenta=false
      elif $ARNES && [ "$col2" = "ARNES" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ARNES=false
      elif $Aruba_SpA && [ "$col2" = "Aruba S.p.A." ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Aruba_SpA=false
      elif $ASAHI_net && [ "$col2" = "ASAHIネット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ASAHI_net=false
      elif $ACB && [ "$col2" = "ASIA COMMERCIAL BANK(ACB)" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ACB=false
      elif $ASOVIEW && [ "$col2" = "ASOVIEW" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ASOVIEW=false
      elif $AT_and_T && [ "$col2" = "AT&T" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AT_and_T=false
      elif $ATB_Financial && [ "$col2" = "ATB Financial" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ATB_Financial=false
      elif $au && [ "$col2" = "au" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        au=false
      elif $Australia_Post && [ "$col2" = "Australia Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Australia_Post=false
      elif $Australian_Government && [ "$col2" = "Australian Government" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Australian_Government=false
      elif $AutoScout24 && [ "$col2" = "AutoScout24" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AutoScout24=false
      elif $avis && [ "$col2" = "avis" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        avis=false
      elif $AXA && [ "$col2" = "AXA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AXA=false
      elif $AXIS_BANK && [ "$col2" = "AXIS BANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AXIS_BANK=false
      elif $BAN_BAN_networks && [ "$col2" = "BAN-BANネットワークス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BAN_BAN_networks=false
      elif $Banca_Intesa && [ "$col2" = "Banca Intesa" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banca_Intesa=false
      elif $BMdPdS && [ "$col2" = "Banca Monte dei Paschi di Siena" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BMdPdS=false
      elif $Banco_do_Brasil && [ "$col2" = "Banco do Brasil" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banco_do_Brasil=false
      elif $Banco_Galicia && [ "$col2" = "Banco Galicia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banco_Galicia=false
      elif $Banco_Sabadell && [ "$col2" = "Banco Sabadell" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banco_Sabadell=false
      elif $Banco_Santander && [ "$col2" = "Banco Santander (Brasil) S.A." ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banco_Santander=false
      elif $Banco_Supervielle && [ "$col2" = "Banco Supervielle" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Banco_Supervielle=false
      elif $BancoEstado && [ "$col2" = "BancoEstado" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BancoEstado=false
      elif $Bancolombia && [ "$col2" = "Bancolombia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bancolombia=false
      elif $BancorpSouth && [ "$col2" = "BancorpSouth" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BancorpSouth=false
      elif $Bangkok_Bank && [ "$col2" = "Bangkok Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bangkok_Bank=false
      elif $Bank_AL_Habib && [ "$col2" = "Bank AL Habib" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_AL_Habib=false
      elif $Bank_of_America && [ "$col2" = "Bank of America" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_America=false
      elif $Bank_of_China && [ "$col2" = "Bank of China" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_China=false
      elif $Bank_of_China_HK && [ "$col2" = "Bank of China (Hong Kong)" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_China_HK=false
      elif $Bank_of_Cyprus && [ "$col2" = "Bank of Cyprus" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_Cyprus=false
      elif $Bank_of_Ireland && [ "$col2" = "Bank of Ireland" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_Ireland=false
      elif $Bank_Of_Montreal && [ "$col2" = "Bank Of Montreal" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_Of_Montreal=false
      elif $Bank_of_New_Zealand && [ "$col2" = "Bank of New Zealand" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_New_Zealand=false
      elif $Bank_of_the_Philippine_Islands && [ "$col2" = "Bank of the Philippine Islands" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bank_of_the_Philippine_Islands=false
      elif $BankID_BankAxept && [ "$col2" = "BankID BankAxept" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BankID_BankAxept=false
      elif $BANQUE_NATIONALE_DU_CANADA && [ "$col2" = "BANQUE NATIONALE DU CANADA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BANQUE_NATIONALE_DU_CANADA=false
      elif $Barclays_Bank && [ "$col2" = "Barclays Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Barclays_Bank=false
      elif $BAWAG_PSK && [ "$col2" = "BAWAG P.S.K." ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BAWAG_PSK=false
      elif $BB_and_T && [ "$col2" = "BB&T" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BB_and_T=false
      elif $BBIQ && [ "$col2" = "BBIQ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BBIQ=false
      elif $BBIQ_Kyushu_Communication_Network && [ "$col2" = "BBIQ 九州通信ネットワーク株式会社" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BBIQ_Kyushu_Communication_Network=false
      elif $BBVA && [ "$col2" = "BBVA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BBVA=false
      elif $BDO_Unibank && [ "$col2" = "BDO Unibank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BDO_Unibank=false
      elif $Bell_Canada && [ "$col2" = "Bell Canada" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bell_Canada=false
      elif $Bendigo_Bank && [ "$col2" = "Bendigo Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bendigo_Bank=false
      elif $BFCU && [ "$col2" = "Bethpage Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BFCU=false
      elif $biccamera && [ "$col2" = "biccamera" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        biccamera=false
      elif $BIGLOBE && [ "$col2" = "BIGLOBE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BIGLOBE=false
      elif $BINANCE && [ "$col2" = "BINANCE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BINANCE=false
      elif $bitbank && [ "$col2" = "bitbank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        bitbank=false
      elif $BitCash && [ "$col2" = "BitCash" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BitCash=false
      elif $bitFlyer && [ "$col2" = "bitFlyer" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        bitFlyer=false
      elif $BitMEX && [ "$col2" = "BitMEX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BitMEX=false
      elif $Bitstamp && [ "$col2" = "Bitstamp" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bitstamp=false
      elif $BitTrade && [ "$col2" = "BitTrade" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BitTrade=false
      elif $Blackboard && [ "$col2" = "Blackboard" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Blackboard=false
      elif $Blockchain && [ "$col2" = "Blockchain" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Blockchain=false
      elif $BMO && [ "$col2" = "BMO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BMO=false
      elif $BNL && [ "$col2" = "BNL" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BNL=false
      elif $BNP_Paribas && [ "$col2" = "BNP Paribas" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BNP_Paribas=false
      elif $Booking_com && [ "$col2" = "Booking.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Booking_com=false
      elif $Boursorama && [ "$col2" = "Boursorama" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Boursorama=false
      elif $box && [ "$col2" = "box" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        box=false
      elif $BPER_Banca && [ "$col2" = "BPER Banca" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BPER_Banca=false
      elif $BPI && [ "$col2" = "BPI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BPI=false
      elif $bpost && [ "$col2" = "bpost" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        bpost=false
      elif $Bradesco && [ "$col2" = "Bradesco" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bradesco=false
      elif $Brazil_Ministry && [ "$col2" = "Brazil Ministry of Agriculture, Livestock, and Food Supply" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Brazil_Ministry=false
      elif $BT && [ "$col2" = "BT" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BT=false
      elif $BTCBOX && [ "$col2" = "BTCBOX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        BTCBOX=false
      elif $Caixa && [ "$col2" = "Caixa" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Caixa=false
      elif $Canada_Revenue_Agency && [ "$col2" = "Canada Revenue Agency" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Canada_Revenue_Agency=false
      elif $Canonet && [ "$col2" = "Canonet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Canonet=false
      elif $Capital_One && [ "$col2" = "Capital One" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Capital_One=false
      elif $Capitec_bank && [ "$col2" = "Capitec bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Capitec_bank=false
      elif $Carrefour && [ "$col2" = "Carrefour" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Carrefour=false
      elif $Casas_Bahia && [ "$col2" = "Casas Bahia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Casas_Bahia=false
      elif $Cashplus && [ "$col2" = "Cashplus" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cashplus=false
      elif $Cathay_Pacific_Airways && [ "$col2" = "Cathay Pacific Airways" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cathay_Pacific_Airways=false
      elif $CenturyLink && [ "$col2" = "CenturyLink" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CenturyLink=false
      elif $Charles_Schwab && [ "$col2" = "Charles Schwab" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Charles_Schwab=false
      elif $Charles_Sturt_University && [ "$col2" = "Charles Sturt University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Charles_Sturt_University=false
      elif $CHASE && [ "$col2" = "CHASE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CHASE=false
      elif $China_CITIC_Bank && [ "$col2" = "China CITIC Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        China_CITIC_Bank=false
      elif $China_Construction_Bank && [ "$col2" = "China Construction Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        China_Construction_Bank=false
      elif $China_Merchants_Bank && [ "$col2" = "China Merchants Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        China_Merchants_Bank=false
      elif $CIBC && [ "$col2" = "CIBC" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CIBC=false
      elif $CIC && [ "$col2" = "CIC" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CIC=false
      elif $CIMB_Bank && [ "$col2" = "CIMB Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CIMB_Bank=false
      elif $cims && [ "$col2" = "cims" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        cims=false
      elif $CitiBank && [ "$col2" = "CitiBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CitiBank=false
      elif $Citizens_Bank && [ "$col2" = "Citizens Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Citizens_Bank=false
      elif $Cloudn && [ "$col2" = "Cloudn" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cloudn=false
      elif $Club_J_WEST && [ "$col2" = "Club J-WEST" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Club_J_WEST=false
      elif $Co_operative_Bank && [ "$col2" = "Co-operative Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Co_operative_Bank=false
      elif $coinbase && [ "$col2" = "coinbase" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        coinbase=false
      elif $Coincheck && [ "$col2" = "Coincheck" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Coincheck=false
      elif $Columbia_University && [ "$col2" = "Columbia University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Columbia_University=false
      elif $Commerce_Bank && [ "$col2" = "Commerce Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Commerce_Bank=false
      elif $Commercial_Bank_of_Ceylon && [ "$col2" = "Commercial Bank of Ceylon" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Commercial_Bank_of_Ceylon=false
      elif $Commonwealth_Bank && [ "$col2" = "Commonwealth Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Commonwealth_Bank=false
      elif $Compte_Nickel && [ "$col2" = "Compte Nickel" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Compte_Nickel=false
      elif $Consorsbank && [ "$col2" = "Consorsbank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Consorsbank=false
      elif $CONVERSE_JAPAN && [ "$col2" = "CONVERSE JAPAN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CONVERSE_JAPAN=false
      elif $cookpad && [ "$col2" = "cookpad" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        cookpad=false
      elif $Coremail && [ "$col2" = "Coremail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Coremail=false
      elif $Correos && [ "$col2" = "Correos" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Correos=false
      elif $Correos_Chile && [ "$col2" = "Correos Chile" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Correos_Chile=false
      elif $Costco && [ "$col2" = "Costco" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Costco=false
      elif $Cox_Communications && [ "$col2" = "Cox Communications" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cox_Communications=false
      elif $cPanel && [ "$col2" = "cPanel" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        cPanel=false
      elif $Craigslist && [ "$col2" = "Craigslist" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Craigslist=false
      elif $Credit_Agricole && [ "$col2" = "Credit Agricole" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Credit_Agricole=false
      elif $Crelan && [ "$col2" = "Crelan" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Crelan=false
      elif $CSOB && [ "$col2" = "CSOB" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        CSOB=false
      elif $Cybozu && [ "$col2" = "Cybozu" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cybozu=false
      elif $DanskeBank && [ "$col2" = "DanskeBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DanskeBank=false
      elif $Daum && [ "$col2" = "Daum" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Daum=false
      elif $DBS_Bank && [ "$col2" = "DBS Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DBS_Bank=false
      elif $DBS_PayLah && [ "$col2" = "DBS PayLah" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DBS_PayLah=false
      elif $DeCurret && [ "$col2" = "DeCurret" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DeCurret=false
      elif $Deloitte_Touche_Tohmatsu && [ "$col2" = "Deloitte Touche Tohmatsu" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Deloitte_Touche_Tohmatsu=false
      elif $Desjardins && [ "$col2" = "Desjardins" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Desjardins=false
      elif $Deutsche_Post_DHL && [ "$col2" = "Deutsche Post DHL" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Deutsche_Post_DHL=false
      elif $Deutsche_Telekom_AG && [ "$col2" = "Deutsche Telekom AG" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Deutsche_Telekom_AG=false
      elif $DHL && [ "$col2" = "DHL" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DHL=false
      elif $DIE_POST && [ "$col2" = "DIE POST" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DIE_POST=false
      elif $Discover_bank && [ "$col2" = "Discover bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Discover_bank=false
      elif $Disney && [ "$col2" = "Disney" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Disney=false
      elif $DMM && [ "$col2" = "DMM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DMM=false
      elif $docomo && [ "$col2" = "docomo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        docomo=false
      elif $DocuSign && [ "$col2" = "DocuSign" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DocuSign=false
      elif $DPDgroup && [ "$col2" = "DPDgroup" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DPDgroup=false
      elif $Dropbox && [ "$col2" = "Dropbox" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Dropbox=false
      elif $DTI && [ "$col2" = "DTI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        DTI=false
      elif $Dyson && [ "$col2" = "Dyson" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Dyson=false
      elif $e_Boks && [ "$col2" = "e-Boks" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        e_Boks=false
      elif $E_TRADE && [ "$col2" = "E*TRADE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        E_TRADE=false
      elif $eBay && [ "$col2" = "eBay" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        eBay=false
      elif $EDION_Internet_Service && [ "$col2" = "EDION Internet Service" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        EDION_Internet_Service=false
      elif $eharmony && [ "$col2" = "eharmony" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        eharmony=false
      elif $Emirates_NBD && [ "$col2" = "Emirates NBD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Emirates_NBD=false
      elif $Endesa && [ "$col2" = "Endesa" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Endesa=false
      elif $eNETS && [ "$col2" = "eNETS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        eNETS=false
      elif $ENGIE && [ "$col2" = "ENGIE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ENGIE=false
      elif $eoWEB_mail && [ "$col2" = "eoWEBメール" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        eoWEB_mail=false
      elif $eo_mypage && [ "$col2" = "eoマイページ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        eo_mypage=false
      elif $ETC_usage_inquiry_service && [ "$col2" = "ETC利用照会サービス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ETC_usage_inquiry_service=false
      elif $ete && [ "$col2" = "ete" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ete=false
      elif $Evernote && [ "$col2" = "Evernote" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Evernote=false
      elif $Facebook && [ "$col2" = "Facebook" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Facebook=false
      elif $FamilyMart && [ "$col2" = "FamilyMart" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FamilyMart=false
      elif $Federal_Credit_Union && [ "$col2" = "Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Federal_Credit_Union=false
      elif $Federal_Public_Service_Finance && [ "$col2" = "Federal Public Service Finance" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Federal_Public_Service_Finance=false
      elif $FedEx && [ "$col2" = "FedEx" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FedEx=false
      elif $Fibank && [ "$col2" = "Fibank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Fibank=false
      elif $Fidelity && [ "$col2" = "Fidelity" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Fidelity=false
      elif $First_Bank && [ "$col2" = "First Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        First_Bank=false
      elif $First_National_Bank && [ "$col2" = "First National Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        First_National_Bank=false
      elif $First_National_Bank_of_Oklahoma && [ "$col2" = "First National Bank of Oklahoma" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        First_National_Bank_of_Oklahoma=false
      elif $First_Tech_Federal_Credit_Union && [ "$col2" = "First Tech Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        First_Tech_Federal_Credit_Union=false
      elif $FOREX_com && [ "$col2" = "FOREX.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FOREX_com=false
      elif $forexwap && [ "$col2" = "forexwap" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        forexwap=false
      elif $FXCM && [ "$col2" = "FXCM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FXCM=false
      elif $FXcoin && [ "$col2" = "FXcoin" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FXcoin=false
      elif $FxPro && [ "$col2" = "FxPro" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        FxPro=false
      elif $GameTrade && [ "$col2" = "GameTrade" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GameTrade=false
      elif $GECU && [ "$col2" = "GECU" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GECU=false
      elif $GitHub && [ "$col2" = "GitHub" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GitHub=false
      elif $Global_Credit_Union && [ "$col2" = "Global Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Global_Credit_Union=false
      elif $Global_Sources && [ "$col2" = "Global Sources" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Global_Sources=false
      elif $GLS_Group && [ "$col2" = "GLS Group" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GLS_Group=false
      elif $GMO && [ "$col2" = "GMO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GMO=false
      elif $GMO_Aozora_Net_Bank && [ "$col2" = "GMOあおぞらネット銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GMO_Aozora_Net_Bank=false
      elif $GMO_click_securities && [ "$col2" = "GMOクリック証券" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GMO_click_securities=false
      elif $GMO_coin && [ "$col2" = "GMOコイン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GMO_coin=false
      elif $GMX && [ "$col2" = "GMX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GMX=false
      elif $GM_coin && [ "$col2" = "GMコイン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GM_coin=false
      elif $GoDaddy && [ "$col2" = "GoDaddy" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GoDaddy=false
      elif $GolfDigest_Online && [ "$col2" = "GolfDigest Online" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GolfDigest_Online=false
      elif $goo && [ "$col2" = "goo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        goo=false
      elif $Google && [ "$col2" = "Google" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Google=false
      elif $Google_Play && [ "$col2" = "Google Play" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Google_Play=false
      elif $GOV_UK && [ "$col2" = "GOV.UK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        GOV_UK=false
      elif $Government_of_Canada && [ "$col2" = "Government of Canada" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Government_of_Canada=false
      elif $Great_Southern_Bank && [ "$col2" = "Great Southern Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Great_Southern_Bank=false
      elif $HALIFAX && [ "$col2" = "HALIFAX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        HALIFAX=false
      elif $Hang_Seng_Bank && [ "$col2" = "Hang Seng Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Hang_Seng_Bank=false
      elif $heteml && [ "$col2" = "heteml" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        heteml=false
      elif $hi_ho && [ "$col2" = "hi-ho" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        hi_ho=false
      elif $HiNet && [ "$col2" = "HiNet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        HiNet=false
      elif $Home_Depot && [ "$col2" = "Home Depot" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Home_Depot=false
      elif $HomeAway && [ "$col2" = "HomeAway" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        HomeAway=false
      elif $HongKong_Post && [ "$col2" = "HongKong Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        HongKong_Post=false
      elif $Host_Europe && [ "$col2" = "Host Europe" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Host_Europe=false
      elif $HSBC && [ "$col2" = "HSBC" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        HSBC=false
      elif $Hulu && [ "$col2" = "Hulu" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Hulu=false
      elif $Huntington_Bank && [ "$col2" = "Huntington Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Huntington_Bank=false
      elif $Huobi && [ "$col2" = "Huobi" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Huobi=false
      elif $iAEON && [ "$col2" = "iAEON" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iAEON=false
      elif $IBERCAJA && [ "$col2" = "IBERCAJA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        IBERCAJA=false
      elif $iberCaja_Banco && [ "$col2" = "iberCaja Banco" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iberCaja_Banco=false
      elif $Iceland_Post && [ "$col2" = "Iceland Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Iceland_Post=false
      elif $iCloud && [ "$col2" = "iCloud" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iCloud=false
      elif $iD && [ "$col2" = "iD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iD=false
      elif $Idaho_Central_Credit_Union && [ "$col2" = "Idaho Central Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Idaho_Central_Credit_Union=false
      elif $Immowelt_AG && [ "$col2" = "Immowelt AG" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Immowelt_AG=false
      elif $Impots_gouv_fr && [ "$col2" = "Impots.gouv.fr" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Impots_gouv_fr=false
      elif $Indiana_University && [ "$col2" = "Indiana University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Indiana_University=false
      elif $ING && [ "$col2" = "ING" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ING=false
      elif $Instagram && [ "$col2" = "Instagram" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Instagram=false
      elif $Interac && [ "$col2" = "Interac" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Interac=false
      elif $Intesa_Sanpaolo && [ "$col2" = "Intesa Sanpaolo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Intesa_Sanpaolo=false
      elif $Intuit && [ "$col2" = "Intuit" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Intuit=false
      elif $IOC && [ "$col2" = "IOC" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        IOC=false
      elif $IONOS && [ "$col2" = "IONOS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        IONOS=false
      elif $IRISPLAZA && [ "$col2" = "IRISPLAZA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        IRISPLAZA=false
      elif $IRS && [ "$col2" = "IRS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        IRS=false
      elif $ISETAN_MITSUKOSHI && [ "$col2" = "ISETAN MITSUKOSHI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ISETAN_MITSUKOSHI=false
      elif $Israel_Postal_Company && [ "$col2" = "Israel Postal Company" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Israel_Postal_Company=false
      elif $Itau && [ "$col2" = "Itau" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Itau=false
      elif $iTSCOM && [ "$col2" = "iTSCOM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iTSCOM=false
      elif $iTunes_Connect && [ "$col2" = "iTunes Connect" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        iTunes_Connect=false
      elif $J_COM && [ "$col2" = "J:COM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        J_COM=false
      elif $JACCS && [ "$col2" = "JACCS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        JACCS=false
      elif $JAL && [ "$col2" = "JAL" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        JAL=false
      elif $JA_bank && [ "$col2" = "JAバンク" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        JA_bank=false
      elif $JCB && [ "$col2" = "JCB" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        JCB=false
      elif $Joshin && [ "$col2" = "Joshin" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Joshin=false
      elif $JPMorgan_Chase && [ "$col2" = "JPMorgan Chase & Co." ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        JPMorgan_Chase=false
      elif $KC_Card && [ "$col2" = "KC Card" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        KC_Card=false
      elif $KCN_Kyoto && [ "$col2" = "KCN京都" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        KCN_Kyoto=false
      elif $KDDI && [ "$col2" = "KDDI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        KDDI=false
      elif $Keesler_Federal_Credit && [ "$col2" = "Keesler Federal Credit" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Keesler_Federal_Credit=false
      elif $keio_jp && [ "$col2" = "keio.jp" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        keio_jp=false
      elif $Key_Bank && [ "$col2" = "Key Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Key_Bank=false
      elif $Kiwibank && [ "$col2" = "Kiwibank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kiwibank=false
      elif $Knet && [ "$col2" = "Knet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Knet=false
      elif $KONAMI && [ "$col2" = "KONAMI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        KONAMI=false
      elif $KuCoin && [ "$col2" = "KuCoin" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        KuCoin=false
      elif $La_Banque_Postale && [ "$col2" = "La Banque Postale" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        La_Banque_Postale=false
      elif $LCV && [ "$col2" = "LCV" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LCV=false
      elif $LIFE_CARD && [ "$col2" = "LIFE CARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LIFE_CARD=false
      elif $LINE && [ "$col2" = "LINE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LINE=false
      elif $Linio && [ "$col2" = "Linio" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Linio=false
      elif $Linked_in && [ "$col2" = "Linked in" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Linked_in=false
      elif $LinkedIn && [ "$col2" = "LinkedIn" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LinkedIn=false
      elif $LLOYDS_BANK && [ "$col2" = "LLOYDS BANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LLOYDS_BANK=false
      elif $Locaweb && [ "$col2" = "Locaweb" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Locaweb=false
      elif $Loft && [ "$col2" = "Loft" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Loft=false
      elif $LOWYA && [ "$col2" = "LOWYA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        LOWYA=false
      elif $Luno && [ "$col2" = "Luno" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Luno=false
      elif $M_and_T_Bank && [ "$col2" = "M&T Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        M_and_T_Bank=false
      elif $Made_in_China_com && [ "$col2" = "Made-in-China.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Made_in_China_com=false
      elif $MAERSK && [ "$col2" = "MAERSK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MAERSK=false
      elif $Magazine_Luiza && [ "$col2" = "Magazine Luiza" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Magazine_Luiza=false
      elif $Magyar_Posta && [ "$col2" = "Magyar Posta" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Magyar_Posta=false
      elif $majica && [ "$col2" = "majica" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        majica=false
      elif $Mastercard && [ "$col2" = "Mastercard" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mastercard=false
      elif $MB_Bank && [ "$col2" = "MB Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MB_Bank=false
      elif $MBH_Bank && [ "$col2" = "MBH Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MBH_Bank=false
      elif $McKinsey_and_Campany && [ "$col2" = "McKinsey & Campany" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        McKinsey_and_Campany=false
      elif $MEGA_EGG && [ "$col2" = "MEGA EGG" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MEGA_EGG=false
      elif $MercadoPago && [ "$col2" = "MercadoPago" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MercadoPago=false
      elif $Merpay && [ "$col2" = "Merpay" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Merpay=false
      elif $Meta && [ "$col2" = "Meta" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Meta=false
      elif $MetaBank && [ "$col2" = "MetaBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MetaBank=false
      elif $Metamask && [ "$col2" = "Metamask" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Metamask=false
      elif $Metro_Bank && [ "$col2" = "Metro Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Metro_Bank=false
      elif $MHB_Bank && [ "$col2" = "MHB Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MHB_Bank=false
      elif $MICARD && [ "$col2" = "MICARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MICARD=false
      elif $Microsoft && [ "$col2" = "Microsoft" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Microsoft=false
      elif $MIKIMOTO && [ "$col2" = "MIKIMOTO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MIKIMOTO=false
      elif $MitID && [ "$col2" = "MitID" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MitID=false
      elif $Mizuno && [ "$col2" = "Mizuno" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mizuno=false
      elif $MKB_Bank && [ "$col2" = "MKB Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MKB_Bank=false
      elif $mobile_de && [ "$col2" = "mobile.de" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        mobile_de=false
      elif $Mondial_Relay && [ "$col2" = "Mondial Relay" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mondial_Relay=false
      elif $MoneyGram && [ "$col2" = "MoneyGram" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MoneyGram=false
      elif $Monster_Strike && [ "$col2" = "Monster Strike" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Monster_Strike=false
      elif $mont_bell && [ "$col2" = "mont-bell" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        mont_bell=false
      elif $Mountain_America_Credit_Union && [ "$col2" = "Mountain America Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mountain_America_Credit_Union=false
      elif $MTR_Corporation && [ "$col2" = "MTR Corporation" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MTR_Corporation=false
      elif $MUFG_Nicos && [ "$col2" = "MUFG Nicos" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MUFG_Nicos=false
      elif $MVM_next && [ "$col2" = "MVM next" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MVM_next=false
      elif $MWEB && [ "$col2" = "MWEB" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MWEB=false
      elif $MY_TS3 && [ "$col2" = "MY TS3" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MY_TS3=false
      elif $MyEtherWallet && [ "$col2" = "MyEtherWallet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MyEtherWallet=false
      elif $MyLink && [ "$col2" = "MyLink" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        MyLink=false
      elif $N_PLANET && [ "$col2" = "N-PLANET" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        N_PLANET=false
      elif $NAB && [ "$col2" = "NAB" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NAB=false
      elif $National_Bank_of_Canada && [ "$col2" = "National Bank of Canada" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        National_Bank_of_Canada=false
      elif $National_Health_Service && [ "$col2" = "National Health Service" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        National_Health_Service=false
      elif $National_Tax_and_Customs_A_of_H && [ "$col2" = "National Tax and Customs Administration of Hungary" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        National_Tax_and_Customs_A_of_H=false
      elif $NatWest && [ "$col2" = "NatWest" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NatWest=false
      elif $NAVER && [ "$col2" = "NAVER" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NAVER=false
      elif $Navy_Federal_Credit_Union && [ "$col2" = "Navy Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Navy_Federal_Credit_Union=false
      elif $NEDBANK && [ "$col2" = "NEDBANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NEDBANK=false
      elif $NemID && [ "$col2" = "NemID" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NemID=false
      elif $NET_EASE && [ "$col2" = "NET EASE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NET_EASE=false
      elif $NetBank && [ "$col2" = "NetBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NetBank=false
      elif $NetCologne && [ "$col2" = "NetCologne" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NetCologne=false
      elif $Neteller && [ "$col2" = "Neteller" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Neteller=false
      elif $Netflix && [ "$col2" = "Netflix" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Netflix=false
      elif $Nets && [ "$col2" = "Nets" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nets=false
      elif $New_Balance && [ "$col2" = "New Balance" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        New_Balance=false
      elif $New_Zealand_Post && [ "$col2" = "New Zealand Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        New_Zealand_Post=false
      elif $Nexi_Payments && [ "$col2" = "Nexi Payments" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nexi_Payments=false
      elif $NHK && [ "$col2" = "NHK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NHK=false
      elif $NHK_plus && [ "$col2" = "NHKプラス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NHK_plus=false
      elif $Nickel && [ "$col2" = "Nickel" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nickel=false
      elif $NICOS && [ "$col2" = "NICOS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NICOS=false
      elif $nifty && [ "$col2" = "nifty" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        nifty=false
      elif $Nojima && [ "$col2" = "Nojima" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nojima=false
      elif $Nominalia && [ "$col2" = "Nominalia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nominalia=false
      elif $Nordea && [ "$col2" = "Nordea" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nordea=false
      elif $Northeastern_University && [ "$col2" = "Northeastern University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Northeastern_University=false
      elif $Novo_Banco && [ "$col2" = "Novo Banco" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Novo_Banco=false
      elif $NTT_docomo && [ "$col2" = "NTT docomo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NTT_docomo=false
      elif $NTT_if && [ "$col2" = "NTTイフ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        NTT_if=false
      elif $OANDA_japan && [ "$col2" = "OANDA japan" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OANDA_japan=false
      elif $OC_CARD && [ "$col2" = "OC CARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OC_CARD=false
      elif $OCBC_Bank && [ "$col2" = "OCBC Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OCBC_Bank=false
      elif $OCN && [ "$col2" = "OCN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OCN=false
      elif $ODN && [ "$col2" = "ODN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ODN=false
      elif $Office365 && [ "$col2" = "Office365" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Office365=false
      elif $OKEx && [ "$col2" = "OKEx" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OKEx=false
      elif $Okta && [ "$col2" = "Okta" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Okta=false
      elif $OKX && [ "$col2" = "OKX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OKX=false
      elif $OneDrive && [ "$col2" = "OneDrive" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OneDrive=false
      elif $OP_Bank && [ "$col2" = "OP Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OP_Bank=false
      elif $Optimum && [ "$col2" = "Optimum" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Optimum=false
      elif $Optus && [ "$col2" = "Optus" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Optus=false
      elif $Orico && [ "$col2" = "Orico" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Orico=false
      elif $Orsted && [ "$col2" = "Orsted" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Orsted=false
      elif $Osaka_University && [ "$col2" = "Osaka University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Osaka_University=false
      elif $OTP_Bank && [ "$col2" = "OTP Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OTP_Bank=false
      elif $Our_Earth_Project && [ "$col2" = "Our Earth Project" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Our_Earth_Project=false
      elif $Outlook_Web_App && [ "$col2" = "Outlook Web App" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Outlook_Web_App=false
      elif $Outlook_com && [ "$col2" = "Outlook.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Outlook_com=false
      elif $OVH && [ "$col2" = "OVH" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        OVH=false
      elif $Pacific_Western_Bank && [ "$col2" = "Pacific Western Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Pacific_Western_Bank=false
      elif $PagSeguro && [ "$col2" = "PagSeguro" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PagSeguro=false
      elif $Paidy && [ "$col2" = "Paidy" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Paidy=false
      elif $PARCO && [ "$col2" = "PARCO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PARCO=false
      elif $Park_National_Bank && [ "$col2" = "Park National Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Park_National_Bank=false
      elif $PayLife && [ "$col2" = "PayLife" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayLife=false
      elif $PayPal && [ "$col2" = "PayPal" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayPal=false
      elif $PayPal_JP && [ "$col2" = "PayPal(日本語)" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayPal_JP=false
      elif $PayPay && [ "$col2" = "PayPay" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayPay=false
      elif $PayPay_Bank && [ "$col2" = "PayPay Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayPay_Bank=false
      elif $PayPay_bank && [ "$col2" = "PayPay銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PayPay_bank=false
      elif $PBZ_CARD && [ "$col2" = "PBZ CARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PBZ_CARD=false
      elif $PCMAX && [ "$col2" = "PCMAX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PCMAX=false
      elif $Pentagon_Federal_Credit_Union && [ "$col2" = "Pentagon Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Pentagon_Federal_Credit_Union=false
      elif $Piraeus_Bank && [ "$col2" = "Piraeus Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Piraeus_Bank=false
      elif $PKO_Bank_Polski && [ "$col2" = "PKO Bank Polski" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PKO_Bank_Polski=false
      elif $PNC && [ "$col2" = "PNC" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PNC=false
      elif $Ponta_Web && [ "$col2" = "Ponta Web" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ponta_Web=false
      elif $Post_Nord && [ "$col2" = "Post Nord" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Post_Nord=false
      elif $Postbank && [ "$col2" = "Postbank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Postbank=false
      elif $Poste_Italiane && [ "$col2" = "Poste Italiane" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Poste_Italiane=false
      elif $Posten_Norge && [ "$col2" = "Posten Norge" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Posten_Norge=false
      elif $PROX_SYSTEM_DESIGN && [ "$col2" = "PROX SYSTEM DESIGN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        PROX_SYSTEM_DESIGN=false
      elif $QuickBooks && [ "$col2" = "QuickBooks" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        QuickBooks=false
      elif $Rabobank && [ "$col2" = "Rabobank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Rabobank=false
      elif $Rackspace && [ "$col2" = "Rackspace" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Rackspace=false
      elif $Raiffeisen_Bank && [ "$col2" = "Raiffeisen Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Raiffeisen_Bank=false
      elif $Rakuten && [ "$col2" = "Rakuten" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Rakuten=false
      elif $Randolph_Brooks_Federal_Credit_Union && [ "$col2" = "Randolph-Brooks Federal Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Randolph_Brooks_Federal_Credit_Union=false
      elif $Ray_Ban && [ "$col2" = "Ray-Ban" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ray_Ban=false
      elif $RBC_Financial_Group && [ "$col2" = "RBC Financial Group" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RBC_Financial_Group=false
      elif $RBC_Royal_Bank && [ "$col2" = "RBC Royal Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RBC_Royal_Bank=false
      elif $RBL_BANK && [ "$col2" = "RBL BANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RBL_BANK=false
      elif $RECRUIT && [ "$col2" = "RECRUIT" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RECRUIT=false
      elif $Recruit && [ "$col2" = "Recruit" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Recruit=false
      elif $RegioBank && [ "$col2" = "RegioBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RegioBank=false
      elif $REGIONS && [ "$col2" = "REGIONS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        REGIONS=false
      elif $Register_it && [ "$col2" = "Register.it" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Register_it=false
      elif $RESTA && [ "$col2" = "RESTA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RESTA=false
      elif $RisuMail && [ "$col2" = "RisuMail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RisuMail=false
      elif $Roundcube_Webmail && [ "$col2" = "Roundcube Webmail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Roundcube_Webmail=false
      elif $Royal_Mail && [ "$col2" = "Royal Mail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Royal_Mail=false
      elif $Sacombank && [ "$col2" = "Sacombank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sacombank=false
      elif $Sagawa_Express && [ "$col2" = "Sagawa Express" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sagawa_Express=false
      elif $SAISON_CARD && [ "$col2" = "SAISON CARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SAISON_CARD=false
      elif $SAISON_FUNDEX && [ "$col2" = "SAISON FUNDEX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SAISON_FUNDEX=false
      elif $Sakura_Internet && [ "$col2" = "Sakura Internet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sakura_Internet=false
      elif $Santander && [ "$col2" = "Santander" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Santander=false
      elif $SARS_eFILING && [ "$col2" = "SARS eFILING" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SARS_eFILING=false
      elif $Saxo_Bank && [ "$col2" = "Saxo Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Saxo_Bank=false
      elif $SBI_VC_Trade && [ "$col2" = "SBI VC Trade" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SBI_VC_Trade=false
      elif $SBJ_bank && [ "$col2" = "SBJ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SBJ_bank=false
      elif $Scotiabank && [ "$col2" = "Scotiabank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Scotiabank=false
      elif $SecureMX && [ "$col2" = "SecureMX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SecureMX=false
      elif $SF_Express && [ "$col2" = "SF Express" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SF_Express=false
      elif $SharePoint && [ "$col2" = "SharePoint" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SharePoint=false
      elif $Simmons_University && [ "$col2" = "Simmons University" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Simmons_University=false
      elif $Simplii_Financial && [ "$col2" = "Simplii Financial" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Simplii_Financial=false
      elif $Singapore_Exchange_Limited && [ "$col2" = "Singapore Exchange Limited" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Singapore_Exchange_Limited=false
      elif $Singapore_Police_Force && [ "$col2" = "Singapore Police Force" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Singapore_Police_Force=false
      elif $Singapore_Post && [ "$col2" = "Singapore Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Singapore_Post=false
      elif $Singtel && [ "$col2" = "Singtel" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Singtel=false
      elif $sixcore && [ "$col2" = "sixcore" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        sixcore=false
      elif $SMBC_Card && [ "$col2" = "SMBC Card" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SMBC_Card=false
      elif $SMBC_Finance_Service && [ "$col2" = "SMBC ファイナンスサービス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SMBC_Finance_Service=false
      elif $SMBC_Mobit && [ "$col2" = "SMBCモビット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SMBC_Mobit=false
      elif $Smiles && [ "$col2" = "Smiles" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Smiles=false
      elif $Snapchat && [ "$col2" = "Snapchat" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Snapchat=false
      elif $SNKRDUNK && [ "$col2" = "SNKRDUNK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SNKRDUNK=false
      elif $SNS_Bank && [ "$col2" = "SNS Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SNS_Bank=false
      elif $so_net && [ "$col2" = "so-net" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        so_net=false
      elif $softbank && [ "$col2" = "softbank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        softbank=false
      elif $South_African_Revenue_Service && [ "$col2" = "South African Revenue Service" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        South_African_Revenue_Service=false
      elif $SpareBank_1 && [ "$col2" = "SpareBank 1" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SpareBank_1=false
      elif $Sparkasse && [ "$col2" = "Sparkasse" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sparkasse=false
      elif $SPD_BANK && [ "$col2" = "SPD BANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SPD_BANK=false
      elif $SpinNet && [ "$col2" = "SpinNet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SpinNet=false
      elif $Spotify && [ "$col2" = "Spotify" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Spotify=false
      elif $SQUARE_ENIX && [ "$col2" = "SQUARE ENIX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SQUARE_ENIX=false
      elif $Squarespace && [ "$col2" = "Squarespace" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Squarespace=false
      elif $Standard_Bank && [ "$col2" = "Standard Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Standard_Bank=false
      elif $STCU && [ "$col2" = "STCU" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        STCU=false
      elif $Steam && [ "$col2" = "Steam" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Steam=false
      elif $Steam_Community && [ "$col2" = "Steam Community" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Steam_Community=false
      elif $STNet && [ "$col2" = "STNet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        STNet=false
      elif $STRATO && [ "$col2" = "STRATO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        STRATO=false
      elif $Suncoast_Credit_Union && [ "$col2" = "Suncoast Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Suncoast_Credit_Union=false
      elif $Suncorp_Bank && [ "$col2" = "Suncorp Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Suncorp_Bank=false
      elif $SUNTRUST && [ "$col2" = "SUNTRUST" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SUNTRUST=false
      elif $Sure && [ "$col2" = "Sure" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sure=false
      elif $Svenska_Handelsbanken && [ "$col2" = "Svenska Handelsbanken" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Svenska_Handelsbanken=false
      elif $Swiss_Post && [ "$col2" = "Swiss Post" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Swiss_Post=false
      elif $Swisscom && [ "$col2" = "Swisscom" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Swisscom=false
      elif $Symantec && [ "$col2" = "Symantec" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Symantec=false
      elif $SYNCDOT_WebMailer && [ "$col2" = "SYNCDOT WebMailer" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        SYNCDOT_WebMailer=false
      elif $TARGOBANK && [ "$col2" = "TARGOBANK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TARGOBANK=false
      elif $TASAKI && [ "$col2" = "TASAKI" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TASAKI=false
      elif $TD_Bank && [ "$col2" = "TD Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TD_Bank=false
      elif $Telegram && [ "$col2" = "Telegram" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Telegram=false
      elif $Telenor && [ "$col2" = "Telenor" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Telenor=false
      elif $Telia && [ "$col2" = "Telia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Telia=false
      elif $TEPCO && [ "$col2" = "TEPCO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TEPCO=false
      elif $TESCO && [ "$col2" = "TESCO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TESCO=false
      elif $The_Co_operative_Bank && [ "$col2" = "The Co-operative Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        The_Co_operative_Bank=false
      elif $The_University_of_British_Columbia && [ "$col2" = "The University of British Columbia" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        The_University_of_British_Columbia=false
      elif $THERMOS && [ "$col2" = "THERMOS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        THERMOS=false
      elif $TikTok && [ "$col2" = "TikTok" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TikTok=false
      elif $Tinkoff_Bank && [ "$col2" = "Tinkoff Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tinkoff_Bank=false
      elif $TOKAI_network_club && [ "$col2" = "TOKAIネットワーククラブ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TOKAI_network_club=false
      elif $Trip_com && [ "$col2" = "Trip.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Trip_com=false
      elif $Truist_Bank && [ "$col2" = "Truist Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Truist_Bank=false
      elif $Trust_Wallet && [ "$col2" = "Trust Wallet" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Trust_Wallet=false
      elif $TS_CUBIC_CARD && [ "$col2" = "TS CUBIC CARD" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TS_CUBIC_CARD=false
      elif $TS_CUBIC_CARD_MY_TS3 && [ "$col2" = "TS CUBIC CARD_MY TS3" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TS_CUBIC_CARD_MY_TS3=false
      elif $TSB_bank && [ "$col2" = "TSB bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TSB_bank=false
      elif $TUYA && [ "$col2" = "TUYA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TUYA=false
      elif $TV_Licensing && [ "$col2" = "TV Licensing" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        TV_Licensing=false
      elif $Twitter && [ "$col2" = "Twitter" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Twitter=false
      elif $U_S_Bank && [ "$col2" = "U.S. Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        U_S_Bank=false
      elif $Uber && [ "$col2" = "Uber" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Uber=false
      elif $UbiqMail && [ "$col2" = "UbiqMail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UbiqMail=false
      elif $UC_Card && [ "$col2" = "UC Card" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UC_Card=false
      elif $UCOM && [ "$col2" = "UCOM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UCOM=false
      elif $UCS_card && [ "$col2" = "UCSカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UCS_card=false
      elif $Unicaja_Banco && [ "$col2" = "Unicaja Banco" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Unicaja_Banco=false
      elif $UniCredit_Banca && [ "$col2" = "UniCredit Banca" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UniCredit_Banca=false
      elif $UniCredit_Banca_di_Roma && [ "$col2" = "UniCredit Banca di Roma" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UniCredit_Banca_di_Roma=false
      elif $UniCredit_Bulbank && [ "$col2" = "UniCredit Bulbank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UniCredit_Bulbank=false
      elif $Union_Bank_of_the_Philippines && [ "$col2" = "Union Bank of the Philippines" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Union_Bank_of_the_Philippines=false
      elif $UNIQLO && [ "$col2" = "UNIQLO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UNIQLO=false
      elif $United_Bulgarian_Bank && [ "$col2" = "United Bulgarian Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        United_Bulgarian_Bank=false
      elif $United_Overseas_Bank && [ "$col2" = "United Overseas Bank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        United_Overseas_Bank=false
      elif $United_Parcel_Service_Inc && [ "$col2" = "United Parcel Service Inc." ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        United_Parcel_Service_Inc=false
      elif $University_at_Buffalo && [ "$col2" = "University at Buffalo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        University_at_Buffalo=false
      elif $University_of_Innsbruck && [ "$col2" = "University of Innsbruck" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        University_of_Innsbruck=false
      elif $University_of_Turku && [ "$col2" = "University of Turku" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        University_of_Turku=false
      elif $University_of_Wollongong && [ "$col2" = "University of Wollongong" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        University_of_Wollongong=false
      elif $UPC_Switzerland && [ "$col2" = "UPC Switzerland" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        UPC_Switzerland=false
      elif $USAA && [ "$col2" = "USAA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        USAA=false
      elif $USPS && [ "$col2" = "USPS" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        USPS=false
      elif $Vanilla_Visa_gift_card && [ "$col2" = "Vanilla Visa gift card" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Vanilla_Visa_gift_card=false
      elif $Vantage_West_Credit_Union && [ "$col2" = "Vantage West Credit Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Vantage_West_Credit_Union=false
      elif $Verizon && [ "$col2" = "Verizon" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Verizon=false
      elif $Vietcombank && [ "$col2" = "Vietcombank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Vietcombank=false
      elif $Viewcard && [ "$col2" = "Viewcard" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Viewcard=false
      elif $Virgin_Media && [ "$col2" = "Virgin Media" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Virgin_Media=false
      elif $Virgin_Money && [ "$col2" = "Virgin Money" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Virgin_Money=false
      elif $VISA && [ "$col2" = "VISA" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        VISA=false
      elif $VISA_MasterCard && [ "$col2" = "VISA / MasterCard" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        VISA_MasterCard=false
      elif $VIVA_HOME && [ "$col2" = "VIVA HOME" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        VIVA_HOME=false
      elif $Vodafone && [ "$col2" = "Vodafone" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Vodafone=false
      elif $Volksbanken_Raiffeisenbanken && [ "$col2" = "Volksbanken Raiffeisenbanken" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Volksbanken_Raiffeisenbanken=false
      elif $Vpass && [ "$col2" = "Vpass" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Vpass=false
      elif $VPBank && [ "$col2" = "VPBank" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        VPBank=false
      elif $WADAX && [ "$col2" = "WADAX" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WADAX=false
      elif $WAKWAK && [ "$col2" = "WAKWAK" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WAKWAK=false
      elif $WalletConnect && [ "$col2" = "WalletConnect" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WalletConnect=false
      elif $WebMail && [ "$col2" = "WebMail" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WebMail=false
      elif $WebMoney && [ "$col2" = "WebMoney" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WebMoney=false
      elif $Wells_Fargo && [ "$col2" = "Wells Fargo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Wells_Fargo=false
      elif $Western_Union && [ "$col2" = "Western Union" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Western_Union=false
      elif $WeTransfer && [ "$col2" = "WeTransfer" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WeTransfer=false
      elif $WhatsApp && [ "$col2" = "WhatsApp" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        WhatsApp=false
      elif $Wise && [ "$col2" = "Wise" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Wise=false
      elif $workday && [ "$col2" = "workday" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        workday=false
      elif $Wpc_ONLINE_STORE && [ "$col2" = "Wpc. ONLINE STORE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Wpc_ONLINE_STORE=false
      elif $XFINITY && [ "$col2" = "XFINITY" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        XFINITY=false
      elif $XPRICE && [ "$col2" = "XPRICE" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        XPRICE=false
      elif $XT_COM && [ "$col2" = "XT.COM" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        XT_COM=false
      elif $Yahoo && [ "$col2" = "Yahoo!" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yahoo=false
      elif $Yahoo_JAPAN && [ "$col2" = "Yahoo! JAPAN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yahoo_JAPAN=false
      elif $Yodobashi_Camera && [ "$col2" = "Yodobashi Camera" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yodobashi_Camera=false
      elif $Zaif && [ "$col2" = "Zaif" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Zaif=false
      elif $ZERO && [ "$col2" = "ZERO" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ZERO=false
      elif $Ziggo && [ "$col2" = "Ziggo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ziggo=false
      elif $zimbra && [ "$col2" = "zimbra" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        zimbra=false
      elif $ZoomInfo && [ "$col2" = "ZoomInfo" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ZoomInfo=false
      elif $ZOZOTOWN && [ "$col2" = "ZOZOTOWN" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ZOZOTOWN=false
      elif $ACOM && [ "$col2" = "アコム" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        ACOM=false
      elif $Aplus && [ "$col2" = "アプラス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Aplus=false
      elif $Aflac_life_insurance && [ "$col2" = "アフラック生命保険" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Aflac_life_insurance=false
      elif $Alpha_Webmail && [ "$col2" = "アルファ Webメール" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Alpha_Webmail=false
      elif $alpha_mail && [ "$col2" = "アルファメール" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        alpha_mail=false
      elif $AEON_card && [ "$col2" = "イオンカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AEON_card=false
      elif $AEON_bank && [ "$col2" = "イオン銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        AEON_bank=false
      elif $Ekinet && [ "$col2" = "えきねっと" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ekinet=false
      elif $X_Server && [ "$col2" = "エックスサーバー" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        X_Server=false
      elif $X_Server_Co_Ltd && [ "$col2" = "エックスサーバー株式会社" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        X_Server_Co_Ltd=false
      elif $Edion && [ "$col2" = "エディオン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Edion=false
      elif $epos_card && [ "$col2" = "エポスカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        epos_card=false
      elif $Work_picara_webmail && [ "$col2" = "お仕事ピカラウェブメール" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Work_picara_webmail=false
      elif $name_com && [ "$col2" = "お名前.com" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        name_com=false
      elif $Medicine_navigation && [ "$col2" = "お薬なび" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Medicine_navigation=false
      elif $Kagoya_Japan && [ "$col2" = "カゴヤ・ジャパン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kagoya_Japan=false
      elif $Credit_Saison && [ "$col2" = "クレディセゾン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Credit_Saison=false
      elif $sakura_internet && [ "$col2" = "さくらインターネット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        sakura_internet=false
      elif $Sunmark_Publishing && [ "$col2" = "サンマーク出版" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sunmark_Publishing=false
      elif $jibun_bank && [ "$col2" = "じぶん銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        jibun_bank=false
      elif $Japanet_Takata && [ "$col2" = "ジャパネットたかた" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japanet_Takata=false
      elif $Japan_Net_Bank && [ "$col2" = "ジャパンネット銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_Net_Bank=false
      elif $Jalan && [ "$col2" = "じゃらん" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Jalan=false
      elif $star_jewelry && [ "$col2" = "スタージュエリー" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        star_jewelry=false
      elif $Suruga_Bank && [ "$col2" = "スルガ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Suruga_Bank=false
      elif $seven_bank && [ "$col2" = "セブン銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        seven_bank=false
      elif $Sogo && [ "$col2" = "そごう" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sogo=false
      elif $sony_bank && [ "$col2" = "ソニー銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        sony_bank=false
      elif $chocom_credit && [ "$col2" = "ちょコムクレジット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        chocom_credit=false
      elif $tv_komatsu && [ "$col2" = "テレビ小松" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        tv_komatsu=false
      elif $toyota_finance && [ "$col2" = "トヨタファイナンス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        toyota_finance=false
      elif $Nissenlen_Escort && [ "$col2" = "ニッセンレンエスコート" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nissenlen_Escort=false
      elif $Nippon_Renta_Car && [ "$col2" = "ニッポンレンタカー" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nippon_Renta_Car=false
      elif $Nitori && [ "$col2" = "ニトリ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nitori=false
      elif $net_owl && [ "$col2" = "ネットオウル" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        net_owl=false
      elif $Bermuda && [ "$col2" = "バルミューダ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bermuda=false
      elif $Hikari_TV && [ "$col2" = "ひかりTV" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Hikari_TV=false
      elif $Bic_camera && [ "$col2" = "ビックカメラ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bic_camera=false
      elif $bit_point_japan && [ "$col2" = "ビットポイントジャパン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        bit_point_japan=false
      elif $Plala && [ "$col2" = "ぷらら" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Plala=false
      elif $promise && [ "$col2" = "プロミス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        promise=false
      elif $Bunbun_Net && [ "$col2" = "ぶんぶんネット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Bunbun_Net=false
      elif $pocket_card && [ "$col2" = "ポケットカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        pocket_card=false
      elif $Mizuho_Financial_Group && [ "$col2" = "みずほフィナンシャルグループ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mizuho_Financial_Group=false
      elif $Mizuho_Bank && [ "$col2" = "みずほ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mizuho_Bank=false
      elif $Mizuho_Securities && [ "$col2" = "みずほ証券" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mizuho_Securities=false
      elif $Mizuho_Trust_Bank && [ "$col2" = "みずほ信託銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mizuho_Trust_Bank=false
      elif $Minato_Bank && [ "$col2" = "みなと銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Minato_Bank=false
      elif $media_wars && [ "$col2" = "メディアウォーズ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        media_wars=false
      elif $mercari && [ "$col2" = "メルカリ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        mercari=false
      elif $Mobile_Suica && [ "$col2" = "モバイルSuica" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mobile_Suica=false
      elif $yamato_financial && [ "$col2" = "ヤマトフィナンシャル" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        yamato_financial=false
      elif $Yamato_Transport && [ "$col2" = "ヤマト運輸" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yamato_Transport=false
      elif $Japan_Post_Bank && [ "$col2" = "ゆうちょ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_Post_Bank=false
      elif $dream_card && [ "$col2" = "ゆめカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        dream_card=false
      elif $yodobashi_camera && [ "$col2" = "ヨドバシカメラ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        yodobashi_camera=false
      elif $lifenet_life && [ "$col2" = "ライフネット生命" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        lifenet_life=false
      elif $Rakuma && [ "$col2" = "ラクマ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Rakuma=false
      elif $Resona_card && [ "$col2" = "りそなカード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Resona_card=false
      elif $Resona_Bank && [ "$col2" = "りそな銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Resona_Bank=false
      elif $Remise && [ "$col2" = "ルミーズ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Remise=false
      elif $Lawson_Bank && [ "$col2" = "ローソン銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Lawson_Bank=false
      elif $Works_Mobile_Japan && [ "$col2" = "ワークスモバイルジャパン株式会社" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Works_Mobile_Japan=false
      elif $Ehime_CATV && [ "$col2" = "愛媛CATV" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ehime_CATV=false
      elif $Yokohama_Bank && [ "$col2" = "横浜銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yokohama_Bank=false
      elif $Okinawa_Bank && [ "$col2" = "沖縄銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Okinawa_Bank=false
      elif $Okinawa_Electric_Power && [ "$col2" = "沖縄電力" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Okinawa_Electric_Power=false
      elif $furniture_350 && [ "$col2" = "家具350" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        furniture_350=false
      elif $Gaitame_com && [ "$col2" = "外為どっとコム" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Gaitame_com=false
      elif $rakuten && [ "$col2" = "楽天" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        rakuten=false
      elif $rakuten_card && [ "$col2" = "楽天カード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        rakuten_card=false
      elif $rakuten_Bank && [ "$col2" = "楽天銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        rakuten_Bank=false
      elif $Rakuten_Securities && [ "$col2" = "楽天証券" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Rakuten_Securities=false
      elif $Cable_Joy && [ "$col2" = "株式会社ケーブル・ジョイ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Cable_Joy=false
      elif $Kansai_Mirai_Bank && [ "$col2" = "関西みらい銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kansai_Mirai_Bank=false
      elif $Kansai_Electric_Power && [ "$col2" = "関西電力" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kansai_Electric_Power=false
      elif $Kiyo_Bank && [ "$col2" = "紀陽銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kiyo_Bank=false
      elif $Keihan_Department_Store && [ "$col2" = "京阪百貨店" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Keihan_Department_Store=false
      elif $Kyoto_Bank && [ "$col2" = "京都銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kyoto_Bank=false
      elif $Kanazawa_University && [ "$col2" = "金沢大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kanazawa_University=false
      elif $kyushu_card && [ "$col2" = "九州カード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        kyushu_card=false
      elif $Kyushu_University && [ "$col2" = "九州大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kyushu_University=false
      elif $Keio_University && [ "$col2" = "慶応義塾大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Keio_University=false
      elif $Ministry_of_Health && [ "$col2" = "厚生労働省" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ministry_of_Health=false
      elif $National_Tax_Agency && [ "$col2" = "国税庁" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        National_Tax_Agency=false
      elif $Ministry_of_Finance && [ "$col2" = "財務省" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ministry_of_Finance=false
      elif $Saitama_Resona_Bank && [ "$col2" = "埼玉りそな銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Saitama_Resona_Bank=false
      elif $Sapporo_Medical_University && [ "$col2" = "札幌医科大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sapporo_Medical_University=false
      elif $Mitsui_Sumitomo_Bank_Card && [ "$col2" = "三井住友カード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsui_Sumitomo_Bank_Card=false
      elif $Sumitomo_Mitsui_Trust_Club && [ "$col2" = "三井住友トラストクラブ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sumitomo_Mitsui_Trust_Club=false
      elif $Sumitomo_Mitsui_Banking_Corporation && [ "$col2" = "三井住友銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sumitomo_Mitsui_Banking_Corporation=false
      elif $Sumitomo_Mitsui_Trust_Bank && [ "$col2" = "三井住友信託銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sumitomo_Mitsui_Trust_Bank=false
      elif $Mitsukoshi_Isetan && [ "$col2" = "三越伊勢丹" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsukoshi_Isetan=false
      elif $Mitsubishi_HC_Capital && [ "$col2" = "三菱HCキャピタル" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsubishi_HC_Capital=false
      elif $Mitsubishi_UFJ_Nicos && [ "$col2" = "三菱UFJニコス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsubishi_UFJ_Nicos=false
      elif $Mitsubishi_UFJ_Financial_Group && [ "$col2" = "三菱UFJフィナンシャルグループ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsubishi_UFJ_Financial_Group=false
      elif $Mitsubishi_UFJ_Bank && [ "$col2" = "三菱UFJ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsubishi_UFJ_Bank=false
      elif $Mitsubishi_UFJ_Trust_and_Banking && [ "$col2" = "三菱UFJ信託銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Mitsubishi_UFJ_Trust_and_Banking=false
      elif $Yamaguchi_Cable_Vision && [ "$col2" = "山口ケーブルビジョン" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yamaguchi_Cable_Vision=false
      elif $Yamazen && [ "$col2" = "山善" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Yamazen=false
      elif $Shiga_University_of_Medical_Science && [ "$col2" = "滋賀医科大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Shiga_University_of_Medical_Science=false
      elif $Kagoshima_University && [ "$col2" = "鹿児島大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kagoshima_University=false
      elif $seventy_seven_bank && [ "$col2" = "七十七銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        seventy_seven_bank=false
      elif $Akita_Bank && [ "$col2" = "秋田銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Akita_Bank=false
      elif $Sumishin_SBI_Net_Bank && [ "$col2" = "住信SBIネット銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Sumishin_SBI_Net_Bank=false
      elif $sumitomo_life && [ "$col2" = "住友生命" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        sumitomo_life=false
      elif $Eighteen_Shinwa_Bank && [ "$col2" = "十八親和銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Eighteen_Shinwa_Bank=false
      elif $Juroku_Bank && [ "$col2" = "十六銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Juroku_Bank=false
      elif $Idemitsu_credit && [ "$col2" = "出光クレジット" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Idemitsu_credit=false
      elif $Delivery_hall && [ "$col2" = "出前館" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Delivery_hall=false
      elif $Odakyu_Department_Store && [ "$col2" = "小田急百貨店" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Odakyu_Department_Store=false
      elif $Zojirushi_Direct && [ "$col2" = "象印ダイレクト" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Zojirushi_Direct=false
      elif $Shanghai_Pudong_Development_Bank && [ "$col2" = "上海浦東発展銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Shanghai_Pudong_Development_Bank=false
      elif $Niigata_University && [ "$col2" = "新潟大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Niigata_University=false
      elif $Shinsei_Financial && [ "$col2" = "新生フィナンシャル" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Shinsei_Financial=false
      elif $Shinsei_Bank && [ "$col2" = "新生銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Shinsei_Bank=false
      elif $Kanagawa_Bank && [ "$col2" = "神奈川銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kanagawa_Bank=false
      elif $Kanagawa_University && [ "$col2" = "神奈川大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kanagawa_University=false
      elif $Nishinippon_City_Bank && [ "$col2" = "西日本シティ銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nishinippon_City_Bank=false
      elif $Shizuoka_Bank && [ "$col2" = "静岡銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Shizuoka_Bank=false
      elif $Customs && [ "$col2" = "税関" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Customs=false
      elif $Chiba_Bank && [ "$col2" = "千葉銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Chiba_Bank=false
      elif $Ministry_of_Internal_Affairs_and_Communications && [ "$col2" = "総務省" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ministry_of_Internal_Affairs_and_Communications=false
      elif $Daimaru_Matsuzakaya_Card && [ "$col2" = "大丸松坂屋カード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Daimaru_Matsuzakaya_Card=false
      elif $Osaka_Shinkin_Bank && [ "$col2" = "大阪信用金庫" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Osaka_Shinkin_Bank=false
      elif $Osaka_University && [ "$col2" = "大阪大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Osaka_University=false
      elif $Daiwa_Next_Bank && [ "$col2" = "大和ネクスト銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Daiwa_Next_Bank=false
      elif $Industrial_and_Commercial_Bank_of_China && [ "$col2" = "中国工商銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Industrial_and_Commercial_Bank_of_China=false
      elif $Agricultural_Bank_of_China && [ "$col2" = "中国農業銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Agricultural_Bank_of_China=false
      elif $Asahi_Life_Insurance && [ "$col2" = "朝日生命保険" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Asahi_Life_Insurance=false
      elif $tokyu_card && [ "$col2" = "東急カード" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        tokyu_card=false
      elif $Tokyo_Gas && [ "$col2" = "東京ガス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tokyo_Gas=false
      elif $Tokyo_Medical_and_Dental_University && [ "$col2" = "東京医科歯科大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tokyo_Medical_and_Dental_University=false
      elif $University_of_Tokyo && [ "$col2" = "東京大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        University_of_Tokyo=false
      elif $Tokyo_Metropolitan_Bureau_of_Waterworks && [ "$col2" = "東京都水道局" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tokyo_Metropolitan_Bureau_of_Waterworks=false
      elif $Tohoku_University && [ "$col2" = "東北大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tohoku_University=false
      elif $Tohoku_Electric_Power && [ "$col2" = "東北電力" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Tohoku_Electric_Power=false
      elif $Fujii_Daimaru && [ "$col2" = "藤井大丸" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Fujii_Daimaru=false
      elif $Japan_UNICEF_Association && [ "$col2" = "日本ユニセフ協会" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_UNICEF_Association=false
      elif $bank_of_japan && [ "$col2" = "日本銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        bank_of_japan=false
      elif $Japan_Exchange_Group && [ "$col2" = "日本取引所グループ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_Exchange_Group=false
      elif $Nippon_Life_Insurance && [ "$col2" = "日本生命保険" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nippon_Life_Insurance=false
      elif $Japanese_Red_Cross_Society && [ "$col2" = "日本赤十字社" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japanese_Red_Cross_Society=false
      elif $Nihon_University && [ "$col2" = "日本大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nihon_University=false
      elif $Japan_Pension_Service && [ "$col2" = "日本年金機構" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_Pension_Service=false
      elif $Japan_Post && [ "$col2" = "日本郵便" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Japan_Post=false
      elif $Certified_NPO_Florence && [ "$col2" = "認定NPO法人フローレンス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Certified_NPO_Florence=false
      elif $Fukui_cable_television && [ "$col2" = "福井ケーブルテレビ" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Fukui_cable_television=false
      elif $Fukuoka_Bank && [ "$col2" = "福岡銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Fukuoka_Bank=false
      elif $Heian_Bank && [ "$col2" = "平安銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Heian_Bank=false
      elif $Hokkaido_Bank && [ "$col2" = "北海道銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Hokkaido_Bank=false
      elif $Hokkaido_Electric_Power && [ "$col2" = "北海道電力" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Hokkaido_Electric_Power=false
      elif $North_Pacific_Bank && [ "$col2" = "北洋銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        North_Pacific_Bank=false
      elif $Kitasato_University && [ "$col2" = "北里大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Kitasato_University=false
      elif $Nagoya_City_University && [ "$col2" = "名古屋市立大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nagoya_City_University=false
      elif $Nagoya_University && [ "$col2" = "名古屋大学" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nagoya_University=false
      elif $Meiji_Yasuda_Life_Insurance && [ "$col2" = "明治安田生命" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Meiji_Yasuda_Life_Insurance=false
      elif $Nomura && [ "$col2" = "野村" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nomura=false
      elif $Nomura_Holdings && [ "$col2" = "野村ホールディングス" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Nomura_Holdings=false
      elif $RIKEN && [ "$col2" = "理化学研究所" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        RIKEN=false
      elif $Ryukyu_Bank && [ "$col2" = "琉球銀行" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Ryukyu_Bank=false
      elif $Reinan_Cable_Network && [ "$col2" = "嶺南ケーブルネットワーク" ]; then
        echo >> "$main_file"
        echo "# $col2" >> "$main_file"
        echo "# $col2" >> "$main_file_csv"
        Reinan_Cable_Network=false
      fi
      echo "$col1" >> "$main_file"
      echo "$col1" >> "$main_file_csv"
      echo "$col1"
    done < "$sub_copy"
    rm "$sub_copy"
    echo
    echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
    echo -e "\033[1;32m$main_file と $main_file_csv は $current_dir に格納されています。\033[0m"
  else
    echo -e "\033[1;31m$sub_file が存在しません。\033[0m"
    exit 1
  fi
}

functionList=$(
  cat << EOF
> download
  → JPCERT/CCが確認したフィッシングサイトURLリストをダウンロードする

> create_phishing_URL_list
  → JPCERT/CCが確認したフィッシングサイトURLリストを一つの読込専用csvファイルにする

> generate_phishing_URL_list
  → JPCERT_phishing_URL_list.csv を読み込んでDNSブロックリストを生成する
EOF
)
echo -e "\033[1;36m$functionList\033[0m"
echo
while true; do
  read -p "上記から関数を選択して下さい: " function
  case $function in
  download)
    open https://github.com/JPCERTCC/phishurl-list/archive/refs/heads/main.zip
    echo
    continue
    ;;
  create_phishing_URL_list)
    create_phishing_URL_list
    break
    ;;
  generate_phishing_URL_list)
    generate_phishing_URL_list
    break
    ;;
  exit)
    break
    ;;
  *)
    echo -e "\033[1;31mERROR: そのような関数は存在しません(終了する場合は「exit」を入力)\033[0m"
    echo
    continue
    ;;
  esac
done
