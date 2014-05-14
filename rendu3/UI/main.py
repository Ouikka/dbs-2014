#!/usr/bin/python3

from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
import mysql

class MainWindow(QMainWindow):
#    db = mysql.MySql()
    def __init__(self, parent = None):
        super(MainWindow,self).__init__(parent)
        self.setWindowTitle('La petite maison')
        self.show()
        self.w = QWidget()
        self.m = mysql.MySql()
#        self.m = QWidget()
        self.l = QVBoxLayout()
        self.setCentralWidget(self.w)
        self.searchLayout = QHBoxLayout()
        self.searchEdit = QLineEdit()
        self.searchLayout.addWidget(searchEdit,3)
        self.searchTopic = QComboBox()
        self.searchTopic.addItem("Releases")
        self.searchTopic.addItem("Recordings")
        self.searchTopic.addItem("Artists")
        self.searchTopic.addItem("Genres")
        self.searchLayout.addWidget(self.searchTopic,1)
        self.searchLayout.addWidget(QPushButton("Search"),1)

        self.l.addLayout(self.searchLayout)

        self.h1 = QHBoxLayout()
        self.queriesLayout = QVBoxLayout()
        self.h1.addWidget(self.m,4)
        
        self.queriesLayout.addWidget(QPushButton("Query A",clicked=self.m.queryA))
        self.queriesLayout.addWidget(QPushButton("Query B"))
        self.queriesLayout.addWidget(QPushButton("Query C",clicked=self.m.queryC))
        self.queriesLayout.addWidget(QPushButton("Query D",clicked=self.m.queryD))
        self.queriesLayout.addWidget(QPushButton("Query E",clicked=self.m.queryE))
        self.queriesLayout.addWidget(QPushButton("Query F",clicked=self.m.queryF))
        self.queriesLayout.addWidget(QPushButton("Query G",clicked=self.m.queryG))
        self.queriesLayout.addWidget(QPushButton("Query H",clicked=self.m.queryH))

        self.h1.addLayout(self.queriesLayout,1)


        self.h2 = QHBoxLayout() 

        self.h2.addWidget(QPushButton("Add record"),1)
        self.h2.insertStretch(1,3)
        self.h2.addWidget(QPushButton("Prev"),1)
        self.h2.addWidget(QPushButton("Next",clicked=self.m.nextb),1)
        self.l.addLayout(self.h1)
        self.l.addLayout(self.h2)
#        self.m.show()
        self.w.setLayout(self.l)
        self.setFixedSize(1024,768)

    def search(self):
        self.m.searchQuery(self.searchEdit.text(),self.searchTopic.currentText())
        

from sys import argv,exit
if __name__=='__main__':
    app = QApplication(argv)
    screen = MainWindow()
    #MainWindow.show()
    exit(app.exec_())
