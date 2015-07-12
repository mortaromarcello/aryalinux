import wx
import pickle
import time
import os
import Uploader as up

class DataSource:
	def __init__(self, globalVars):
		self.GlobalVars = globalVars

	def Initialize(self, tables):
		self.Tables = tables
		if os.path.exists('database.dat'):
			f = open('database.dat', 'rb')
			self.Database = pickle.load(f)
			f.close()
		else:
			f = open('database.dat', 'wb')
			self.Database = dict()
			for table in self.Tables:
				self.Database[table['sEntity Name']] = list()
			pickle.dump(self.Database, f)
			f.close()
		pass

	def QueryTwoColumns(self, query):
		retVal = dict()
		return retVal

	def QueryOneColumn(self, query):
		retVal = list()
		return retVal

	def Query(self, query):
		retVal = list()
		return retVal

	def InsertRecord(self, data):
		recordID = str(time.time()).replace('.', '')
		for name, value in data.iteritems():
			response = ''
			if name.startswith('FORM'):
				print 'Found a form'
				entityName = name[7:]
				value[entityName + '_#RECORD_ID#'] = recordID
				value['__ACTION__'] = 'SAVE'
				value['__ENTITY_NAME__'] = entityName
				for n, v in value.iteritems():
					if n.startswith(entityName + '_b'):
						if v == True:
							value[n] = 1
						else:
							value[n] = 0
				postData = self.CreateRequestFormat(value)
				response = up.send_post(self.GlobalVars['Server'], postData[0], postData[1])
			elif name.startswith('OBJECT_LIST') and len(value) > 2:
				print 'Found a object list'
				entityName = name[14:]
				print entityName
				superEntityName = value.pop()
				fieldName = value.pop()
				for ids in value:
					subrecords = dict()
					subrecords[superEntityName + '_#RECORD_ID#'] = recordID
					subrecords[fieldName] = ids
					subrecords['__ACTION__'] = 'SAVE'
					subrecords['__ENTITY_NAME__'] = entityName
					postData = self.CreateRequestFormat(subrecords)
					response = up.send_post(self.GlobalVars['Server'], postData[0], postData[1])
			elif name.startswith('SIMPLE_LIST') and len(value) > 2:
				print 'Found a slist'
				entityName = name[14:]
				containerEntityName = value.pop()
				fieldName = value.pop()
				for value in value:
					subrecords = dict()
					subrecords[containerEntityName + '_#RECORD_ID#'] = recordID
					subrecords[fieldName] = value
					subrecords['__ACTION__'] = 'SAVE'
					subrecords['__ENTITY_NAME__'] = entityName
					postData = self.CreateRequestFormat(subrecords)
					response = up.send_post(self.GlobalVars['Server'], postData[0], postData[1])
			print response
		return 'Success:' + str(recordID)

	def InsertMultiple(self, data, entity):
		
		pass

	def DeleteRecords(self, tableName, idColumnName, values):
		data = dict()
		data['__ACTION__'] = 'DELETE'
		data['__ENTITY__NAME'] = tableName
		for value in values:
			data['VALUE'] = value
			print 'delete from ' + tableName + ' where ' + idColumnName + '=\'' + str(value) + '\''
			#up.send.post(self.GlobalVars['Server'], data, list())

	def UpdateRecord(self, query):
		pass

	def SendEMail(self, email):
		pass

	def Search(self, entityName, data):
		data['__ACTION__'] = 'SEARCH'
		data['__ENTITY_NAME__'] = entityName
		for name, value in data.iteritems():
			if name.startswith('EXACT'):
				data[name[8:]] = value
				del data[name]
			elif name.startswith('RANGE'):
				data[name[8:]] = value[0] + ':' + value[1]
				del data[name]
		response = up.send_post(self.GlobalVars['Server'], data, list())
		return response

	def CreateRequestFormat(self, data):
		files = dict()
		newdata = dict()
		for name, value in data.iteritems():
			if '_file' in name and value != '' and value != None:
				files[name] = value
				pass
			else:
				newdata[name] = value
		return (newdata, files)

	def DeleteRecordsForEntityWorkspace(self, entityWorkspace, recordIds):
		for record in recordIds:
			entityName = entityWorkspace['sEntity Workspace Name'].replace('ENTITY_WORKSPACE : ', '')
			for simpleList in entityWorkspace['lstSimple List']:
				self.GlobalVars['DataSource'].DeleteRecord(simpleList['sSimple List Name'][14:], entityName + '_#RECORD_ID#', recordId)
			for objectList in entityWorkspace['lstObject List']:
				'''
				We got to simplify this case else that would result in issues later on.
				Deletion of a record may or may not necessarily delete related records. So there are two things we can do about it.
				Leave it as it is and whenever the user feels like, he would delete the related records.
				Ask permission everytime a delete operation has to be performed and blindly do it.
				'''
				self.GlobalVars['DataSource'].DeleteRecord(objectList['sObject List Name'].replace('OBJECT_LIST : ', ''), entityName + '_#RECORD_ID#', recordId)
			self.GlobalVars['DataSource'].DeleteRecord(entityName, entityName + '_#RECORD_ID#', recordId)

