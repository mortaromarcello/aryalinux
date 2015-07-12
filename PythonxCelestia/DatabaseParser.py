import time
import imp
import copy

'''
	This function returns tables that are predicted out of the entities and attributes specified by the user.
	For all classes that are present in the source file, a table is created
	In case there is an array of values for an attribute, a database table is created for the same
	In this database table, there are two columns. The first column is foreign key to the original table
	The second column is the value. There are more than one records in this table with same value for 1st column.
	All these records belong to one record only.

	In case there is a list of some other entities this entity is related to, then the following structure is created
	A table for storing the relationships. The first column in this table is the primary key of the first table
	The second table is primary key of the second table.

	In case an entity is related to just one instance of another entity, then they share each other's primary key

	Table names:

	1) For Tables of type 1, the database specific name is the entity name stripped off all special characters and spaces replaced by '_'.
		N.B. the entity name is simple name as per source
	2) For Tables of type 2, the name is the name of the parent entity stripped off special characters appended by attribute name stripped of special characters.
		N.B. The attribute name still contains 'arr' before it is appended. The entity name is <entity>_<attribute stripped of Special chars>
	3) For Tables of type 3, the name is the name of the parent entity stripped off special characters appended by attribute name stripped of special characters.
		N.B. The attribute name still contains 'lst' before it is appended. The entity name is <entity>_<attribute stripped of Special chars>

	The various datatypes the database columns can be are:
		varchar, int, float, mediumblob, datetime

	The first character of the attribute name specifies that. They are the following and correspond to the data types:
		s, i, f, file, d

	There are some attribute types that are housed in varchar columns:
		e(Stands for an email column)

	Similary few fields are housed in int columns:
		b(Stands for boolean. It usually results in a checkbox in forms)

	Now since attributes that start with 'file' also start with 'f' so the condition for 'file' should be checked prior to 'f'

	There is a certain naming convention followed for Database columns as well.

	1) In case it a regular column of a regular table, its name is Attribute name stripped off special characters and spaces converted to '_'
		N.B. The attribute name is <entity>_<attribute stripped of Special chars>
	2) In case it is the second column of table representing the array attribute of an entity, its same as case 1
		N.B. The attribute name is <entity>_<attribute stripped of Special chars without arr>
	3) In case it is a primary key, the name is entity name stripped off special characters and space replaced with '_' with 'iRecordID'
		N.B. The attribute name is <entity>_#iRecordID#

	The whole idea of this nomenclature is to make sure that the map file that is finally generated has no ambigiuos keys.

'''
def GetDatabaseTables(entityList, filename, filepath):
	databaseTables = list()
	for entity in entityList:
		table = GetDatabaseTable(entity, filename, filepath)
		databaseTables.append(table)
	for entity in entityList:
		ref = GetObject(entity, filename, filepath)
		for attribute in ref.Attributes:
			if attribute.startswith('arr'):
				databaseTable = {'sTable Name':entity.replace('\'', '').replace('/', '').replace('?', '') + '_' + attribute[4:].replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + str(time.time()).replace('.', ''), 'lstDatabase Column':list(), 'sEntity Name':entity + '_' + attribute[4:].replace(' ', '').replace('\'', '').replace('/', '').replace('?', '')}
				col = FindPrimaryKeyOfTableRepresentingEntity(entityList, filename, filepath, databaseTables, entity)
				if col == None:
					print "Error"
				databaseTable['lstDatabase Column'].append(col)
				databaseColumn = {'sField Name':'Record ID' + str(time.time()).replace('.', ''), 'sType':'bigint', 'iSize':0, 'bPrimary Key':True, 'bAuto Incremented':False, 'sAttribute Name':entity + '_' + attribute[4:].replace(' ', '').replace('\'', '').replace('/', '').replace('?', '') + '__record_id__'}
				databaseTable['lstDatabase Column'].append(databaseColumn)
				databaseColumn = {'sField Name':attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + str(time.time()).replace('.', ''), 'sType':None, 'iSize':0, 'bPrimary Key':False, 'bAuto Incremented':False, 'sAttribute Name':entity + '_' + attribute[3:].replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '')}
				if attribute[3] == 's' or attribute[3] == 'e':
					databaseColumn['sType'] = 'varchar'
					databaseColumn['iSize'] = 25
				elif attribute[3] == 'd':
					databaseColumn['sType'] = 'varchar'
				elif attribute[3] == 'i' or attribute[3] == 'b':
					databaseColumn['sType'] = 'int'
				elif attribute.startswith('file'):
					databaseColumn['sType'] = 'mediumblob'
				elif attribute[3] == 'f':
					databaseColumn['sType'] = 'float'
				databaseTable['lstDatabase Column'].append(databaseColumn)
				databaseTables.append(databaseTable)
	for entity in entityList:
		ref = GetObject(entity, filename, filepath)
		for attribute in ref.Attributes:
			if attribute.startswith('lst'):
				databaseTable = {'sTable Name':entity.replace('\'', '').replace('/', '').replace('?', '') + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + str(time.time()).replace('.', ''), 'lstDatabase Column':list(), 'sEntity Name':entity + '_' + attribute[3:].replace(' ', '').replace('\'', '').replace('/', '').replace('?', '')}
				databaseColumn = {'sField Name':'Record ID' + str(time.time()).replace('.', ''), 'sType':'bigint', 'iSize':0, 'bPrimary Key':True, 'bAuto Incremented':False, 'sAttribute Name':entity + '_' + attribute[3:].replace(' ', '').replace('\'', '').replace('/', '').replace('?', '') + '__record_id__'}
				databaseTable['lstDatabase Column'].append(databaseColumn)
				col1 = FindPrimaryKeyOfTableRepresentingEntity(entityList, filename, filepath, databaseTables, entity)
				if col1 == None:
					print "Error 1"
				databaseTable['lstDatabase Column'].append(col1)
				col2 = FindPrimaryKeyOfTableRepresentingEntity(entityList, filename, filepath, databaseTables, attribute[3:].replace(' ', ''))
				if col2 == None:
					print "Error 2"
				databaseTable['lstDatabase Column'].append(col2)
				databaseTables.append(databaseTable)
	for entity in entityList:
		ref = GetObject(entity, filename, filepath)
		for attribute in ref.Attributes:
			if not(attribute.startswith('lst') or attribute.startswith('arr') or attribute.startswith('dct') or attribute.startswith('file') or attribute.startswith('e') or attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('f') or attribute.startswith('b') or attribute.startswith('d')):
				InsertMutualPrimaryKeys(databaseTables, entity, attribute)
	return databaseTables

