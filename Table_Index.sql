
CREATE INDEX titlebasics_index ON titlebasics(tconst);
CREATE INDEX titleakas_index ON titleakas(titleid);
CREATE INDEX namebasics_index ON namebasics(nconst);
CREATE INDEX titledirector_nameindex ON titledirector(nconst);
CREATE INDEX titledirector_titleindex ON titledirector(tconst);