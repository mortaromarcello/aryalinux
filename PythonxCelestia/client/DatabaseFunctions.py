import MySQLdb as mysql
import time
import wx

def Connect(server, username, password, database, errorHandler):
	con = None
	try:
		con = mysql.connect(server, username, password, database)
	except mysql.Error, e:
		errorHandler(e)
	return con

def ExecuteQuery(statement, args, connection, errorHandler):
	try:
		cursor = connection.cursor(mysql.cursors.DictCursor)
		if args != None:
			cursor.execute(statement, args)
		else:
			cursor.execute(statement)
		resultSet = cursor.fetchall()
		if len(resultSet) > 0:
			return resultSet
		else:
			return None
	except mysql.Error, e:
		errorHandler(e)
	return None
	
def ExecuteUpdate(statement, connection, errorHandler):
	try:
		cursor = connection.cursor()
		cursor.execute(statement)
		connection.commit()
		return cursor.rowcount
	except mysql.Error, e:
		connection.rollback()
		errorHandler(e)
	return 0

def ExecuteBatch(statements, connection, errorHandler):
	try:
		for statement in statements:
			ExecuteUpdate(statement, connection)
		connection.commit()
		return True
	except mysql.Error, e:
		connection.rollback()
		errorHandler(e)
	return False

def InsertData(tableName, dictionary, connection, errorHandler):
	try:
		if connection != None:
			recordID = str(time.time()).replace('.', '')
			dictionary[tableName + '__' + 'record_id__'] = recordID
			cursor = connection.cursor()
			ps = ''
			keys = ''
			for i in range(0, len(dictionary)):
				ps = ps + '%s, '
				keys = keys + dictionary.keys()[i] + ', '
				if dictionary.values()[i] == '':
					# To insert NULL values. Since the form always returns '' for blank fields
					dictionary[dictionary.keys()[i]] = None
			ps = ps[0:-2]
			keys = keys[0:-2]
			cursor.execute('insert into ' + tableName + ' (' + keys + ') values (' + ps + ')', dictionary.values())
			connection.commit()
			return dictionary
		else:
			return None
	except mysql.Error, e:
		connection.rollback()
		errorHandler(e)
	except AttributeError, e:
		err = [0x0001, e]
		errorHandler(err)

def InsertBatch(tablesAndValues, connection, errorHandler):
	try:
		cursor = connection.cursor()
		for i in range(0, len(tablesAndValues)):
			tableAndValues = tablesAndValues[i]
			print 'Inserting :: ' + str(tableAndValues)
			InsertData(tableAndValues.keys()[0], tableAndValues.values()[0], connection, errorHandler)
			time.sleep(1)
		connection.commit()
	except mysql.Error, e:
		connection.rollback()
		errorHandler(e)
	pass

def InsertMultiple(table, records, connection, errorHandler):
	#print '%d records in %s' % (len(tableAndRecords[tableAndRecords.keys()[0]]), tableAndRecords.keys()[0])
	try:
		cursor = connection.cursor()
		sqlStatement = 'replace into ' + table
		keys = ''
		placeholders = ''
		record = records[0]
		for i in range(0, len(record.keys())):
			column = record.keys()[i]
			keys = keys + column + ', '
			placeholders = placeholders + '%s, '
		keys = '(' + keys[:-2] + ')'
		sqlStatement = sqlStatement + keys + ' values '
		placeholders = '(' + placeholders[:-2] + ')'
		values = list()
		for record in records:
			sqlStatement = sqlStatement + placeholders + ', '
			for val in record.values():
				values.append(val)
		sqlStatement = sqlStatement[:-2]
		rowsAffected = cursor.execute(sqlStatement, values)
	except mysql.Error, e:
		connection.rollback()
		errorHandler(e)
	pass
	return 0
