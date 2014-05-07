#!/usr/bin/python3

from PyQt5.QtCore import *
from PyQt5.QtWidgets import*
import mysql
import os

class MainWindow(QMainWindow):
#    db = mysql.MySql()
    def __init__(self, parent = None):
        super(MainWindow,self).__init__(parent)
        self.setWindowTitle('La petite maison')
        self.setMinimumSize(720,480)


        self.show()
        w = QWidget()
        self.m = mysql.MySql()
        self.m.setVisible(False)
        self.m.resizeColumnsToContents()
        self.m.setVisible(True)
        self.l = QVBoxLayout(w)
        self.setCentralWidget(w)
        self.nextb = QPushButton("Next", clicked=self.m.nextb)
        #self.nextb.clicked.connect(self.m.nextb)
        self.l.addWidget(self.m)
        self.l.addWidget(self.nextb)
        
#        self.m.show()
        #self.setLayout(self.l)
        
        

from sys import argv,exit
if __name__=='__main__':
	#os.environ['ORACLE_HOME']="/home/tachikoma/app/tachikoma/product/12.1.0/dbhome_1"
	app = QApplication(argv)
	screen = MainWindow()
    #MainWindow.show()
	exit(app.exec_())
