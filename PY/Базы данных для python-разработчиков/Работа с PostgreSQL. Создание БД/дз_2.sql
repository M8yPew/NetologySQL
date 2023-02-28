create database dz_2


CREATE TABLE Albums(

	uuid UUID PRIMARY KEY,
	name character(250),
	year date

);

CREATE TABLE tracks(

	uuid UUID PRIMARY KEY,
	name character(250),
	INTERVAL INTERVAL,
	album uuid,	
	FOREIGN KEY (album) REFERENCES Albums(uuid)

);


CREATE TABLE compilations(

	uuid UUID PRIMARY KEY,
	name character(250),
	year date

);

CREATE TABLE tracksincollection(

	compilation UUID,
	track uuid,
	FOREIGN KEY(compilation) REFERENCES compilations(uuid),
	FOREIGN KEY(track) REFERENCES tracks(uuid),
	PRIMARY KEY (compilation, track)

);

CREATE TABLE genres(

	uuid UUID PRIMARY KEY,
	name character(250)

);

CREATE TABLE performers(

	uuid UUID PRIMARY KEY,
	name character(250)

);

CREATE TABLE performersgenres(

	genre UUID,
	performer uuid,
	FOREIGN KEY(genre) REFERENCES genres(uuid),
	FOREIGN KEY(performer) REFERENCES performers(uuid),
	PRIMARY KEY (genre, performer)

);



CREATE TABLE performersAlbums(

	Album UUID,
	performer uuid,
	FOREIGN KEY(Album) REFERENCES Albums(uuid),
	FOREIGN KEY(performer) REFERENCES performers(uuid),
	PRIMARY KEY (Album, performer)

);




