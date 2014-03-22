CREATE TABLE Artists ( 
  artistID CHAR(20), 
  name CHAR(40), 
  type CHAR(20), 
  areaID CHAR(20), 
  PRIMARY KEY (artistID),
  FOREIGN KEY (areaID) REFERENCES Areas )