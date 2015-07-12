class Student:

	def __init__(self):
		self.Attributes = ('sFirst Name', 'sLast Name', 'sFather\'s Name', 'sMother\'s Name', 'sPresent Address', 'sPermanent Address', 'sPhone Number', 'eEmail Address', 'iAge', 'sSex', 'arrsSubject', 'lstTest', 'arrsAilment', 'IdentityCard')
		self.Options = (None, None, None, None, None, None, None, None, None, {'Male':'Male', 'Female':'Female'}, {'Hindi':'Hindi', 'English':'English', 'Oriya':'Oriya'}, None, None, None, None)

class Test:

	def __init__(self):
		self.Attributes = ('sTest ID', 'sTest Name', 'dTest Date', 'iMarks', 'iClass')
		self.Options = (None, {'Quarterly Examination':'Quarterly Examination', 'Half Yearly':'Half Yearly', 'Final Examination':'Final Examination'}, None, None, {'Class I':1, 'Class II':2, 'Class III':3, 'Class IV':4, 'Class V':5, 'Class VI':6, 'Class VII':7, 'Class VIII':8, 'Class IX':9, 'Class X':10}, None, None)

class IdentityCard:

	def __init__(self):
		self.Attributes = ('sIdentity Card Number', 'sName on Identity Card', 'filePhoto', 'sBlood Group', 'sAddress')
		self.Options = (None, None, None, {'A +ve':'A +ve', 'B +ve':'B +ve', 'AB +ve':'AB +ve', 'O +ve':'O +ve', 'A -ve':'A -ve', 'B -ve':'B -ve', 'AB -ve':'AB -ve', 'O -ve':'O -ve'}, None)

