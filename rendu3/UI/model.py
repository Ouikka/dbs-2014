from PyQt5.QtSql import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *		#QAbstractPageModel
from PyQt5.QtGui import *

class PageModel(QAbstractTableModel):
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



class AddRecordTableModel(QAbstractTableModel):
	entities = [ 'Releases', 'Recordings', 'Artists', 'Mediums', 'Areas' ]
	
	def __init__ ( self, tablename, tableinfo, table, parent=None ):
		super(QAbstractTableModel,self).__init__(parent)
		self.tablename = tablename
		self.keys = self.meta.columns.keys()
		for c in self.meta.columns:
			if c.primary_key:
				self.primary_key = c.name
				break
		print self.primary_key
		self.table = [ [ "" ] * len(self.keys) ]
		#~ if (tablename in RWTableModel.entities):
			#~ query = "SELECT MAX(%s) FROM %s" % ( self.primary_key, tablename )
			#~ maxId = mysql.connection.execute(query).fetchall()
			#~ self.table[0][0] = maxId[0][0]+1
		
	def rowCount(self,parent = None):
		return len(self.table);
		
	def columnCount(self,parent = None):
		return len(self.table[0]);
		
	def data(self,index,role=Qt.DisplayRole):
		if role == Qt.TextAlignmentRole:
			return Qt.AlignLeft
		elif role == Qt.DisplayRole:
			return self.table[index.row()][index.column()]
			
	def setData(self, index, value, role = Qt.EditRole):
		self.table[index.row()][index.column()] = value
		return True
		
	def flags(self, index):
		if (index.column()!=0):
			return  Qt.ItemIsUserCheckable | Qt.ItemIsEnabled | Qt.ItemIsEditable 
		else :
			return None
	
	def headerData(self,section, orientation,role):
		if orientation==Qt.Horizontal:	
			if role == Qt.DisplayRole:
				return QVariant(self.keys[section].capitalize())
			elif role == Qt.SizeHintRole:
				return QSize(8*max([len(str(i)) for i in self.keys]),30)
			elif role == Qt.DecorationRole:
				return QColor(0,0,0)
		
								
class SearchTableModel(QAbstractTableModel):
	entities = [ 'Releases', 'Recordings', 'Artists', 'Mediums', 'Areas' ]
	
	def __init__(self,mysql,tablename,parent=None):
		super(QAbstractTableModel,self).__init__(parent)
		self.tablename = tablename
		self.meta = Table( tablename, mysql.meta)
		self.keys = self.meta.columns.keys()
		for c in self.meta.columns:
			if c.primary_key:
				self.primary_key = c.name
				break
		print self.primary_key
		self.table = [ [ "" ] * len(self.keys) ]
		if (tablename in RWTableModel.entities):
			query = "SELECT MAX(%s) FROM %s" % ( self.primary_key, tablename )
			maxId = mysql.connection.execute(query).fetchall()
			self.table[0][0] = maxId[0][0]+1
		
	def rowCount(self,parent = None):
		return len(self.table);
		
	def columnCount(self,parent = None):
		return len(self.table[0]);
		
	def data(self,index,role=Qt.DisplayRole):
		if role == Qt.TextAlignmentRole:
			return Qt.AlignLeft
		elif role == Qt.DisplayRole:
			return self.table[index.row()][index.column()]
			
	def setData(self, index, value, role = Qt.EditRole):
		self.table[index.row()][index.column()] = value
		return True
		
	def flags(self, index):
		if (index.column()!=0):
			return  Qt.ItemIsUserCheckable | Qt.ItemIsEnabled | Qt.ItemIsEditable 
		else :
			return None
	
	def headerData(self,section, orientation,role):
		if orientation==Qt.Horizontal:	
			if role == Qt.DisplayRole:
				return QVariant(self.keys[section].capitalize())
			elif role == Qt.SizeHintRole:
				return QSize(8*max([len(str(i)) for i in self.keys]),30)
			elif role == Qt.DecorationRole:
				return QColor(0,0,0)
