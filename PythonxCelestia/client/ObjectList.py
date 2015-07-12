import wx
import ButtonPanel as bp
import Table as tab
import Client as client
import EntityWorkspace as ew
import EditorWorkspace as edw

class ObjectList(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent, -1)
		self.RecordIDs = list()
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.ColumnNames = list()
		self.Value = dict()

	def Reset(self):
		del self.RecordIDs[:]
		self.Table.Reset()

	def SetValue(self, data):
		del self.Value[self.ListData['sEntity Name']][:]
		self.AddRecordsFor(self.ListData['Entity Workspace'], data)
		for tableName, records in data.iteritems():
			if tableName == self.ListData['sEntity Name']:
				self.AddRecord(records[0])

	def AddRecordsFor(self, entityWorkspace, data):
		for form in entityWorkspace['lstForm']:
			self.Value[form['sEntity Name']] = data[form['sEntity Name']]
		for simpleList in entityWorkspce['lstSimple List']:
			attrib = simpleList['sAttribute Name'][simpleList['sAttribute Name'].index('_') + 1:]
			if attrib.startswith('file'):
				tableName = simpleList['sEntity Name'] + '_' + attrib[4:]
			else:
				tableName = simpleList['sEntity Name'] + '_' + attrib[1:]
			self.Value[simpleList['sEntity Name']] = data[tableName]
		for objectList in entityWorkspce['lstObject List']:
			self.AddRecordsFor(objectList['Entity Workspace'], data)
		for entityWorkspacePanel in entityWorkspace['lstEntity Workspace Panel']:
			self.AddRecordsFor(entityWorkspacePanel, data)

	def GetValue(self):
		#print self.Value
		return self.Value

	def Initialize(self, objectList, globalVars):
		self.GlobalVars = globalVars
		self.ListData = objectList
		self.InitializeButtonPanel(globalVars)
		self.InitializeTable()
		pass

	def InitializeButtonPanel(self, globalVars):
		buttons = list()
		for action in self.ListData['lstAction']:
			buttons.append((action['sLabel'], self.HandleEvent))
		self.ButtonPanel = bp.ButtonPanel(self, buttons, globalVars)
		for action in self.ListData['lstAction']:
			globalVars['Actions'][globalVars['CurrentActionID']] = action['sAction'] + '/' + action['sTarget']
			globalVars['CurrentActionID'] = globalVars['CurrentActionID'] + 1
		self.GetSizer().Add(self.ButtonPanel, 0, wx.ALIGN_RIGHT | wx.ALL, 5)

	def InitializeTable(self):
		self.Table = tab.Table(self)
		for column in self.ListData['lstColumn']:
			self.Table.AddColumn(column['sColumn Label'])
			self.Table.AddColumnName(column['sColumn Name'][16:].replace('.', '_').replace(' ', '_'))
		self.GetSizer().Add(self.Table, 1, wx.EXPAND | wx.ALL, 5)

	def HandleEvent(self, event):
		actionAndTarget = self.GlobalVars['Actions'][event.GetId()].split('/')
		action = actionAndTarget[0][9:]
		if action == 'Select Item':
			self.OnSelect(actionAndTarget)
		elif action == 'New Item':
			self.OnNew(actionAndTarget)
		elif action == 'Delete Item':
			self.OnDelete(actionAndTarget)
		elif action == 'Edit Item':
			self.OnEdit(actionAndTarget)
		elif action == 'Send EMail':
			self.OnSendEMail(actionAndTarget)

	def OnEdit(self, event):
		dlg = wx.Dialog(self.GlobalVars['MainFrame'], title='Editing ' + self.ListData['Entity Workspace']['sEntity Workspace Name'].replace('ENTITY_WORKSPACE : ', ''), style= wx.DEFAULT_DIALOG_STYLE | wx.RESIZE_BORDER)
		dlg.SetSizer(wx.BoxSizer(wx.VERTICAL))
		edws = edw.EditorWorkspace(dlg)
		itemIndex = self.Table.GetSelections()[0]
		recordID = self.RecordIDs[itemIndex]
		edws.Initialize(self.ListData['Entity Workspace'], self.GlobalVars)
		edws.Reset()
		self.GlobalVars['DataSourceStack'].append(edws)
		self.GlobalVars['WidgetStack'].append(dlg)
		dlg.GetSizer().Add(ews, 3, wx.EXPAND | wx.ALL, 5)
		dlg.SetSize((750, 500))
		dlg.Center()
		pass

	def OnNew(self, actionAndTarget):
		dlg = wx.Dialog(self.GlobalVars['MainFrame'], title='New ' + self.ListData['Entity Workspace']['sEntity Workspace Name'].replace('ENTITY_WORKSPACE : ', ''), style=wx.DEFAULT_DIALOG_STYLE | wx.RESIZE_BORDER)
		dlg.SetSizer(wx.BoxSizer(wx.VERTICAL))
		ews = ew.EntityWorkspace(dlg)
		ews.Initialize(self.ListData['Entity Workspace'], self.GlobalVars)
		ews.Reset()
		self.GlobalVars['DataSourceStack'].append(ews)
		self.GlobalVars['WidgetStack'].append(dlg)
		dlg.GetSizer().Add(ews, 3, wx.EXPAND | wx.ALL, 5)
		dlg.SetSize((750, 500))
		dlg.Center()
		before = len(self.GlobalVars['ValueStack'])
		dlg.ShowModal()
		after = len(self.GlobalVars['ValueStack'])
		if before < after:
			# newRecords is a dict of tableName -> list of Records
			newRecords = self.GlobalVars['ValueStack'].pop()
			for tableName, records in newRecords.iteritems():
				try:
					self.Value[tableName].extend(records)
				except KeyError:
					self.Value[tableName] = list()
					self.Value[tableName].extend(records)
				if tableName == self.ListData['Entity Workspace']['sEntity Workspace Name'][19:]:
					self.AddRecord(records[0])
					self.RecordIDs.append(records[0][tableName + '__record_id__'])
		print 'After addition'
		for table, records in self.Value.iteritems():
			for record in records:
				print record.values()
		print ''

	def OnSelect(self, event):
		pass

	'''
		Now lets ask the Data Source to delete the record.
		We need three things
		1) The table from which the data has to be deleted
		2) The Record ID Column Name
		3) The Record ID
		The table name is nothing but the same table into which data goes in through the entity workspace. Its name is enough
		The Record ID is nothing but table name + '_#RECORD_ID#'
		The value is self.RowIDs[row - i]
	'''
	def OnDelete(self, event):
		markedRows = self.Table.GetSelections()
		if len(markedRows) > 0:
			dlg = wx.MessageDialog(self.GlobalVars['MainFrame'], 'Are you sure you want to delete the selected records?', 'Confirm Action')
			res = dlg.ShowModal()
			if res == wx.ID_OK:
				markedRows.sort()
				for i in range(0, len(markedRows)):
					row = markedRows[i]
					self.Table.Delete(row - i)
					for tableName, records in self.Value.iteritems():
						if tableName == self.ListData['sEntity Name']:
							index = -1
							for i in range(0, len(records)):
								record = records[i]
								if record[tableName + '__record_id__'] == self.RecordIDs[row - i]:
									index = i
							if index != -1:
								del records[index]
								del self.RecordIDs[row - i]

		pass
	
	def OnSendEMail(self, event):
		pass

	def AddRecord(self, record):
		for name, value in record.iteritems():
			if name.count('__record_id__') != 0:
				self.RecordIDs.append(record[name])
		self.Table.AddRow(record)

