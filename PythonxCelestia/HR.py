class Employee:

	def __init__(self):
		self.Attributes = ('sFirst Name', 'sLast Name', 'sPresent Address', 'sPermanent Address', 'sPhone Number', 'sMobile Number', 'eEMail Address', 'dDate Of Birth', 'dDate Of Joining', 'lstEducational Qualification', 'lstSalary Nominee', 'lstFamily Member', 'lstDocument', 'Bank Account', 'lstAttendance', 'Department', 'Salary Details', 'User Details', 'fileResume')
		self.Options = (None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None)

class EducationalQualification:
	def __init__(self):
		self.Attributes = ('sEducation', 'sSchool/College Name', 'sBoard/University', 'iYear Of Passing', 'iPercentage Obtained', 'arrsSubject')
		self.Options = ({'Class X':'Class X', 'PUC':'PUC', 'Graduation':'Graduation', 'Post Graduation':'Post Graduation'}, None, None, None, None, None, None, None)

class SalaryNominee:
	def __init__(self):
		self.Attributes = ('sName', 'iAge', 'sRelationship With Employee', 'fPercentage Nomination')
		self.Options = (None, None, None, None, None, None, None, None, None)

class FamilyMember:
	def __init__(self):
		self.Attributes = ('sName', 'sAddress', 'iAge', 'sRelationship With Employee', 'sOccupation')
		self.Options = (None, None, None, None, None, None, None, None, None)

class Document:
	def __init__(self):
		self.Attributes = ('sDocument', 'bVerification Done', 'bSubmitted By Employee', 'dDate Of Verification')
		self.Options = ({'Class X Pass Certificate':'Class X Pass Certificate', 'Class XII Pass Certificate':'Class XII Pass Certificate', 'Graduation Pass Certificate':'Graduation Pass Certificate', 'PG Pass Certificate':'PG Pass Certificate', 'Address Proof':'Address Proof', 'ID Proof':'ID Proof', 'Experience Letter':'Experience Letter'}, None, None, None, None, None, None)

class BankAccount:
	def __init__(self):
		self.Attributes = ("sAccount Holder's Name", 'sAccount Number', 'sBank Name', 'sBranch Name and Address', 'bAccount Created')
		self.Options = (None, None, None, None, None, None, None, None)

class Attendance:
	def __init__(self):
		self.Attributes = ('dDate', 'sLogin Time', 'sLogout Time', 'sRemarks')
		self.Options = (None, None, None, None, None, None, None, None)

class Department:
	def __init__(self):
		self.Attributes = ('sDepartment ID', 'sDepartment Name', 'sLocation', 'iNumber of Employees', 'sRoles and Responsibilities', 'Employee', 'dDate Of Onset')
		self.Options = (None, None, None, None, None, None, None, None, None, None)

class SalaryDetails:
	def __init__(self):
		self.Attributes = ('sEmployee Type', 'fWage', 'fVariable Pay', 'fTax', 'sSalary Cycle', 'lstSalary Slip')
		self.Options = (None, None, None, None, None, None)

class SalarySlip:
	def __init__(self):
		self.Attributes = ('dDate', 'sName', 'sAddress', 'sBank Account Number', 'sDepartment', 'iNumber Of Days Worked', 'iGross Pay', 'iTax', 'iNet Pay')
		self.Options = (None, None, None, None, None, None, None, None, None, None)

class UserDetails:
	def __init__(self):
		self.Attributes = ('sUsername', 'sPassword', 'sRole', 'sEMail Password', 'sInternet Password', 'lstLog')
		self.Options = (None, None, None, None, None, None, None, None, None, None)

class Log:
	def __init__(self):
		self.Attributes = ('dLogin Date And Time', 'dLogout Date And Time')
		self.Options = (None, None)


