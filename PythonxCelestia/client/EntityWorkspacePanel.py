import wx
import DataEntryForm as df
import  wx.lib.scrolledpanel as scrolled
import SimpleList as slist
import ObjectList as olist
import DatabaseFunctions as db
import GenericSearch as gs

class EntityWorkspacePanel(scrolled.ScrolledPanel):

	def __init__(self, parent, entityWorkspace, globalVars):
		scrolled.ScrolledPanel.__init__(self, parent, -1)
		self.GlobalVars = globalVars
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.Sections = dict()
		self.Initialize(entityWorkspace, globalVars)
		self.SetAutoLayout(1)
		self.SetupScrolling()

	def Initialize(self, entityWorkspace, globalVars):
		self.EntityWorkspaceData = entityWorkspace
		for form in entityWorkspace['lstForm']:
			frm = self.AddForm(form, globalVars)
			self.Sections[form['sForm Name']] = frm
			staticBox = wx.StaticBox(self, -1, '   ' + form['sTab Label'] + '   ')
			staticBoxSizer = wx.StaticBoxSizer(staticBox, wx.HORIZONTAL)
			staticBoxSizer.Add(frm, 1, wx.EXPAND | wx.ALL, 5)
			self.GetSizer().Add(staticBoxSizer, 1, wx.EXPAND | wx.ALL, 5)
		for simpleList in entityWorkspace['lstSimple List']:
			lst = self.AddSimpleList(simpleList, globalVars)
			self.Sections[simpleList['sSimple List Name']] = lst
			staticBox = wx.StaticBox(self, -1, '   ' + simpleList['sTab Label'] + '   ')
			staticBoxSizer = wx.StaticBoxSizer(staticBox, wx.HORIZONTAL)
			staticBoxSizer.Add(lst, 1, wx.EXPAND | wx.ALL, 5)
			self.GetSizer().Add(staticBoxSizer, 1, wx.EXPAND | wx.ALL, 5)
		for objectList in entityWorkspace['lstObject List']:
			lst = self.AddObjectList(objectList, globalVars)
			self.Sections[objectList['sObject List Name']] = lst
			staticBox = wx.StaticBox(self, -1,  '   ' + objectList['sTab Label'] + '   ')
			staticBoxSizer = wx.StaticBoxSizer(staticBox, wx.HORIZONTAL)
			staticBoxSizer.Add(lst, 1, wx.EXPAND | wx.ALL, 5)
			self.GetSizer().Add(staticBoxSizer, 1, wx.EXPAND | wx.ALL, 5)

	def AddForm(self, form, globalVars):
		form['lstAction'].append({'sLabel':'&Select', 'sAction':'ACTION : Search', 'sTarget':'SEARCH_WORKSPACE : ' + form['sEntity Name'], 'sMnemonic':'S'})
		frm = df.DataEntryForm(self, self.OnSelect)
		frm.Initialize(form, globalVars)
		return frm

	def AddSimpleList(self, simpleList, globalVars):
		lst = slist.SimpleList(self)
		simpleList['sEntity Name'] = self.EntityWorkspaceData['sEntity Workspace Name'][19:]
		lst.Initialize(simpleList, globalVars)
		return lst

	def AddObjectList(self, objectList, globalVars):
		lst = olist.ObjectList(self)
		objectList['sEntity Name'] = self.EntityWorkspaceData['sEntity Workspace Name'][19:]
		lst.Initialize(objectList, globalVars)
		return lst

	def Reset(self):
		for screenName, screen in self.Sections.iteritems():
			screen.Reset()

	def GetValue(self):
		self.Value = dict()
		for screenName, screen in self.Tabs.iteritems():
			screenData = screen.GetValue()
			if screenName.startswith('FORM : '):
				self.Value[screenName[7:]] = list()
				self.Value[screenName[7:]].append(screenData)
			if screenName.startswith('SIMPLE_LIST : '):
				tableName = screenData.keys()[0]
				try:
					self.Value[tableName].extend(screenData.values()[0])
				except KeyError:
					self.Value[tableName] = list()
					self.Value[tableName].extend(screenData.values()[0])
			if screenName.startswith('OBJECT_LIST : '):
				for key, value in screenData.iteritems():
					try:
						self.Value[key].extend(value)
					except KeyError:
						self.Value[key] = list()
						self.Value[key].extend(value)
			if screenName.startswith('ENTITY_WORKSPACE_PANEL : '):
				for key, value in screenData.iteritems():
					try:
						self.Value[key].extend(value)
					except KeyError:
						self.Value[key] = list()
						self.Value[key].extend(value)
		return self.Value
		

	def SetValue(self, values):
		self.Value = values
		# Give the data to the screens, they would pick up the data that they want
		for screenName, screen in self.Tabs.iteritems():
			screen.SetValue(values)

	def OnSave(self, event):
		pass

	def OnClear(self, event):
		pass

	def OnCancel(self, event):
		pass

	def FetchData(self, recordID):
		self.RecordID = recordID
		for form in self.EntityWorkspaceData['lstForm']:
			tableName = form['sForm Name'].replace('FORM : ', '')
			connection = db.Connect('localhost', 'root', 'password@123', 'testDb', self.OnError)
			data = db.ExecuteQuery('select * from ' + tableName + ' where ' + tableName + '__record_id__=' + str(self.RecordID), None, connection, self.OnError)
			if len(data) != 0:
				self.Tabs[form['sForm Name']].SetValue(data[0])
			else:
				wx.MessageDialog(None, 'The record that you selected is not editable', 'Error').ShowModal()
				return
		#print 'Simple Lists...'
		for simpleList in self.EntityWorkspaceData['lstSimple List']:
			attr = simpleList['sAttribute Name'][simpleList['sAttribute Name'].index('_') + 2:]
			temp = simpleList['sSimple List Name'][14:]
			temp = temp[0:temp.index('_') + 1]
			listTableName = temp + attr
			connection = db.Connect('localhost', 'root', 'password@123', 'testDb', self.OnError)
			data = db.ExecuteQuery('select * from ' + listTableName + ' where ' + tableName + '__record_id__=' + str(self.RecordID), None, connection, self.OnError)
			if len(data) != 0:
				self.Tabs[simpleList['sSimple List Name']].SetValue(data)
			pass
		#print 'Object Lists...'
		for objectList in self.EntityWorkspaceData['lstObject List']:
			temp = objectList['sObject List Name'][14:]
			temp = temp[0:temp.index('_')]
			attr = objectList['Entity Workspace']['sEntity Workspace Name'][19:]
			listTableName  = temp + '_' + attr
			connection = db.Connect('localhost', 'root', 'password@123', 'testDb', self.OnError)
			data = db.ExecuteQuery('select * from ' + attr + ' join ' + listTableName + ' on ' + attr + '.' + attr + '__record_id__=' + listTableName + '.' + listTableName + '__record_id__ where ' + listTableName + '.' + tableName + '__record_id__=' + str(self.RecordID), None, connection, self.OnError)
			print data
			if data != None:
				self.Tabs[objectList['sObject List Name']].SetValue(data)
			pass
		pass

	def OnSelect(self, event):
		g = gs.GenericSearch(None, 'Selecting ' + self.EntityWorkspaceData['lstForm'][0]['sTab Label'], self.GlobalVars)
		g.Initialize(self.EntityWorkspaceData['lstForm'][0])
		g.SetSize((800, 400))
		g.ShowModal()

