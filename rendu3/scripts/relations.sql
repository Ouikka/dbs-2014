CREATE TABLE Artist_genre ( 
  artistID INTEGER, 
  genreID INTEGER,
  PRIMARY KEY (artistID, genreID),
  FOREIGN KEY (artistID) REFERENCES Artists,
  FOREIGN KEY (genreID) REFERENCES Genres ) ;
  
  
CREATE TABLE Track_artist ( 
  artistID INTEGER, 
  trackID INTEGER,  
  PRIMARY KEY (artistID, trackID),
  FOREIGN KEY (trackID) REFERENCES Tracks ,
  FOREIGN KEY (artistID) REFERENCES Artists ) ;
