import wx
import Client as client
import DataSource as ds
import AboutDialog as ad
import json
import time
import DatabaseFunctions as db

class EventHandler:
	def __init__(self, application, globalVars):
		self.Application = application
		self.GlobalVars = globalVars
		
	def DispatchAction(self, event):
		actionAndTarget = self.GlobalVars['Actions'][event.GetId()].split('/')
		#print actionAndTarget[0]
		if actionAndTarget[0] == 'Open New Form':
			self.Application.SwitchScreen(actionAndTarget[1])
		elif actionAndTarget[0] == 'Search':
			searchWorkspace = self.GlobalVars['DataSourceStack'].pop()
			searchData = searchWorkspace.GetValue()
			self.GlobalVars['DataSourceStack'].append(searchWorkspace)
			queryColumns = searchData['QueryColumns']
			for key, value in searchData.iteritems():
				if key.startswith('SEARCH'):
					tableName = key[18:]
					searchCriteria = value
			columns = tableName + '__record_id__, '
			conditions = ''
			values = list()
			for col in queryColumns:
				columns = columns + col + ', '
			columns = columns[0:-2]
			for conditionName, value in searchCriteria.iteritems():
				if conditionName.startswith('EXACT'):
					if conditionName[8:][conditionName[8:].index('_') + 1][0] == 'i' or conditionName[8:][conditionName[8:].index('_') + 1][0] == 'f':
						conditions = conditions + conditionName[8:] + '=' + value + ' and '
					else:
						conditions = conditions + conditionName[8:] + '=%s and '
						values.append(value)
				else:
					if conditionName[8:][conditionName[8:].index('_') + 1][0] == 'i' or conditionName[8:][conditionName[8:].index('_') + 1][0] == 'f':
						conditions = conditions + conditionName[8:] + ' between ' + value[0] + ' and ' + value[1] + ' and '
					else:
						conditions = conditions + conditionName[8:] + ' between %s and %s and '
						values.append(value[0])
						values.append(value[1])
			if conditions != '':
				conditions = conditions[0:-5]
			if len(searchCriteria) == 0:
				statement = 'select ' + columns + ' from ' + tableName
				values = None
			else:
				statement = 'select ' + columns + ' from ' + tableName + ' where ' + conditions
			connection = db.Connect(self.GlobalVars['Database Properties']['sServer Name'], self.GlobalVars['Database Properties']['sUsername'], self.GlobalVars['Database Properties']['sPassword'], self.GlobalVars['Database Properties']['sDatabase Name'], self.OnError)
			results = db.ExecuteQuery(statement, values, connection, self.OnError)
			if results == None:
				wx.MessageDialog(None, 'No records were found matching the search criteria', '0 record found').ShowModal()
			else:
				searchWorkspace.Results.Clear()
				del searchWorkspace.RowIDs[:]
				for record in results:
					searchWorkspace.AddRecord(record)
				pass
		elif actionAndTarget[0] == 'Log Off':
			self.Application.SwitchScreen('LOGIN_SCREEN')
		elif actionAndTarget[0] == 'Exit':
			exit(0)
		elif actionAndTarget[0] == 'Open Search Form':
			self.Application.SwitchScreen(actionAndTarget[1])
		elif actionAndTarget[0] == 'Show Dashboard':
			self.Application.SwitchScreen(actionAndTarget[1])
		elif actionAndTarget[0] == 'ACTION : Save Form Data':
			ews = self.GlobalVars['DataSourceStack'].pop()
			data = ews.GetValue()
			if len(self.GlobalVars['WidgetStack']) > 0:
				self.GlobalVars['ValueStack'].append(data)
				self.GlobalVars['WidgetStack'].pop().Destroy()
			else:
				self.GlobalVars['DataSourceStack'].append(ews)
				connection = db.Connect(self.GlobalVars['Database Properties']['sServer Name'], self.GlobalVars['Database Properties']['sUsername'], self.GlobalVars['Database Properties']['sPassword'], self.GlobalVars['Database Properties']['sDatabase Name'], self.OnError)
				totalRecords = 0
				for tableName, records in data.iteritems():
					db.InsertMultiple(tableName, records, connection, self.OnError)
					totalRecords = totalRecords + len(records)
				wx.MessageDialog(None, '%d records were updated into the database.' % (totalRecords), 'Update Successful').ShowModal()
				connection.close()
			'''
			This is how the data of the EntityWorkspace is saved into the database:
			1) Iterate through all the items in the data
			2) In case the key is that of a form, then save the data of the form into the database.
			3) Retreive the key that would be generated
			4) Simple Lists and Object Lists should be capable enough to return a list. This list would contain all the IDs
			5) The IDs list that would be returned by the simple list is converted into a dict
			6) The IDs list that would be returned by the object list is also converted into a dict
			7) Save all the data..
			'''
			'''
			recordID = None
			for name, values in data.iteritems():
				if name.startswith('FORM'):
					connection = db.Connect(self.GlobalVars['Database Properties']['sServer Name'], self.GlobalVars['Database Properties']['sUsername'], self.GlobalVars['Database Properties']['sPassword'], self.GlobalVars['Database Properties']['sDatabase Name'], self.OnError)
					recordID = db.InsertData(name.replace('FORM : ', ''), values, connection, self.OnError)
			if recordID != None:
				self.GlobalVars['ValueStack'].append(recordID)
				for name, values in data.iteritems():
					if name.startswith('SIMPLE_LIST'):
						if len(values) > 2:
							tableName = values[len(values) - 3]
							columnName = values[len(values) - 2]
							foreignKey = values[len(values) - 1] + '__record_id__'
							record = dict()
							for i in range(0, len(values) - 3):
								value = values[i]
								record[columnName] = value
								record[foreignKey] = recordID[foreignKey]
								connection = db.Connect(self.GlobalVars['Database Properties']['sServer Name'], self.GlobalVars['Database Properties']['sUsername'], self.GlobalVars['Database Properties']['sPassword'], self.GlobalVars['Database Properties']['sDatabase Name'], self.OnError)
								db.InsertData(tableName, record, connection, self.OnError)
								time.sleep(0.010)
						pass
					elif name.startswith('OBJECT_LIST'):
						if len(values) > 2:
							tableName = values[len(values) - 1] + '_' + values[len(values) - 2][:values[len(values) - 2].index('_')]
							record = dict()
							for i in range(0, len(values) - 2):
								value = values[i]
								record[values[len(values) - 2]] = value
								record[values[len(values) - 1] + '__record_id__'] = recordID[values[len(values) - 1] + '__record_id__']
								connection = db.Connect(self.GlobalVars['Database Properties']['sServer Name'], self.GlobalVars['Database Properties']['sUsername'], self.GlobalVars['Database Properties']['sPassword'], self.GlobalVars['Database Properties']['sDatabase Name'], self.OnError)
								db.InsertData(tableName, record, connection, self.OnError)
								time.sleep(0.010)
						pass
				wx.MessageDialog(None, 'Data was saved succesfully in the database', 'Success').ShowModal()
				ews.Reset()
			else:
				self.OnError([0x0002, 'Could not save the form\'s data. Cascade Save Failed.'])
			self.GlobalVars['DataSourceStack'].append(ews)
			if len(self.GlobalVars['WidgetStack']) > 0:
				self.GlobalVars['WidgetStack'].pop().Destroy()
			'''
		elif actionAndTarget[0] == 'ACTION : Cancel Action':
			if len(self.GlobalVars['DataSourceStack']) == 1:
				self.Application.SwitchScreen('DASH_BOARD')
			ews = self.Application.PopDS()
			if len(self.GlobalVars['WidgetStack']) != 0:
				dlg = self.Application.PopWS()
				dlg.Destroy()
		elif actionAndTarget[0] == 'About Software':
			ad.AboutDialog(self.GlobalVars['MainFrame'])
		elif actionAndTarget[0] == 'ACTION : Delete Item':
			eventSource = self.Application.PopDS()
			if len(eventSource.SelectedRecords) != 0:
				if len(self.GlobalVars['WidgetStack']) != 0:
					frame = self.GlobalVars['WidgetStack'].pop()
					dlg = wx.MessageDialog(frame, 'Are you sure you want to delete the selected records and all associated data?', 'Confirm Action', style=wx.YES_NO | wx.ICON_QUESTION)
					self.GlobalVars['WidgetStack'].append(frame)
				else:
					dlg = wx.MessageDialog(self.GlobalVars['MainFrame'], 'Are you sure you want to delete the selected records and all associated data?', 'Confirm Action', style=wx.YES_NO | wx.ICON_QUESTION)
				if dlg.ShowModal() == wx.ID_YES:
					self.GlobalVars['DataSource'].DeleteRecords(eventSource.EntityWorkspace['sEntity Name'], eventSource.SelectedRecords)
			self.GlobalVars['DataSourceStack'].append(eventSource)
		pass


	def SaveRecord(self):
		# This would save a record to the database.
		pass

	def UpdateRecord(self):
		# This would save a record to the database.
		pass

	def DeleteRecord(self):
		# This would save a record to the database.
		pass

	def GetRecords(self):
		# This would save a record to the database.
		pass

	def SendEmail(self):
		# This would save a record to the database.
		pass

	def LogOff(self):
		# This would save a record to the database.
		pass

	def OnLogin(self, event):
		pass


	def OnError(self, error):
		if len(self.GlobalVars['WidgetStack']) == 0:
			wx.MessageDialog(self.GlobalVars['MainFrame'], 'Some Error Occured. Error Code : %d\nError Message : %s' % (error[0], error[1]), 'Error').ShowModal()
		else:
			frame = self.GlobalVars['WidgetStack'].pop()
			wx.MessageDialog(frame, 'Some Error Occured. Error Code : %d\nError Message : %s' % (error[0], error[1]), 'Error').ShowModal()
			self.GlobalVars['WidgetStack'].append(frame)

	def Display(self, data):
		for tableName, records in data.iteritems():
			print '--------------------------------------------------------------'
			print '                  ' + tableName
			print '--------------------------------------------------------------'
			for record in records:
				print record
			print '--------------------------------------------------------------\n\n'
		pass

