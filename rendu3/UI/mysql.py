from __future__ import division
from PyQt5.QtSql import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *		#QAbstractPageModel
from PyQt5.QtGui import *
from math import *
from sqlalchemy import *
from sqlalchemy.sql.expression import FromClause
from sqlalchemy.pool import SingletonThreadPool
from sqlalchemy.pool import StaticPool


import dialogs
import models
import time

LOCALDB = "sqlite:///D:\\Prog\\Sqlite\\local-dbs"


class MySqlView(QTableView):
	Entities  = [ 'Releases', 'Recordings', 'Artists', 'Genres', 'Areas' ]
	Relations = [ 'Artists\' genres', 'Tracks\' artists' ]
	ENTRIES_BY_PAGE = 50
	
	def __init__(self,window,parent=None):
		super(QTableView,self).__init__(parent)
		self.window = window
		self.engine = create_engine(LOCALDB)
		self.connection = self.engine.connect()
		self.singleconnection = self.connection
		self.meta = MetaData()
		self.meta.reflect(bind = self.engine)
		
		self.pageIndex=1
		self.maxPage=1
		self.mode='SEARCH'
		self.query=""
		self.querylight=""
		self.results=self.connection.execute('')
		
		self.resizeColumnsToContents()
		self.setContextMenuPolicy(Qt.CustomContextMenu)
		self.setSelectionBehavior(QAbstractItemView.SelectRows)
 
	@pyqtSlot(QPoint)
	def viewMenuRequested(self, pos):
		self.contextMenu(pos)
		self.editAction = QAction("Edit", self,triggered=self.editRecord) 
		self.editAction.setData(self.page.data(self.indexAt(pos),Qt.EditRole))
		self.menu.addAction (self.editAction)
		self.menu.popup(self.viewport().mapToGlobal(pos))
		self.deleteAction = QAction("Delete", self,triggered=self.deleteRecord) 
		self.deleteAction.setData(self.page.data(self.indexAt(pos),Qt.EditRole))
		self.menu.addAction (self.deleteAction)
		self.menu.popup(self.viewport().mapToGlobal(pos))
	
	@pyqtSlot(QPoint)
	def customMenuRequested(self, pos):
		if self.contextMenu(pos) :
			self.menu.popup(self.viewport().mapToGlobal(pos))
		
	def __del__(self):
		self.connection.close()
	
	def contextMenu(self, pos):
		self.menu = QMenu()
		key = self.keys [ self.columnAt ( pos.x() ) ]
		if ( key.lower() == 'artistid' ) :
			self.goArtist = QAction('Go to artist', self,triggered=self.goToArtist) 
			self.goArtist.setData(self.indexAt(pos).data())
			self.menu.addAction (self.goArtist )
			self.goArtistReleases = QAction('Go to artist\'s releases', self,triggered=self.goToArtistReleases) 
			self.goArtistReleases.setData(self.indexAt(pos).data())
			self.menu.addAction (self.goArtistReleases )
			self.goArtistTracks = QAction('Go to artist\'s tracks', self,triggered=self.goToArtistTracks) 
			self.goArtistTracks.setData(self.indexAt(pos).data())
			self.menu.addAction (self.goArtistTracks )
		elif ( key.lower() == 'areaid' ) :
			if self.indexAt(pos).data():
				self.goArtistFromArea = QAction('Go to artists from this area', self,triggered=self.goToArtistFromArea) 
				self.goArtistFromArea.setData(self.indexAt(pos).data())
				self.menu.addAction (self.goArtistFromArea )
			else:
				return False

		elif ( key.lower() == 'genreid' ) :
			if self.indexAt(pos).data():
				self.goArtistFromGenre = QAction('Go to artists from this genre', self,triggered=self.goToArtistFromGenre) 
				self.goArtistFromGenre.setData(self.indexAt(pos).data())
				self.menu.addAction (self.goArtistFromGenre )
				self.goTracksFromGenre = QAction('Go to tracks from this genre', self,triggered=self.goToTracksFromGenre) 
				self.goTracksFromGenre.setData(self.indexAt(pos).data())
				self.menu.addAction (self.goTracksFromGenre )
				self.goReleasesFromGenre = QAction('Go to artists from this genre', self,triggered=self.goToReleasesFromGenre) 
				self.goReleasesFromGenre.setData(self.indexAt(pos).data())
				self.menu.addAction (self.goReleasesFromGenre )
			else:
				return False
			
		else :
			return False
		return True

	def deleteRecord(self):
		self.query = "DELETE FROM " + self.tableName + " WHERE " + " AND ".join([a+"=\""+str(b)+"\"" for a,b in self.deleteAction.data().items() if b])
		self.window.updateQueryBox ( self.query )

	def editRecord(self):
		values = self.deleteAction.data()
		query = "PRAGMA TABLE_INFO(%s)" % (self.tableName)
		tableinfo = self.connection.execute(query).fetchall()
		model = models.AddRecordTableModel(self.tableName, [ k[1] for k in tableinfo ]  , [[values[k[1]] for k in tableinfo]])
		newRecord, result = dialogs.AddRecordDialog.getNewRecord ( model )
		if(result):
			keyid = tableinfo[0][1]
			thisid = newRecord.pop(keyid)
			self.query="UPDATE " + self.tableName + " SET " + ",".join([a+"=\""+str(b)+"\"" for a,b in newRecord.items() if b]) + ' WHERE %s=%s'%(keyid,thisid)
			self.window.updateQueryBox(self.query)

	def goToArtist(self):
		self.tableName = 'Artists'
		self.query = "SELECT * FROM %s o WHERE artistid = %i" % (self.tableName,self.goArtist.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToArtistFromArea(self):
		self.tableName = 'Artists'
		self.query = "SELECT * FROM %s o WHERE areaid = %i" % (self.tableName,self.goArtistFromArea.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToArtistFromGenre(self):
		self.tableName = 'Artists'
		self.query = "SELECT o.* FROM %s o,Artist_genre A WHERE A.genreid = %i AND A.artistid  = o.artistid" % (self.tableName,self.goArtistFromGenre.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToTracksFromGenre(self):
		self.tableName = 'Track_artist'
		self.query = "SELECT DISTINCT t.trackid, Rec.name, A.name, R.name  FROM Tracks t, Track_artist Ta, Artists A, Mediums M, Releases R, Recordings Rec, Artist_genre Ag WHERE Ag.genreid = %i AND Ag.artistid=A.artistid AND A.artistid = Ta.artistid AND t.trackid=Ta.trackid AND t.mediumid=M.mediumid AND Rec.recordingid = t.recordingid AND R.releaseid = M.releaseid" % (self.goTracksFromGenre.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToReleasesFromGenre(self):
		self.tableName = 'Releases'
		self.query = "SELECT DISTINCT R.releaseid,R.name FROM Tracks t, Track_artist A, Releases R, Mediums M,Artist_genre Ag WHERE Ag.genreid = %i AND Ag.artistid=A.artistid AND t.trackid=A.trackid AND t.mediumid = M.mediumid AND R.releaseid = M.releaseid " % (self.goReleasesFromGenre.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToArtistReleases(self):
		self.tableName = 'Releases'
		self.query = "SELECT DISTINCT R.releaseid,R.name FROM Tracks t, Track_artist A, Releases R, Mediums M WHERE A.artistid = %i AND t.trackid=A.trackid AND t.mediumid = M.mediumid AND R.releaseid = M.releaseid " % (self.goArtistReleases.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

	def goToArtistTracks(self):
		self.tableName = 'Track_artist'
		#self.query = "SELECT DISTINCT t.* FROM Tracks t, Track_artist A WHERE A.artistid = %i AND t.trackid= A.trackid" % (self.goArtistTracks.data())
		self.query = "SELECT DISTINCT t.trackid, Rec.name, A.name, R.name  FROM Tracks t, Track_artist Ta, Artists A, Mediums M, Releases R, Recordings Rec WHERE A.artistid = %i AND A.artistid = Ta.artistid AND t.trackid=Ta.trackid AND t.mediumid=M.mediumid AND Rec.recordingid = t.recordingid AND R.releaseid = M.releaseid" % (self.goArtistTracks.data())
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		self.window.runQuery()

		
	# update the view with the current table content
	def updatePageView(self):
		index = (self.pageIndex-1) * MySqlView.ENTRIES_BY_PAGE
		table = self.results[ index : index + MySqlView.ENTRIES_BY_PAGE ]
		self.page = models.PageModel ( table, self.keys )
		self.setModel ( self.page )
		self.resizeColumnsToContents()
		self.window.setPageStatus(self.pageIndex, self.maxPage)
		
	# update current query after table selection change
	def switchTable(self, table_key):
		self.tableName = self.keyToTableName(table_key)
		self.query = "SELECT * FROM %s o" % (self.tableName)
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
	
	# execute current query	& update table content 
	def runQuery(self, query):
		try :
			engine = create_engine ( LOCALDB, poolclass=SingletonThreadPool )
			self.singleconnection = engine.connect()
			start = time.time()
			results = self.singleconnection.execute(query)
			self.window.successfulQuery() 
			if (results.returns_rows):
				self.keys = results.keys()
				self.results = results.fetchall()
				self.maxPage = ceil( len(self.results) / MySqlView.ENTRIES_BY_PAGE )
				self.pageIndex = 1
				self.window.numberResult( len (self.results) )
				self.updatePageView()
			else :
				self.window.numberResult(0)
		finally :
			self.window.updateRunTime ( time.time() - start )
			self.singleconnection.close()
			
			
	# update current query with search for keywords
	def searchQuery_ (self, searchTable, token='AND') :
		search = token.join ( { " %s LIKE '%%%s%%' " % ( key, word ) for key,word in searchTable.iteritems() if word } )
		self.query = "SELECT * FROM ( %s ) WHERE %s " % (self.querylight) 
		self.window.updateQueryBox ( self.query )

	def searchRecord(self,searchRec):
		self.query = "SELECT * FROM (%s) WHERE " % (self.tableName) + " AND ".join([a+"=\""+b+"\"" for a,b in searchRec.items() if b])
		self.window.updateQueryBox(self.query)
		self.window.runQuery()
		
	
	# reads query selected by user from file
	def switchQuery(self, queryKey):
		queryFile = "queries/%s.sql" % ( chr( queryKey-1 + ord('A') ) )
		with open(queryFile) as file:
			self.query=file.read()
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		
	# create query to add record to database
	def addRecord ( self, newRecord ):
		#table = Table( self.tableName, self.meta )
		d = dict( (u,"\""+str(v)+"\"") for u,v in newRecord.items() if v)
		print(d)
		self.query = "INSERT INTO " + self.tableName + " (" + ",".join(d.keys()) + ") VALUES ("+",".join(d.values())+")"#str(table.insert().values( d ) )%d
		self.window.updateQueryBox(self.query);
		
	# displays next page (if available)	
	def nextPage(self):
		self.pageIndex = min(self.maxPage, self.pageIndex+1)	
		self.updatePageView()
	
	# displays previous page (if available)
	def prevPage(self):
		self.pageIndex = max(1, self.pageIndex-1)
		self.updatePageView()
	


	def addRecordTableModel(self):
		query = "PRAGMA TABLE_INFO(%s)" % (self.tableName)
		tableinfo = self.connection.execute(query).fetchall()
		table = [ [None] * len (tableinfo) ]
		for i,key in enumerate(tableinfo) :
			if key[5]==1:
				pk=key[1]
				query = "SELECT MAX(%s) FROM %s" % ( pk, self.tableName )
				maxId = self.connection.execute(query).fetchall()
				table[0][i] = maxId[0][0]+1
				print(table[0][i])
			else :
				table[0][i] = key[4]
		return models.AddRecordTableModel(self.tableName, [ k[1] for k in tableinfo ] , table)

	def searchTableModel(self):
		query = "PRAGMA TABLE_INFO(%s)" % (self.tableName)
		tableinfo = self.connection.execute(query).fetchall()
		return models.SearchTableModel(self,self.tableName,tableinfo)
		
	def viewMode(self):
		self.customContextMenuRequested.connect(self.viewMenuRequested)
		
	def customMode(self):
		self.customContextMenuRequested.connect(self.customMenuRequested)
		
	def keyToTableName(self,table_key):
		return {
			0 : 'Releases',
			1 : 'Recordings',
			2 : 'Artists',
			3 : 'Genres',
			4 : 'Areas',
			5 : 'Artist_genre',
			6 : 'Track_artist'
		} [table_key]
