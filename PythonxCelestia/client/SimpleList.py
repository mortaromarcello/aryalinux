import wx
import Client as client
import ButtonPanel as bp
import time

class SimpleList(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent, -1)
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))

	def Initialize(self, simpleList, globalVars):
		self.GlobalVars = globalVars
		self.ListData = simpleList
		self.InitializeButtonPanel(globalVars)
		self.List = wx.ListBox(self, -1)
		self.List.Bind(wx.EVT_LISTBOX_DCLICK, self.OnEdit, self.List)
		self.GetSizer().Add(self.List, 1, wx.EXPAND | wx.ALL, 5)
		self.Options = simpleList['dctChoice']
		self.Value = dict()
		attrib = self.ListData['sAttribute Name'][self.ListData['sAttribute Name'].index('_') + 1:]
		if attrib.startswith('file'):
			self.TableName = self.ListData['sEntity Name'] + '_' + attrib[4:]
			self.Value[self.TableName] = list()
		else:
			self.TableName = self.ListData['sEntity Name'] + '_' + attrib[1:]
			self.Value[self.TableName] = list()

	def InitializeButtonPanel(self, globalVars):
		buttons = list()
		for action in self.ListData['lstAction']:
			buttons.append((action['sLabel'], self.HandleEvent))
		self.ButtonPanel = bp.ButtonPanel(self, buttons, globalVars)
		for action in self.ListData['lstAction']:
			globalVars['Actions'][globalVars['CurrentActionID']] = action['sAction'] + '/' + action['sTarget']
			globalVars['CurrentActionID'] = globalVars['CurrentActionID'] + 1
		self.GetSizer().Add(self.ButtonPanel, 0, wx.ALIGN_RIGHT | wx.ALL, 5)
		pass

	def Reset(self):
		self.List.Clear()
		del self.Value[self.TableName][:]

	def SetValue(self, data):
		# The data that we receive here is similar to the data that we send out
		del self.Value[self.TableName][:]
		for tableName, records in data.iteritems():
			if tableName == self.TableName:
				self.Value[self.TableName].extend(records)
		for record in self.Value[self.TableName]:
			for name, value in record.iteritems():
				if not name.endswith('__record_id__'):
					self.List.Append(value)
		pass

	def GetValue(self):
		return self.Value

	def HandleEvent(self, event):
		actionAndTarget = self.GlobalVars['Actions'][event.GetId()].split('/')
		action = actionAndTarget[0][9:]
		if action.startswith('Add'):
			self.OnAdd(None)
		elif action.startswith('Edit'):
			self.OnEdit(None)
		elif action.startswith('Delete'):
			self.OnDelete(None)

	def OnAdd(self, event):
		if self.Options != None:
			dlg = wx.SingleChoiceDialog(self.GlobalVars['MainFrame'], 'Please choose a value', 'Adding ' + self.ListData['sSimple List Name'][17:], choices=self.Options.keys())
			res = dlg.ShowModal()
			if res == wx.ID_OK:
				self.Value[self.TableName].append(self.CreateRecord(self.Options[dlg.GetStringSelection()]))
				self.List.Append(dlg.GetStringSelection())
			dlg.Destroy()
		else:
			dlg = wx.TextEntryDialog(self.GlobalVars['MainFrame'], 'Please enter a value', 'Adding ' + self.ListData['sSimple List Name'][17:])
			res = dlg.ShowModal()
			if res == wx.ID_OK:
				if dlg.GetValue().strip() != '':
					self.Value[self.TableName].append(self.CreateRecord(dlg.GetValue()))
					self.List.Append(dlg.GetValue())
			dlg.Destroy()

	def OnEdit(self, event):
		if self.Options != None:
			dlg = wx.SingleChoiceDialog(self.GlobalVars['MainFrame'], 'Please choose a value', 'Editing ' + self.ListData['sSimple List Name'][17:], choices=self.Options.keys())
			dlg.SetSelection(self.Options.keys().index(self.List.GetStringSelection()))
			res = dlg.ShowModal()
			if res == wx.ID_OK:
				self.Values[self.List.GetSelection()] = self.CreateRecord(self.Options[dlg.GetStringSelection()])
				self.List.SetString(self.List.GetSelection(), dlg.GetStringSelection())
			dlg.Destroy()
		else:
			dlg = wx.TextEntryDialog(self.GlobalVars['MainFrame'], 'Please enter a value', 'Adding ' + self.ListData['sSimple List Name'][17:], )
			dlg.SetValue(self.List.GetStringSelection())
			res = dlg.ShowModal()
			if res == wx.ID_OK:
				if dlg.GetValue().strip() != '':
					self.Values[self.List.GetSelection()] = self.CreateRecord(dlg.GetValue())
					self.List.SetString(self.List.GetSelection(), dlg.GetValue())
			dlg.Destroy()

	def OnDelete(self, event):
		if self.List.GetSelection() != wx.NOT_FOUND:
			dlg = wx.MessageDialog(self.GlobalVars['MainFrame'], 'Do you really want to delete the ' + self.ListData['sSimple List Name'][17:] + ' from this list?', 'Confirm Action')
			if dlg.ShowModal() == wx.ID_OK:
				del self.Values[self.List.GetSelection()]
				self.List.Delete(self.List.GetSelection())
			dlg.Destroy()

	def CreateRecord(self, value):
		rec = dict()
		attrib = self.ListData['sAttribute Name'][self.ListData['sAttribute Name'].index('_') + 1:]
		if attrib.startswith('file'):

			rec[self.ListData['sEntity Name'] + '_' + attrib[4:] + '__record_id__'] = str(time.time()).replace('.', '')
		else:
			rec[self.ListData['sEntity Name'] + '_' + attrib[1:] + '__record_id__'] = str(time.time()).replace('.', '')
		rec[self.ListData['sAttribute Name']] = value
		rec[self.ListData['sEntity Name'] + '__record_id__'] = None
		return rec
