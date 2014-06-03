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
import model
import time


class MySqlView(QTableView):
	Entities  = [ 'Releases', 'Recordings', 'Artists', 'Genres', 'Areas' ]
	Relations = [ 'Artists\' genres', 'Tracks\' artists' ]
	ENTRIES_BY_PAGE = 50
	
	def __init__(self,window,parent=None):
		super(QTableView,self).__init__(parent)
		self.window = window
		self.engine = create_engine("sqlite:////home/tachikoma/Documents/EPFL/DBS/project/local-dbs")
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
		
		#~ self.switchTable(0)
		#~ self.updateView()
		
		#~ self.horizontalHeader().setStretchLastSection(True)
		self.resizeColumnsToContents()
		self.setContextMenuPolicy(Qt.CustomContextMenu)
		self.customContextMenuRequested.connect(self.customMenuRequested)

 
	@pyqtSlot(QPoint)
	def customMenuRequested(self, pos):
		self.menu = QMenu()
		self.menu.addAction(QAction("Artist",self))
		self.menu.addAction(QAction("Release",self))
		self.menu.popup(self.viewport().mapToGlobal(pos))
   

	def __del__(self):
		self.connection.close()
	
	# update the view with the current table content
	def updatePageView(self):
		index = (self.pageIndex-1) * MySqlView.ENTRIES_BY_PAGE
		table = self.results[ index : index + MySqlView.ENTRIES_BY_PAGE ]
		self.page = model.PageModel ( table, self.keys )
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
			engine = create_engine ( "sqlite:////home/tachikoma/Documents/EPFL/DBS/project/local-dbs", poolclass=SingletonThreadPool )
			self.singleconnection = engine.connect()
			start = time.time()
			results = self.singleconnection.execute(query)
			self.window.successfulQuery() 
			if (results.returns_rows):
				self.keys = results.keys()
				self.results = results.fetchall()
				self.maxPage = ceil( len(self.results) / MySqlView.ENTRIES_BY_PAGE )
				self.pageIndex = 1
				self.updatePageView()
		finally :
			self.window.updateRunTime ( time.time() - start )
			self.singleconnection.close()
			
			
	# update current query with search for keywords
	def searchQuery_ (self, searchTable, token='AND') :
		search = token.join ( { " %s LIKE '%%%s%%' " % ( key, word ) for key,word in searchTable.iteritems() if word } )
		self.query = "SElECT * FROM ( %s ) WHERE %s " % (self.querylight)
		self.window.updateQueryBox ( self.query )
		
	
	# reads query selected by user from file
	def switchQuery(self, queryKey):
		queryFile = "queries/%s.sql" % ( chr( queryKey-1 + ord('A') ) )
		with open(queryFile) as file:
			self.query=file.read()
		self.querylight = self.query
		self.window.updateQueryBox ( self.query )
		
	# create query to add record to database
	def addRecord ( self, newRecord ):
		table = Table( self.tableName, self.meta )
		self.query = table.insert().values( newRecord ) 
		
	# displays next page (if available)	
	def nextPage(self):
		self.pageIndex = min(self.maxPage, self.pageIndex+1)	
		self.updatePageView()
	
	# displays previous page (if available)
	def prevPage(self):
		self.pageIndex = max(1, self.pageIndex-1)
		self.updatePageView()
	


	def addRecordModel(self):
		query = "PRAGMA TABLE_INFO(%s)" % (self.tableName)
		results = self.connection.execute(query).fetchall()
		keys = [ key[1] for key in results ]
		table = [ [ "" ] * len(keys) ]
		return dialogs.addRecordModel(table, keys)

	def searchTableModel(self):
		0
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
