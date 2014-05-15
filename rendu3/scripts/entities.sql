CREATE TABLE Areas ( 
  areaID INTEGER, 
  name VARCHAR(4000) NOT NULL, 
  type VARCHAR(255),
  PRIMARY KEY (areaID) ) ;

CREATE TABLE Genres ( 
  genreID INTEGER, 
  name VARCHAR(4000) NOT NULL,  
  count INTEGER DEFAULT 0, 
  PRIMARY KEY (genreID) ) ;
  
CREATE TABLE Artists ( 
  artistID INTEGER, 
  name VARCHAR(4000) NOT NULL, 
  type VARCHAR(255), 
  gender VARCHAR(255), 
  areaID INTEGER, 
  PRIMARY KEY (artistID),
  FOREIGN KEY (areaID) REFERENCES Areas ) ;

  
CREATE TABLE Recordings ( 
  recordingID INTEGER, 
  name VARCHAR(4000) , 
  length INTEGER,  
  PRIMARY KEY (recordingID) ) ;


  
CREATE TABLE Releases ( 
  releaseID INTEGER, 
  name VARCHAR(4000) NOT NULL,
  PRIMARY KEY (releaseID) ) ;
  
CREATE TABLE Mediums ( 
  mediumID INTEGER, 
  releaseID INTEGER, 
  format VARCHAR(255), 
  PRIMARY KEY (mediumID),
  FOREIGN KEY (releaseID) REFERENCES Releases ) ;
  

CREATE TABLE Tracks (
  trackID INTEGER,
  recordingID INTEGER,
  mediumID INTEGER, 
  position INTEGER,
  PRIMARY KEY (trackID),
  FOREIGN KEY (mediumID) REFERENCES Mediums, 
  FOREIGN KEY (recordingID) REFERENCES Recordings ) ;

