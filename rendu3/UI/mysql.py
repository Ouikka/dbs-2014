from PyQt5.QtSql import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *#QAbstractTableModel
from PyQt5.QtGui import *
from math import *
from sqlalchemy import *
from sqlalchemy.sql.expression import FromClause

class TableModel(QAbstractTableModel):
    def __init__(self,table,keys,parent=None):
        super(QAbstractTableModel,self).__init__(parent)
        self.table=table
        self.keys=keys
    def rowCount(self,parent = None):
        return len(self.table);
    def columnCount(self,parent = None):
        return len(self.table[0]);
    def data(self,index,role=Qt.DisplayRole):
        if role == Qt.TextAlignmentRole:
            return Qt.AlignLeft
        elif role == Qt.DisplayRole:
        	return self.table[index.row()][index.column()]
    def headerData(self,section, orientation,role):
        if orientation==Qt.Horizontal:	
            if role == Qt.DisplayRole:
                return QVariant(self.keys[section].capitalize())
            elif role == Qt.SizeHintRole:
                return QSize(8*max([len(str(i)) for i in self.table[section]]),30)
            elif role == Qt.DecorationRole:
                return QColor(0,0,0)


class MySql(QTableView):
	#~ MODE = enum(SEARCH=1, QUERY=1)
	Topics = [ 'Releases', 'Recordings', 'Artists', 'Genres', 'Other']
	
	def __init__(self,window,parent=None):
		super(QTableView,self).__init__(parent)
		self.window = window
		self.engine = create_engine("sqlite:///../../../local-dbs")
		self.connection = self.engine.connect()
		self.meta = MetaData()
		self.meta.reflect(bind = self.engine)
		
		self.page_index=1
		self.max_page=1
		self.mode='SEARCH'
		self.query=""
		self.query_from=''
		self.query_where=''
		self.results=self.connection.execute('')
		
		self.switchTable(0)
		self.updateView()
		
		self.horizontalHeader().setStretchLastSection(True)
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
	
	#fetch custom query typed by user
	def customQuery(self, query_text):
		self.mode='QUERY'
		self.query = query_text.replace('\n', ' ').replace('\t', ' ')
		self.updateMaxPage()
		self.updateView()
	
	# reads query selected by user from file
	def switchQuery(self):
		query_key = self.window.queryComboBox.currentIndex()
		query_file = "queries/%s.sql" % ( chr( query_key-1 + ord('A') ) )
		with open(query_file) as file:
			query=file.read()
		self.window.queryTextBox.setText(query)
		self.customQuery(query)
	
	# switch the displayed table
	def switchTable(self, table_key):
		self.table_name = {
			0 : 'Releases',
			1 : 'Recordings',
			2 : 'Artists',
			3 : 'Genres'
		} [table_key]
		self.query_from = "FROM %s o" % (self.table_name)
		self.mode='SEARCH'
		self.query_where = ""
		self.updateMaxPage()
		self.updateView()
		
	# displays next page (if available)	
	def nextPage(self):
		self.page_index = min(self.max_page, self.page_index+1)	
		self.updateView()
	
	# displays previous page (if available)
	def prevPage(self):
		self.page_index = max(1, self.page_index-1)
		self.updateView()
	
	# update the total number of pages for the current table
	def updateMaxPage(self):
		if (self.mode=='SEARCH'):
			query = "SELECT COUNT(*) %s %s" % (self.query_from,  self.query_where)
		if (self.mode=='QUERY'):
			query = "SELECT COUNT(*) FROM ( %s )" % (self.query)
		self.max_page = int(ceil( self.connection.execute(query).fetchone()[0]  / 50.0))
		self.page_index = 1
	
	# search for the keywords typed by the user in the current table
	# keywords can be seperated by '$' (else the space is counted as a character)	
	def searchQuery(self,text):
		query = ""
		if (len(text)>0):
			query = "WHERE "
			for i in range(0, len(self.results.keys())):
				for token in text.split('$') :
					if (i>0):
						query += " OR " 
					query += "o.%s LIKE '%%%s%%' " % (self.results.keys()[i], token)
		self.query_where = query
		self.mode='SEARCH'
		self.updateMaxPage()
		self.updateView()
	
	# updates the displayed table with the results of the current query	
	def updateView(self):
		query=""
		if (self.mode=='SEARCH'):
			self.query = 	'''SELECT * 
%s 
%s ''' % (self.query_from, self.query_where)
			self.window.queryTextBox.setText(self.query)
		query = self.query + " LIMIT 50 OFFSET %d" % ((self.page_index-1)*50)
		self.results = self.connection.execute(query)
		self.table = TableModel(self.results.fetchall(),self.results.keys())
		self.setModel(self.table)
		self.window.pageLabel.setText("Page %d of %d" % (self.page_index, self.max_page))
		self.resizeColumnsToContents()



