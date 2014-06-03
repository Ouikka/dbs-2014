#!/usr/bin/python3

from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
from PyQt5.QtGui import *

from sys import argv,exit
if __name__=='__main__':
	app = QApplication(argv)
	
	
import mysql
import dialogs
import enum
from thread2 import Thread
				
class MainWindow(QMainWindow):
	Modes = [ 'Table view (Read & Write)', 'Custom view (Read only)' ]
	
	def __init__(self, parent = None):
		
		super(MainWindow,self).__init__(parent)
		self.setWindowTitle('La petite maison')
		self.show()
		self.w = QWidget()
		self.mainLayout = QVBoxLayout()
		
		
		#####
		
		# toolbar
		self.toolbar = self.addToolBar('Run')
		
		# mode selection
		self.modeComboBox = QComboBox()
		for mode in MainWindow.Modes :
			self.modeComboBox.addItem ( mode )
		self.modeComboBox.activated.connect ( self.switchMode )
		self.toolbar.addWidget ( self.modeComboBox ) 
		self.toolbar.addSeparator ()
		
		# table selection
		self.tableComboBox = QComboBox()
		for topic in mysql.MySqlView.Entities + mysql.MySqlView.Relations :
			self.tableComboBox.addItem(topic)
		self.tableComboBox.activated.connect(self.switchTableView)
		self.toolbar.addWidget(self.tableComboBox)
		
		# run query
		self.runAction = QAction ( self )
		self.runAction.setShortcut ( 'Enter' )
		self.statusReady ()
		self.toolbar.addAction ( self.runAction )
		self.querythread = None
		
		# search for keywords
		searchAction = QAction ( QIcon.fromTheme("system-search"), 'Search in table', self)
		searchAction.setShortcut ( 'Ctrl-F' )
		searchAction.triggered.connect ( self.searchQuery )
		self.toolbar.addAction ( searchAction )
		
		# add record to dbs
		addAction = QAction ( QIcon.fromTheme("document-new"), 'Add record to table', self)
		addAction.setShortcut ( 'Ctrl-N' )
		addAction.triggered.connect ( self.addRecord )
		self.toolbar.addAction ( addAction )
		self.toolbar.addSeparator ()
		
		# load an existing query
		self.queryComboBox= QComboBox()
		self.queryComboBox.addItem("Custom Query")
		for i in range(ord('A'), ord('R')+1):
			self.queryComboBox.addItem("Query %s" % (chr(i)))
		self.queryComboBox.activated.connect ( self.loadQuery )
		self.toolbar.addWidget ( self.queryComboBox )
		
		# open sql query file
		
		# save current sql query 
		
		
		#####
		
		# query box
		self.queryTextBox = QTextEdit()
		#~ self.queryTextBox.textChanged.connect(self.switchQueryIndex)
		self.mainLayout.addWidget ( self.queryTextBox )
		
		#####
		
		# table view
		self.dbs = mysql.MySqlView(self)
		self.mainLayout.addWidget(self.dbs,4)
		
		#####
		
		# navigate through the results
		self.navLayout = QHBoxLayout() 
		self.navBar = QToolBar ( 'Navigation' )

		left_spacer = QWidget()
		left_spacer.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)

		right_spacer = QWidget()
		right_spacer.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)

		self.navBar.addWidget ( left_spacer )
		
		self.prevPageAction = QAction ( QIcon.fromTheme("go-previous"), 'Previous result page', self)
		self.prevPageAction.setShortcut ( 'left' )
		self.prevPageAction.triggered.connect ( self.prevPage )
		self.navBar.addAction ( self.prevPageAction )
		
		self.pageLabel = QLabel(self)
		self.pageLabel.show()
		self.navBar.addWidget(self.pageLabel)

		self.nextPageAction = QAction ( QIcon.fromTheme("go-next") , 'Next result page', self)
		self.nextPageAction.setShortcut ( 'right' )
		self.nextPageAction.triggered.connect ( self.nextPage )
		self.navBar.addAction ( self.nextPageAction )
		
		self.navBar.addWidget ( right_spacer )
		
		self.addToolBar(  Qt.BottomToolBarArea, self.navBar )

		
		#####
		
		# status bar
		self.statusReady()
		self.resultLabel = QLabel ( self )
		self.statusBar().addPermanentWidget ( self.resultLabel )
		self.runTimeLabel = QLabel ( self )
		self.statusBar().addPermanentWidget ( self.runTimeLabel )
		
		#####
		
		self.setCentralWidget(self.w)
		self.w.setLayout(self.mainLayout)
		self.setFixedSize(1920,1010)
		self.switchMode()


	def switchMode(self):
		if (self.modeComboBox.currentIndex() == 0):
			self.tableViewMode()
		else :
			self.customViewMode()
	
	def tableViewMode(self):
		self.queryTextBox.setDisabled ( True )
		
	def customViewMode(self):
		self.queryTextBox.setDisabled ( False )
		
		
	def switchTableView(self) :
		self.dbs.switchTable(self.tableComboBox.currentIndex())
	
	def runQuery(self):
		self.statusBusy()
		self.dbs.runQuery(self.queryTextBox.toPlainText())
	
	#~ def runQuery(self):
		#~ self.statusBusy()
		#~ self.querythread = Thread(target = self.dbs.runQuery)
		#~ self.querythread.start()
		
	def successfulQuery(self):
		self.resultLabel.setText ( 'The query was successful ! ' )
		self.statusReady ()
		
	def cancelQuery(self):
		#~ self.querythread.terminate()
		#~ self.querythread.join()
		#~ self.resultLabel.setText ( 'The query was canceled ' )
		#~ self.statusReady()
		0
		
	def updateRunTime(self, runTime):
		self.runTimeLabel.setText ( 'Run time : %.5s s ' % runTime )
			
	def statusReady(self):
		self.runAction.setIcon ( QIcon.fromTheme("system-run") ) 
		self.runAction.setIconText ( 'Run query' )
		self.runAction.triggered.connect ( self.runQuery )
		self.statusBar().showMessage('Ready')
	
	def statusBusy(self):
		self.runAction.setIcon ( QIcon.fromTheme("process-stop") )
		self.runAction.setIconText ( 'Cancel query' )
		self.runAction.triggered.connect ( self.cancelQuery )
		self.statusBar().showMessage('Querying...')
		
			
	def searchQuery(self):
		0
		
	def addRecord(self):
		searchTable, result = dialogs.AddRecordDialog.getNewRecord(self.dbs, self.dbs.keyToTableName(self.tableComboBox.currentIndex()))
		print searchTable
	
	def loadQuery(self):
		self.dbs.switchQuery ( self.queryComboBox.currentIndex() )
			
	def switchQueryIndex(self, index=0):
		self.queryComboBox.setCurrentIndex(index)
	

	def updateQueryBox(self, query):
		self.queryTextBox.setText ( query ) 
		
		
	def prevPage(self):
		self.dbs.prevPage()
	
	def nextPage(self):
		self.dbs.nextPage()
	
	def setPageStatus ( self, pageIndex, maxPage ):
		self.pageLabel.setText("Page %d of %d" % ( pageIndex, maxPage))
		self.prevPageAction.setEnabled ( pageIndex!=1 )
		self.nextPageAction.setEnabled ( pageIndex<maxPage )
		
	
    
screen = MainWindow()
exit(app.exec_())
