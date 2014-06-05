from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
from PyQt5.QtGui import *
from sqlalchemy import *
from sqlalchemy.orm import class_mapper

class SearchRecordDialog(QDialog):
	def __init__(self, model, parent = None):
		super(QDialog, self).__init__(parent)
		
		self.setWindowTitle("Search record in table %s" % (model.tablename))
		self.mainLayout = QVBoxLayout(self)
		self.resize(600, 200 )
		
        # table view to enter new entry's fields
		self.editTable = QTableView()
		self.editTable.setModel(model)
		self.model = model


		self.editTable.setVisible(False);
		self.editTable.resizeColumnsToContents();
		self.editTable.setVisible(True);
		self.mainLayout.addWidget(self.editTable)
		
		self.buttonLayout = QHBoxLayout()
		self.buttonLayout.addWidget(QPushButton("Ok",clicked=self.accept),1)
		self.buttonLayout.addWidget(QPushButton("Cancel",clicked=self.reject),1)
		self.mainLayout.addLayout(self.buttonLayout)
		#~ self.buttons = QDialogButtonBox(
			#~ QDialogButtonBox.Ok | QDialogButtonBox.Cancel,
			#~ Qt.Horizontal, self)
		#~ self.mainLayout.addWidget(self.buttons)

	def ok(self):
		self.close()
    # get current date and time from the dialog
	def searchRecord(self):
		return dict(zip (self.model.keys, self.model.table[0]))
				#~ query = self.meta.insert().values( values ) 

	@staticmethod
	def getSearchRecord ( mysql, parent = None ):
		dialog = SearchRecordDialog(mysql, parent)
		result = dialog.exec_()
		values = dialog.searchRecord()
		return ( values, result == QDialog.Accepted )

	


class AddRecordDialog(QDialog):
	def __init__(self, model, parent = None):
		super(QDialog, self).__init__(parent)
		
		self.setWindowTitle("Add new record to table %s" % (model.tablename))
		self.mainLayout = QVBoxLayout(self)
		self.resize(600, 200 )
		
        # table view to enter new entry's fields
		self.editTable = QTableView()
		self.editTable.setModel(model)
		self.model = model

		self.editTable.setVisible(False);
		self.editTable.resizeColumnsToContents();
		self.editTable.setVisible(True);
		self.mainLayout.addWidget(self.editTable)
		
		self.buttonLayout = QHBoxLayout()
		self.buttonLayout.addWidget(QPushButton("Ok",clicked=self.accept),1)
		self.buttonLayout.addWidget(QPushButton("Cancel",clicked=self.reject),1)
		self.mainLayout.addLayout(self.buttonLayout)
		#~ self.buttons = QDialogButtonBox(
			#~ QDialogButtonBox.Ok | QDialogButtonBox.Cancel,
			#~ Qt.Horizontal, self)
		#~ self.mainLayout.addWidget(self.buttons)

	def ok(self):
		self.close()
    # get current date and time from the dialog
	def newRecord(self):
		return dict( zip (self.model.keys, self.model.table[0]) )
	

	# static method to create the dialog and return (date, time, accepted)
	@staticmethod
	def getNewRecord ( mysql, parent = None ):
		dialog = AddRecordDialog(mysql, parent)
		result = dialog.exec_()
		values = dialog.newRecord()
		return ( values, result == QDialog.Accepted )


	
