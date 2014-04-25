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
        self.m = mysql.MySql()
        self.l = QVBoxLayout()
        self.setCentralWidget(self.m)
 #       self.l.addWidget(self.m)
#        self.m.show()
#        self.setLayout(self.l)
        
        

from sys import argv,exit
if __name__=='__main__':
    app = QApplication(argv)
    screen = MainWindow()
    #MainWindow.show()
    exit(app.exec_())
