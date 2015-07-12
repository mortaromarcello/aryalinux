use testDatabase;

create table Employee130748630059
(
	Employee_iRecordID130748630059 INT,
	sFirst_Name130748630059 varchar(25),
	sLast_Name130748630059 varchar(25),
	sPresent_Address130748630059 varchar(25),
	sPermanent_Address130748630059 varchar(25),
	sPhone_Number130748630059 varchar(25),
	sMobile_Number130748630059 varchar(25),
	eEMail_Address130748630059 varchar(25),
	dDate_Of_Birth130748630059 datetime,
	dDate_Of_Joining130748630059 datetime,
	fileResume130748630059 mediumblob,
	BankAccount_iRecordID130748630059 INT,
	Department_iRecordID130748630059 INT,
	SalaryDetails_iRecordID130748630059 INT,
	UserDetails_iRecordID130748630059 INT
);

create table EducationalQualification130748630059
(
	EducationalQualification_iRecordID130748630059 INT,
	sEducation130748630059 varchar(25),
	sSchoolCollege_Name130748630059 varchar(25),
	sBoardUniversity130748630059 varchar(25),
	iYear_Of_Passing130748630059 int,
	iPercentage_Obtained130748630059 int
);

create table SalaryNominee130748630059
(
	SalaryNominee_iRecordID130748630059 INT,
	sName130748630059 varchar(25),
	iAge130748630059 int,
	sRelationship_With_Employee130748630059 varchar(25),
	fPercentage_Nomination130748630059 float
);

create table FamilyMember130748630059
(
	FamilyMember_iRecordID130748630059 INT,
	sName130748630059 varchar(25),
	sAddress130748630059 varchar(25),
	iAge130748630059 int,
	sRelationship_With_Employee130748630059 varchar(25),
	sOccupation130748630059 varchar(25)
);

create table Document130748630059
(
	Document_iRecordID130748630059 INT,
	sDocument130748630059 varchar(25),
	bVerification_Done130748630059 int,
	bSubmitted_By_Employee130748630059 int,
	dDate_Of_Verification130748630059 datetime
);

create table BankAccount130748630059
(
	BankAccount_iRecordID130748630059 INT,
	sAccount_Holders_Name130748630059 varchar(25),
	sAccount_Number130748630059 varchar(25),
	sBank_Name130748630059 varchar(25),
	sBranch_Name_and_Address130748630059 varchar(25),
	bAccount_Created130748630059 int,
	Employee_iRecordID130748630059 INT
);

create table Attendance130748630059
(
	Attendance_iRecordID130748630059 INT,
	dDate130748630059 datetime,
	sLogin_Time130748630059 varchar(25),
	sLogout_Time130748630059 varchar(25),
	sRemarks130748630059 varchar(25)
);

create table Department130748630059
(
	Department_iRecordID130748630059 INT,
	sDepartment_ID130748630059 varchar(25),
	sDepartment_Name130748630059 varchar(25),
	sLocation130748630059 varchar(25),
	iNumber_of_Employees130748630059 int,
	sRoles_and_Responsibilities130748630059 varchar(25),
	dDate_Of_Onset130748630059 datetime,
	Employee_iRecordID130748630059 INT
);

create table SalaryDetails130748630059
(
	SalaryDetails_iRecordID130748630059 INT,
	sEmployee_Type130748630059 varchar(25),
	fWage130748630059 float,
	fVariable_Pay130748630059 float,
	fTax130748630059 float,
	sSalary_Cycle130748630059 varchar(25),
	Employee_iRecordID130748630059 INT
);

create table SalarySlip130748630059
(
	SalarySlip_iRecordID130748630059 INT,
	dDate130748630059 datetime,
	sName130748630059 varchar(25),
	sAddress130748630059 varchar(25),
	sBank_Account_Number130748630059 varchar(25),
	sDepartment130748630059 varchar(25),
	iNumber_Of_Days_Worked130748630059 int,
	iGross_Pay130748630059 int,
	iTax130748630059 int,
	iNet_Pay130748630059 int
);

create table UserDetails130748630059
(
	UserDetails_iRecordID130748630059 INT,
	sUsername130748630059 varchar(25),
	sPassword130748630059 varchar(25),
	sRole130748630059 varchar(25),
	sEMail_Password130748630059 varchar(25),
	sInternet_Password130748630059 varchar(25),
	Employee_iRecordID130748630059 INT
);

create table Log130748630059
(
	Log_iRecordID130748630059 INT,
	dLogin_Date_And_Time130748630059 datetime,
	dLogout_Date_And_Time130748630059 datetime
);

create table EducationalQualification_arrsSubject13074863006
(
	EducationalQualification_iRecordID130748630059 INT,
	arrsSubject13074863006 varchar(25)
);

create table Employee_lstEducational_Qualification13074863006
(
	Employee_iRecordID130748630059 INT,
	EducationalQualification_iRecordID130748630059 INT
);

create table Employee_lstSalary_Nominee13074863006
(
	Employee_iRecordID130748630059 INT,
	SalaryNominee_iRecordID130748630059 INT
);

create table Employee_lstFamily_Member13074863006
(
	Employee_iRecordID130748630059 INT,
	FamilyMember_iRecordID130748630059 INT
);

create table Employee_lstDocument13074863006
(
	Employee_iRecordID130748630059 INT,
	Document_iRecordID130748630059 INT
);

create table Employee_lstAttendance13074863006
(
	Employee_iRecordID130748630059 INT,
	Attendance_iRecordID130748630059 INT
);

create table SalaryDetails_lstSalary_Slip13074863006
(
	SalaryDetails_iRecordID130748630059 INT,
	SalarySlip_iRecordID130748630059 INT
);

create table UserDetails_lstLog13074863006
(
	UserDetails_iRecordID130748630059 INT,
	Log_iRecordID130748630059 INT
);

