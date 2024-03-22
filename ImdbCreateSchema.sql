-- create database IMDB;

create  table titlebasics(
tconst TEXT primary key, --alphanumeric unique identifier of the title
titleType TEXT,
primaryTitle TEXT,
originalTitle TEXT,
isAdult boolean,
startYear int,--(YYYY)
endYear int,--(YYYY)
runtimeMinutes int--– primary runtime of the title, in minutes
-- genres TEXT[] CHECK (array_length(genres, 1) < 3)
-- https://stackoverflow.com/questions/34356546/what-is-the-second-argument-in-array-length-function
-- genres (string array) -- includes up to three genres associated with the title
);


create  table titleakas(
titleId TEXT , --a tconst, an alphanumeric unique identifier of the title
ordering int,
title TEXT,
region TEXT,
language TEXT,
-- types TEXT[] check(types in ( "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay")),
types TEXT[] ,
--         types (array) Enumerated set of attributes for this alternative title. One or more of the following: "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay". New values may be added in the future without warning
attributes TEXT[],
--     attributes (array) -- Additional terms to describe this alternative title, not enumerated
isOriginalTitle boolean,
foreign key(titleId) references titlebasics(tconst)
);



create  table titleepisode(
tconst TEXT primary key, --alphanumeric identifier of episode
parentTconst TEXT,
seasonNumber int,
episodeNumber int,
foreign key(parentTconst) references titlebasics(tconst)
                    );


create  table namebasics(
nconst TEXT primary key,
primaryName TEXT,
birthYear int, -- in YYYY format
deathYear  int,  -- YYYY format if applicable, else '\N'
primaryProfession TEXT[], -- the top-3 professions of the person
-- primaryProfession (array of strings) -- the top-3 professions of the person
knownForTitles TEXT[]  -- – titles the person is known for
-- knownForTitles (array of tconsts) -- – titles the person is known for
    );


create  table titleprincipals(
tconst TEXT, --alphanumeric unique identifier of the title
ordering int,
nconst TEXT,
category TEXT,
job TEXT,
characters TEXT,
foreign key(tconst) references titlebasics(tconst),
foreign key(nconst) references namebasics(nconst)
                              );


create  table titleratings(
tconst TEXT PRIMARY Key ,--alphanumeric unique identifier of the title
averageRating float, --weighted average of all the individual user ratings
numVotes int,--number of votes the title has received
foreign key(tconst) references titlebasics(tconst)
    );


create table titledirector(
    tconst text ,
    nconst text ,
	primary key( tconst, nconst),
    foreign key(tconst) references titlebasics(tconst) on DELETE CASCADE,
    foreign key(nconst) references namebasics(nconst) on DELETE CASCADE
);

create table titlewriter(
    tconst text,
    nconst text,
	primary key(tconst, nconst),
    foreign key(tconst) references titlebasics(tconst) on DELETE CASCADE,
    foreign key(nconst) references namebasics(nconst) on DELETE CASCADE
);


CREATE TABLE titlegenre (titleId TEXT,
genre TEXT,
PRIMARY KEY(titleid, genre),
FOREIGN key(titleId) REFERENCES titlebasics(tconst));
