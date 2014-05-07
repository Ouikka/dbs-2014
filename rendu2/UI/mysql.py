
from PyQt5.QtSql import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *#QAbstractTableModel

from sqlalchemy import *

class TableModel(QAbstractTableModel):
    def __init__(self,table,parent=None):
        super(QAbstractTableModel,self).__init__(parent)
        self.table=table
    def rowCount(self,parent = None):
        return len(self.table);
    def columnCount(self,parent = None):
        return len(self.table[0]);
    def data(self,index,role=Qt.DisplayRole):
        return self.table[index.row()][index.column()]

class MySql(QTableView):

    def __init__(self,host='icoracle.epfl.ch',port=1521,usr='db2014_g24',pw='db2014_g24',parent=None):
        super(QTableView,self).__init__(parent)
        self.engine = create_engine("oracle://db2014_g24:db2014_g24@icoracle.epfl.ch/srso4")
        self.connection = self.engine.connect()
        self.meta = MetaData(bind = self.engine, reflect=True)
        releases = self.meta.tables['releases']
        results = self.connection.execute(select([releases]))
        t = results.fetchmany(50)
        #print(t)
        self.table = TableModel(t)
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
