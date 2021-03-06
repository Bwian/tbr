require 'pry'

DS_RECORD   = 'DS,4833936100,20130418,P7978266009,797,3,0418501461,S,D,N,C5421,MobileNet,calls,67,,20130312,20130410,20130410,7281,44823000,USAGE,,,11,0,0,,,,42.25,0,42.25,4.23,46.48,20130410,,,,,,,,,,,'
DC_RECORD   = 'DC,4833936100,20130418,P7978266009,7003,2,0418501461,C,D,C5421,1540,1,53448577,,0,,Ballarat,,20130313,20130313,17:17:39,,,7122,44823000,USAGE,11,9999,0,3.04,0,3.04,0.3,3.34,8.51101E+15,,,,,,,,,,,0'
TEST_PHONE  = '0418501461'

OUT_DIR     = './spec/data'
CALL_TYPES 	= './spec/data/call_types.csv'
SERVICES 		= './spec/data/services.csv'
BILLS 			= './spec/data/bills.csv'
EMPTY       = './spec/data/empty.csv'
INVALID     = './spec/data/invalid.csv'
MISSING			= './spec/data/missing.csv'
LOGFILE     = '/tmp/tbr.log'


ONE         = '1234'
TWO         = '2345'
THREE       = '3456'