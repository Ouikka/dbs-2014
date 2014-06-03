from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
from PyQt5.QtGui import *
from sqlalchemy import *
from sqlalchemy.orm import class_mapper

#~ class SearchDialog(QDialog):
	#~ 
class AddRecordDialog(QDialog):
	def __init__(self, mysql, tablename, parent = None):
		super(QDialog, self).__init__(parent)
		self.tablename = tablename
		self.mysql = mysql
		self.meta = Table( tablename, mysql.meta )
		
		self.setWindowTitle("Add new record to table %s" % (self.tablename))
		self.mainLayout = QVBoxLayout(self)
		self.resize(600, 200 )
		
        # table view to enter new entry's fields
		self.editTable = QTableView()
		self.table = RWTableModel(mysql, tablename, parent)
		self.editTable.setModel(self.table)

		self.editTable.setVisible(False);
		self.editTable.resizeColumnsToContents();
		self.editTable.setVisible(True);
		self.mainLayout.addWidget(self.editTable)
		
		self.buttonLayout = QHBoxLayout(self)
		self.buttonLayout.addWidget(QPushButton("Ok", clicked=self.ok()),1)
		#~ self.buttonLayout.addWidget(QPushButton("Cancel", clicked=QDialog.Rejected),1)
		self.mainLayout.addLayout(self.buttonLayout)
		#~ self.buttons = QDialogButtonBox(
			#~ QDialogButtonBox.Ok | QDialogButtonBox.Cancel,
			#~ Qt.Horizontal, self)
		#~ self.mainLayout.addWidget(self.buttons)

	def ok(self):
		return QDialog.Accepted
    # get current date and time from the dialog
	def newRecord(self):
		return dict( zip (self.meta.columns.keys(), self.table.table[0]) )
				#~ query = self.meta.insert().values( values ) 


	

	# static method to create the dialog and return (date, time, accepted)
	@staticmethod
	def getNewRecord(mysql,tablename,parent = None):
		dialog = AddRecordDialog(mysql,tablename,parent)
		result = dialog.exec_()
		values = dialog.newRecord()
		return ( values, result == QDialog.Accepted )


	
