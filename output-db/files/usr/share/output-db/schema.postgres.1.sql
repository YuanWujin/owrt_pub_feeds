create table if not exists sources (
	id int generated by default as identity primary key,
	deviceid varchar(300),
	pointid integer,
	breakersize integer,
	phase integer,
	cabinetname varchar(1000),
	label varchar(1000),
	gatewayid varchar(300),
	updated_at timestamp
);

create table if not exists data (
	id int generated by default as identity primary key,
	pname varchar(300),
	ts_end timestamp,
	period int,
	val double precision not null
);

create table if not exists metadata (
	mkey varchar(300) unique primary key,
	val varchar(1000) not null
);