def InsertMutualPrimaryKeys(databaseTables, entity1, entity2):
	for table in databaseTables:
		if table['sEntity Name'] == entity1.replace(' ', ''):
			FirstTable = table
			break
	for table in databaseTables:
		if table['sEntity Name'] == entity2.replace(' ', ''):
			SecondTable = table
			break
	exists = False
	for column in FirstTable['lstDatabase Column']:
		if SecondTable['lstDatabase Column'][0]['sField Name'] == column['sField Name']:
			exists = True
	if not exists:
		col = SecondTable['lstDatabase Column'][0]
		col = copy.deepcopy(col)
		col['bPrimary Key'] = False
		FirstTable['lstDatabase Column'].append(col)
	exists = False
	for column in SecondTable['lstDatabase Column']:
		if FirstTable['lstDatabase Column'][0]['sField Name'] == column['sField Name']:
			exists = True
	if not exists:
		col = FirstTable['lstDatabase Column'][0]
		col = copy.deepcopy(col)
		col['bPrimary Key'] = False
		SecondTable['lstDatabase Column'].append(col)

def FindPrimaryKeyOfTableRepresentingEntity(entityList, filename, filepath, databaseTables, entity):
	for table in databaseTables:
		if table['sEntity Name'] == entity:
			for column in table['lstDatabase Column']:
				if column['sField Name'].index('iRecordID') != -1:
					col = copy.deepcopy(column)
					col['bPrimary Key'] = False
					return col
		

def GetDatabaseTable(entity, filename, filepath):
	databaseTable = {'sTable Name':entity.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + str(time.time()).replace('.', ''), 'lstDatabase Column':list(), 'sEntity Name':entity}
	ref = GetObject(entity, filename, filepath)
	recordId = {'sField Name':entity.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + '_iRecordID' + str(time.time()).replace('.', ''), 'sType':'bigint', 'iSize':0, 'bPrimary Key':True, 'bAuto Incremented':True, 'sAttribute Name':entity + '__record_id__'}
	databaseTable['lstDatabase Column'].append(recordId)
	for i in range(0, len(ref.Attributes)):
		attribute = ref.Attributes[i]
		if attribute.startswith('file') or attribute.startswith('e') or attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('f') or attribute.startswith('b') or attribute.startswith('d'):
			databaseTable['lstDatabase Column'].append(GetDatabaseColumn(entity, attribute))
	return databaseTable

def GetDatabaseColumn(entity, attribute):
	databaseColumn = {'sField Name':attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '') + str(time.time()).replace('.', ''), 'sType':None, 'iSize':0, 'bPrimary Key':False, 'bAuto Incremented':False, 'sAttribute Name':entity + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', '')}
	if attribute[0] == 's' or attribute[0] == 'e':
		databaseColumn['sType'] = 'varchar'
		databaseColumn['iSize'] = 25
	elif attribute[0] == 'd':
		databaseColumn['sType'] = 'datetime'
	elif attribute[0] == 'i' or attribute[0] == 'b':
		databaseColumn['sType'] = 'int'
	elif attribute.startswith('file'):
		databaseColumn['sType'] = 'mediumblob'
	elif attribute[0] == 'f':
		databaseColumn['sType'] = 'float'
	return databaseColumn

def GetObject(entity, filename, filepath):
	ref = getattr(imp.load_source(filename[0:-3], filepath), entity)()
	return ref

def GetDatabaseSQL(tables, databaseName):
	sql = 'drop database %s;\n' % (databaseName)
	sql = sql + 'create database %s;\n' % (databaseName)
	sql = sql + 'use %s;\n\n' % (databaseName)
	for table in tables:
		name = table['sEntity Name']
		sql = sql + 'create table ' + name + '\n'
		sql = sql + '(\n'
		for i in range(0, len(table['lstDatabase Column'])):
			column = table['lstDatabase Column'][i]
			sql = sql + '\t' + column['sAttribute Name'] + ' ' + column['sType']
			if column['iSize'] != 0:
				sql = sql + '(' + str(column['iSize']) + ')'
			if column['bPrimary Key']:
				sql = sql + ' primary key'
			if i != len(table['lstDatabase Column'])-1:
				sql = sql + ',\n'
			else:
				sql = sql + '\n);\n\n'
	return sql

def GetDatabaseMap(tables):
	dbMap = ''
	database = tables
	dbMap = dbMap + '<?php\n'
	for table in tables:
		dbMap = dbMap + '\t$map[\"' + table['sEntity Name'] + '\"] = \"' + table['sTable Name'] + '\";\n'
		for column in table['lstDatabase Column']:
			dbMap = dbMap + '\t\t$map[\"' + column['sAttribute Name'].replace('.', '_').replace(' ', '_') + '\"] = \"' + column['sField Name'] + '\";\n'
	dbMap = dbMap + '?>'
	return dbMap

