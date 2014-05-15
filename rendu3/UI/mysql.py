from PyQt5.QtSql import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *#QAbstractTableModel
from PyQt5.QtGui import *

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

	def __init__(self,host='localhost',usr='db2014_g24',pw='',parent=None):
		super(QTableView,self).__init__(parent)
		self.engine = create_engine("sqlite:///../../../local-dbs")
		self.connection = self.engine.connect()
		self.meta = MetaData()
		self.meta.reflect(bind = self.engine)
		self.page_index=1
		self.max_page=1
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
	
	def switchTable(self, table_key):
		self.table_name = {
			0 : 'Releases',
			1 : 'Recordings',
			2 : 'Artists',
			3 : 'Genres'
		} [table_key]
		self.updateView()
		
		
	def nextPage(self):
		self.page_index = min(self.max_page, self.page_index+1)	
		self.updateView()
	
	def prevPage(self):
		self.page_index = max(0, self.page_index-1)
		self.updateView()
		
	def updateView(self):
		table = self.connection.execute(select([self.meta.tables[self.table_name]]))
		p = self.page_index
		results = self.connection.execute("SELECT * from (select *, rowid r from %s ) where r >= %s and r < %s" % (self.table_name, str(p*50), str((p+1)*50))).fetchall()
		#results = self.connection.execute('SELECT * from Releases')
		self.table = TableModel(results,table.keys())
		self.setModel(self.table)

