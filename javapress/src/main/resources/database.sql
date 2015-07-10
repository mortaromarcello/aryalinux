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