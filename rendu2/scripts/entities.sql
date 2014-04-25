CREATE TABLE Areas ( 
  areaID INTEGER, 
  name VARCHAR(255) NOT NULL, 
  type VARCHAR(255),
  PRIMARY KEY (areaID) ) ;

CREATE TABLE Genres ( 
  genreID INTEGER, 
  name VARCHAR(255) NOT NULL,  
  count INTEGER DEFAULT 0, 
  PRIMARY KEY (genreID) ) ;
  
CREATE TABLE Artists ( 
  artistID INTEGER, 
  name VARCHAR(255) NOT NULL, 
  areaID INTEGER, 
  gender CHAR(1), 
  PRIMARY KEY (artistID),
  FOREIGN KEY (areaID) REFERENCES Areas ) ;

  
CREATE TABLE Recordings ( 
  recordingID INTEGER, 
  name VARCHAR(255) , 
  length INTEGER,  
  PRIMARY KEY (recordingID) ) ;


  
CREATE TABLE Albums ( 
  albumID INTEGER, 
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (albumID) ) ;
  
CREATE TABLE Mediums ( 
  mediumID INTEGER, 
  albumID INTEGER, 
  format VARCHAR(255), 
  PRIMARY KEY (mediumID),
  FOREIGN KEY (albumID) REFERENCES Albums ) ;
  
  
CREATE TABLE Tracks (
  trackID INTEGER,
  mediumID INTEGER, 
  recordingID INTEGER,
  position INTEGER,
  PRIMARY KEY (trackID),
  FOREIGN KEY (mediumID) REFERENCES Mediums, 
  FOREIGN KEY (recordingID) REFERENCES Recordings ) ;

