CREATE TABLE Areas ( 
  areaID CHAR(20), 
  name CHAR(40), 
  type CHAR(20),
  PRIMARY KEY (areaID) )

CREATE TABLE Genres ( 
  genreID CHAR(20), 
  name CHAR(40), 
  type CHAR(20), 
  count INTEGER, 
  PRIMARY KEY (genreID) )
  
CREATE TABLE Artists ( 
  artistID CHAR(20), 
  name CHAR(40), 
  type CHAR(20), 
  areaID CHAR(20), 
  PRIMARY KEY (artistID),
  FOREIGN KEY (areaID) REFERENCES Areas )
  
CREATE TABLE Songs ( 
  songID CHAR(20), 
  name CHAR(40), 
  length INTEGER,  
  PRIMARY KEY (songID) )
  
CREATE TABLE Albums ( 
  albumID CHAR(20), 
  name CHAR(40),
  PRIMARY KEY (albumID) )
  
CREATE TABLE Mediums ( 
  mediumID CHAR(20), 
  name CHAR(40), 
  format CHAR(20), 
  albumID CHAR(20), 
  PRIMARY KEY (mediumID),
  FOREIGN KEY (albumID) REFERENCES Albums )
