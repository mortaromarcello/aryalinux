import wx
import EntityWorkspacePanel as ewp
import DataEntryForm as df
import SimpleList as slist
import ObjectList as olist
import DatabaseFunctions as db

class EditorWorkspace(wx.Notebook):

	def __init__(self, parent):
		wx.Notebook.__init__(self, parent, -1)
		self.Tabs = dict()

	def Initialize(self, entityWorkspace, globalVars):
		self.EntityWorkspaceData = entityWorkspace
		'''
		print 'Initializing Entity Workspace : ' + entityWorkspace['sEntity Workspace Name']
		print str(len(entityWorkspace['lstSimple List'])) + ' Simple Lists'
		print str(len(entityWorkspace['lstObject List'])) + ' Object Lists'
		print str(len(entityWorkspace['lstEntity Workspace Panel'])) + ' Workspaces'
		print 'Doing Forms...'
		'''
		for form in entityWorkspace['lstForm']:
			frm = self.AddForm(form, globalVars)
			self.Tabs[form['sForm Name']] = frm
			self.AddPage(frm, form['sTab Label'] + ' Details')
		#print 'Simple Lists...'
		for simpleList in entityWorkspace['lstSimple List']:
			lst = self.AddSimpleList(simpleList, globalVars)
			self.Tabs[simpleList['sSimple List Name']] = lst
			self.AddPage(lst, simpleList['sTab Label'])
		#print 'Object Lists...'
		for objectList in entityWorkspace['lstObject List']:
			lst = self.AddObjectList(objectList, globalVars)
			self.Tabs[objectList['sObject List Name']] = lst
			self.AddPage(lst, objectList['sTab Label'])
		#print 'Workspace Panels...'
		for entityWorkspacePanel in entityWorkspace['lstEntity Workspace Panel']:
			panel = self.AddFormPanel(entityWorkspacePanel, globalVars)
			self.Tabs[entityWorkspacePanel['sEntity Workspace Name']] = panel
			self.AddPage(panel, entityWorkspacePanel['sEntity Workspace Name'].replace('ENTITY_WORKSPACE : ', ''))

	def AddForm(self, form, globalVars):
		frm = df.DataEntryForm(self)
		frm.Initialize(form, globalVars)
		return frm

	def AddFormPanel(self, entityWorkspacePanel, globalVars):
		panel = ewp.EntityWorkspacePanel(self, entityWorkspacePanel, globalVars)
		return panel

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
		for screenName, screen in self.Tabs.iteritems():
			screen.Reset()

	def GetValue(self):
		self.Value = dict()
		for screenName, screen in self.Tabs.iteritems():
			screenData = screen.GetValue()
			if screenName.startswith('FORM : '):
				key = screenName[7:] + '__record_id__'
				try:
					record_id = screenData[screenName[7:] + '__record_id__']
				except KeyError:
					screenData[screenName[7:] + '__record_id__'] = str(time.time()).replace('.', '')				
				key_value = screenData[screenName[7:] + '__record_id__']
				self.Value[screenName[7:]] = list()
				self.Value[screenName[7:]].append(screenData)
				break
		for screenName, screen in self.Tabs.iteritems():
			screenData = screen.GetValue()
			if screenName.startswith('SIMPLE_LIST : '):
				tableName = screenData.keys()[0]
				for record in screenData.values()[0]:
					record[key] = key_value
				try:
					self.Value[tableName].extend(screenData.values()[0])
				except KeyError:
					self.Value[tableName] = list()
					self.Value[tableName].extend(screenData.values()[0])
			if screenName.startswith('OBJECT_LIST : '):
				for key, value in screenData.iteritems():
					for record in value:
						record[key] = key_value
					try:
						self.Value[key].extend(value)
					except KeyError:
						self.Value[key] = list()
						self.Value[key].extend(value)
			if screenName.startswith('ENTITY_WORKSPACE_PANEL : '):
				for key, value in screenData.iteritems():
					for record in value.values()[0]:
						record[key] = key_value
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

	def OnError(self, error):
			wx.MessageDialog(None, 'Some Error Occured. Error Code : %d\nError Message : %s' % (error[0], error[1]), 'Error').ShowModal()

