CREATE TABLE Artist_genre ( 
  artistID CHAR(20) NOT NULL, 
  genreID CHAR(40),
  PRIMARY KEY (artistID, genreID),
  FOREIGN KEY (artistID) REFERENCES Artists,
  FOREIGN KEY (genreID) REFERENCES Genres )
  
CREATE TABLE Song_artist ( 
  songID CHAR(40) NOT NULL, 
  artistID CHAR(20), 
  PRIMARY KEY (songID, artistID),
  FOREIGN KEY (songID) REFERENCES Songs ,
  FOREIGN KEY (artistID) REFERENCES Artists )
  
CREATE TABLE Tracks ( 
  songID CHAR(40), 
  mediumID CHAR(20), 
  position INTEGER, 
  PRIMARY KEY (songID, mediumID),
  FOREIGN KEY (songID) REFERENCES Songs ,
  FOREIGN KEY (mediumID) REFERENCES Mediums )
