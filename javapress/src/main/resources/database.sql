create table roles
(
	id int primary key auto_increment,
	role_name varchar(128) not null
);
create table rights
(
	id int primary key auto_increment,
	right_description varchar(4096) not null,
	right_target varchar(1024) not null
);
create table role_rights
(
	int id primary key auto_increment,
	role_id int not null,
	right_id int not null
);
create table user_rights
(
	int id primary key auto_increment,
	email_address varchar(128) not null,
	right_id int not null
);
create table users
(
	email_address varchar(128) primary key,
	full_name varchar(128) not null,
	password varchar(256) not null,
	role_id int not null
);
create table articles
(
	id int primary key auto_increment,
	title varchar(4096) not null,
	body blob not null,
	created_date datetime not null,
	created_by varchar(128) not null,
	last_updated_date datetime,
	last_updated_by varchar(128),
	category_id int not null
);

create table comments
(
	id int primary key auto_increment,
	comment blob not null,
	email_address varchar(128) not null,
	created_date datetime not null,
	article_id int not null
);