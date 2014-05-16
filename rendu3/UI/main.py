#!/usr/bin/python3

from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
import mysql


class MainWindow(QMainWindow):

	def __init__(self, parent = None):
		
		super(MainWindow,self).__init__(parent)
		self.setWindowTitle('La petite maison')
		self.show()
		self.w = QWidget()
		self.mainLayout = QVBoxLayout()
		
		# search for keywords
		self.searchLayout = QHBoxLayout()
		self.searchEdit = QLineEdit()
		self.searchLayout.addWidget(self.searchEdit,3)
		self.searchTopic = QComboBox()
		for topic in mysql.MySql.Topics:
			self.searchTopic.addItem(topic)
		self.searchTopic.activated.connect(self.switchTableView)
		self.searchLayout.addWidget(self.searchTopic,1)
		self.searchLayout.addWidget(QPushButton("Search",clicked=self.searchButton, styleSheet='color: yellow'))
		
		# making queries to the dbs
		self.queryLayout = QHBoxLayout()
		self.queryLayoutR = QVBoxLayout()
		self.queryComboBox= QComboBox()
		self.queryComboBox.addItem("Custom Query")
		for i in range(ord('A'), ord('R')+1):
			self.queryComboBox.addItem("Query %s" % (chr(i)))
		self.queryTextBox = QTextEdit()
		self.queryTextBox.textChanged.connect(self.switchQueryIndex)
		self.queryLayout.addWidget(self.queryTextBox,3)
		self.queryLayoutR.addWidget(self.queryComboBox)
		self.queryLayoutR.addWidget(QPushButton("Execute",clicked=self.executeButton))
		self.queryLayout.addLayout(self.queryLayoutR)
		
		# navigate through the results
		self.navLayout = QHBoxLayout() 
		self.navLayout.addWidget(QPushButton("Add record"),1)
		self.navLayout.insertStretch(1,3)
		self.navLayout.addWidget(QPushButton("Prev",clicked=self.prevButton),1)
		self.pageLabel = QLabel(self)
		self.pageLabel.show()
		self.navLayout.addWidget(self.pageLabel)
		self.navLayout.addWidget(QPushButton("Next",clicked=self.nextButton),1)
		
		self.dbs = mysql.MySql(self)
		self.mainLayout.addLayout(self.searchLayout)
		self.mainLayout.addLayout(self.queryLayout)
		self.mainLayout.addWidget(self.dbs,4)
		self.mainLayout.addLayout(self.navLayout)
		
		self.queryComboBox.activated.connect(self.dbs.switchQuery)
		self.setCentralWidget(self.w)
		self.w.setLayout(self.mainLayout)
		self.setFixedSize(1920,1010)

        
	def switchTableView(self) :
		self.dbs.switchTable(self.searchTopic.currentIndex())
	
	def switchQueryIndex(self, index=0):
		self.queryComboBox.setCurrentIndex(index)
	
	def searchButton(self) :
		self.dbs.searchQuery(self.searchEdit.text())
		
	def executeButton(self) :
		self.dbs.customQuery(self.queryTextBox.toPlainText())
	
	def prevButton(self):
		self.dbs.prevPage()
	
	def nextButton(self):
		self.dbs.nextPage()
	
from sys import argv,exit
if __name__=='__main__':
	app = QApplication(argv)
	screen = MainWindow()
	exit(app.exec_())
    
    
