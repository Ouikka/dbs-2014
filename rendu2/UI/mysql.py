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

    def __init__(self,host='icoracle.epfl.ch',port=1521,usr='db2014_g24',pw='db2014_g24',parent=None):
        super(QTableView,self).__init__(parent)
        self.engine = create_engine("oracle://db2014_g24:db2014_g24@icoracle.epfl.ch/srso4")
        self.connection = self.engine.connect()
        self.meta = MetaData()
	self.meta.reflect(bind = self.engine)
        releases = self.meta.tables['releases']
        self.results = self.connection.execute(select([releases]))
        t = self.results.fetchmany(50)
        #print(t)
        self.table = TableModel(t,self.results.keys())
        self.setModel(self.table)
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

    def nextb(self):	
	self.table = TableModel(self.results.fetchmany(50),self.results.keys())
	self.setModel(self.table)

