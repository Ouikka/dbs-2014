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

        self.h1 = QHBoxLayout()
        self.queriesLayout = QVBoxLayout()
        self.h1.addWidget(self.m,4)
        
        self.queriesLayout.addWidget(QPushButton("Query A"))
        self.queriesLayout.addWidget(QPushButton("Query B"))
        self.queriesLayout.addWidget(QPushButton("Query C"))
        self.queriesLayout.addWidget(QPushButton("Query D"))
        self.queriesLayout.addWidget(QPushButton("Query E"))
        self.queriesLayout.addWidget(QPushButton("Query F"))
        self.queriesLayout.addWidget(QPushButton("Query G"))
        self.queriesLayout.addWidget(QPushButton("Query H"))

        self.h1.addLayout(self.queriesLayout,1)


        self.h2 = QHBoxLayout() 

        self.h2.addWidget(QPushButton("Prev"))
        self.h2.addWidget(QPushButton("Next"))
        self.l.addLayout(self.h1)
        self.l.addLayout(self.h2)
#        self.m.show()
        self.w.setLayout(self.l)
        self.setFixedSize(1024,768)
        

from sys import argv,exit
if __name__=='__main__':
    app = QApplication(argv)
    screen = MainWindow()
    #MainWindow.show()
    exit(app.exec_())
