create table tbl_users
(
	email_address varchar(255) primary key,
	full_name varchar(64) not null,
	password varchar(255) not null,
	role_id int,
	designation_id int
);

create table tbl_issues
(
	issue_id int primary key auto_increment,
	issue_identifier varchar(16) not null,
	title varchar(4096) not null,
	description blob,
	properties blob,
	created_date datetime,
	created_by int not null
);

create table tbl_comment
(
	comment_id int primary key auto_increment,
	issue_id int not null,
	comment blob,
	created_by int not null,
	created_date datetime
);
