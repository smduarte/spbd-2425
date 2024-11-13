#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 29 00:51:20 2019

@author: nmp
"""

import socket
import datetime
import time
import sys
import threading

def processClient( conn, lines) :
    try: 
        firstTime = -1
        firstWallTime = -1
        for line in lines:
            if line == '' :
                break
            lineTime = datetime.datetime.strptime(line[:23], '%Y-%m-%dT%H:%M:%S.%f')
            if firstTime == -1 :
                firstTime = lineTime
                firstWallTime = datetime.datetime.now()
            diffTime = lineTime - firstTime
            diffMs = diffTime.total_seconds() * 1000 + diffTime.microseconds / 1000
            wallTime = datetime.datetime.now()
            diffWallTime = wallTime - firstWallTime
            diffWallMs = diffWallTime.total_seconds() * 1000 + diffWallTime.microseconds / 1000
            if diffWallMs < diffMs :
                time.sleep( (diffMs - diffWallMs) / 1000)

            wallTime = datetime.datetime.now()
            timestamp = wallTime.strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3]+'+0000';
            newline = timestamp + line[28:]
           
            conn.sendall( newline.encode())
        conn.close()
    except:
        try:
            conn.close()
        except:
            True
        True


HOST = "127.0.0.1"
PORT = 7777 

filename = "web.log"
if len(sys.argv) > 1:
    filename = sys.argv[1]
if len(sys.argv) > 2:
    PORT = int(sys.argv[2])
if len(sys.argv) > 3:
    HOST = int(sys.argv[2])
    PORT = int(sys.argv[3])

while True:
    try:
        conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        conn.connect((HOST, PORT))
        f = open(filename, "r")
        lines = f.readlines()
        f.close()
        processClient(conn, lines)
    except Exception as e:
        print(e)
        time.sleep(1.0)
