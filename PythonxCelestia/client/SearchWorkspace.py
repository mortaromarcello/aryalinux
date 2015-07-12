import wx
import Table as tab
import ButtonPanel as bp
import EditorWorkspace as edw

class SearchWorkspace(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent, -1)
		self.SearchPanel = None
		self.Results = tab.Table(self)
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.SearchCriteria = dict()
		self.RowIDs = list()

	def Initialize(self, searchWorkspace, globalVars):
		self.EditorWorkspace = searchWorkspace['Editor Workspace']
		self.SearchWorkspaceData = searchWorkspace
		self.GlobalVars = globalVars
		emailButton = False
		for column in searchWorkspace['lstColumn']:
			try:
				column['sColumn Name'].index('_e')
				emailButton = True
			except ValueError:
				pass
		if emailButton == False:
			del self.SearchWorkspaceData['lstAction'][2]
		self.InitializeSearchPanel()
		self.GetSizer().Add(wx.StaticLine(self, -1), 0, wx.EXPAND | wx.RIGHT | wx.LEFT, 10)
		self.InitializeButtonPanel()
		self.InitializeResults()

	def InitializeSearchPanel(self):
		self.SearchPanel = wx.Panel(self, -1)
		self.SearchPanel.SetSizer(wx.GridBagSizer())
		self.SearchPanel.GetSizer().AddGrowableCol(1)
		self.GetSizer().Add(self.SearchPanel, 0, wx.EXPAND | wx.ALL, 5)
		count = 0
		for searchCriteria in self.SearchWorkspaceData['lstSearch Criteria']:
			panel = wx.Panel(self.SearchPanel, -1)
			panel.SetSizer(wx.BoxSizer(wx.HORIZONTAL))
			self.SearchPanel.GetSizer().Add(panel, (count, 1), (1, 1), wx.ALL, 3)
			if searchCriteria['sSearch Type'] == 'Exact Search':
				self.SearchPanel.GetSizer().Add(wx.StaticText(self.SearchPanel, -1, searchCriteria['sLabel'][1:]), (count, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.ALL, 3)
				if searchCriteria['sLabel'].startswith('i'):
					control = wx.TextCtrl(panel, -1, size=wx.Size(75, -1), style=wx.TE_PROCESS_ENTER)
				elif searchCriteria['sLabel'].startswith('d'):
					control = wx.TextCtrl(panel, -1, size=wx.Size(150, -1), style=wx.TE_PROCESS_ENTER)
				elif searchCriteria['sLabel'].startswith('f'):
					control = wx.TextCtrl(panel, -1, size=wx.Size(100, -1), style=wx.TE_PROCESS_ENTER)
				else:
					control = wx.TextCtrl(panel, -1, size=wx.Size(300, -1), style=wx.TE_PROCESS_ENTER)
				panel.GetSizer().Add(control)
				control.Bind(wx.EVT_TEXT_ENTER, self.OnEnter, control)
				self.SearchCriteria['EXACT : ' + searchCriteria['sSearch Criteria Name'][18:]] = control
				count = count + 1
			if searchCriteria['sSearch Type'] == 'Range Search':
				self.SearchPanel.GetSizer().Add(wx.StaticText(self.SearchPanel, -1, searchCriteria['sLabel'][1:]), (count, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.ALL, 3)
				if searchCriteria['sLabel'].startswith('i'):
					control1 = wx.TextCtrl(panel, -1, size=wx.Size(75, -1))
					control2 = wx.TextCtrl(panel, -1, size=wx.Size(75, -1))
				elif searchCriteria['sLabel'].startswith('f'):
					control1 = wx.TextCtrl(panel, -1, size=wx.Size(100, -1))
					control2 = wx.TextCtrl(panel, -1, size=wx.Size(100, -1))
				elif searchCriteria['sLabel'].startswith('d'):
					control1 = wx.TextCtrl(panel, -1, size=wx.Size(150, -1))
					control2 = wx.TextCtrl(panel, -1, size=wx.Size(150, -1))
				else:
					control1 = wx.TextCtrl(panel, -1, size=wx.Size(300, -1))
					control2 = wx.TextCtrl(panel, -1, size=wx.Size(300, -1))
				panel.GetSizer().Add(control1)
				control1.Bind(wx.TE_PROCESS_ENTER, self.OnEnter, control1)
				panel.GetSizer().Add(wx.StaticText(panel, -1, 'through'), 1, wx.ALIGN_CENTER_VERTICAL | wx.LEFT | wx.RIGHT, 10)
				panel.GetSizer().Add(control2)
				control2.Bind(wx.TE_PROCESS_ENTER, self.OnEnter, control2)
				self.SearchCriteria['RANGE : ' + searchCriteria['sSearch Criteria Name'][18:]] = (control1, control2)
				count = count + 1
		self.SearchButtonPanel = bp.ButtonPanel(self.SearchPanel, [['Search', self.GlobalVars['EventHandler'].DispatchAction]], self.GlobalVars)
		self.GlobalVars['Actions'][self.GlobalVars['CurrentActionID']] = 'Search/' + self.SearchWorkspaceData['sEntity Name']
		self.GlobalVars['CurrentActionID'] = self.GlobalVars['CurrentActionID'] + 1
		self.SearchID = self.GlobalVars['CurrentActionID'] - 1
		self.SearchPanel.GetSizer().Add(self.SearchButtonPanel, (count, 0), (1, 1), wx.ALL, 3)

	def InitializeButtonPanel(self):
		actions = self.SearchWorkspaceData['lstAction']
		buttons = list()
		for action in actions:
			buttons.append((action['sLabel'], self.HandleEvent))
		buttonPanel = bp.ButtonPanel(self, buttons, self.GlobalVars)
		for action in actions:
			self.GlobalVars['Actions'][self.GlobalVars['CurrentActionID']] = action['sAction'] + '/' + action['sTarget']
			self.GlobalVars['CurrentActionID'] = self.GlobalVars['CurrentActionID'] + 1
		self.GetSizer().Add(buttonPanel, 0, wx.ALIGN_RIGHT | wx.ALL, 5)

	def InitializeResults(self):
		self.GetSizer().Add(self.Results, 1, wx.EXPAND)
		for column in self.SearchWorkspaceData['lstColumn']:
			columnName = column['sColumn Name'].replace('REPORT_COLUMN : ', '')
			columnLabel = column['sColumn Label']
			self.Results.AddColumnName(columnName)
			self.Results.AddColumn(columnLabel)
		self.Results.Bind(wx.EVT_LIST_ITEM_SELECTED, self.OnSelection, self.Results)
		self.Results.Bind(wx.EVT_LIST_ITEM_DESELECTED, self.OnSelection, self.Results)

	def Reset(self):
		for name, searchCriteria in self.SearchCriteria.iteritems():
			if name.startswith('EXACT'):
				searchCriteria.SetValue('')
			elif name.startswith('RANGE'):
				searchCriteria[0].SetValue('')
				searchCriteria[1].SetValue('')
		self.Results.Clear()
		del self.RowIDs[:]

	def AddRecord(self, record):
		for name, val in record.iteritems():
			if name.endswith('__record_id__'):
				self.RowIDs.append(record[name])
		self.Results.AddRow(record)

	def GetValue(self):
		retval = dict()
		values = dict()
		for name, searchCriteria in self.SearchCriteria.iteritems():
			if name.startswith('EXACT'):
				if searchCriteria.GetValue() != '':
					values[name] = searchCriteria.GetValue()
			elif name.startswith('RANGE'):
				if searchCriteria[0].GetValue() != '' or searchCriteria[1].GetValue() != '':
					values[name] = (searchCriteria[0].GetValue(), searchCriteria[1].GetValue())
		retval[self.SearchWorkspaceData['sSearch Workspace Name']] = values
		columns = list()
		for column in self.SearchWorkspaceData['lstColumn']:
			columnName = column['sColumn Name'].replace('REPORT_COLUMN : ', '')
			columns.append(columnName)
		retval['QueryColumns'] = columns
		return retval

	def OnSelection(self, event):
		self.SelectedRecords = list()
		selections = self.Results.GetSelections()
		for selection in selections:
			self.SelectedRecords.append(self.RowIDs[selection])


	def HandleEvent(self, event):
		print 'Got it'
		print event.GetId()
		actionAndTarget = self.GlobalVars['Actions'][event.GetId()].split('/')
		print actionAndTarget
		action = actionAndTarget[0][9:]
		if action.endswith('Delete Item'):
			self.OnDelete(actionAndTarget)
		elif action.endswith('Edit Item'):
			self.OnEdit(actionAndTarget)
		elif action.endswith('Send EMail'):
			self.OnSendEMail(actionAndTarget)

	def OnDelete(self, actionAndTarget):
		try:
			result = self.GlobalVars['DataSource'].DeleteRecordsForEntityWorkspace(self.EditorWorkspace, self.SelectedRecords)
			if result == 'Success':
				for record in self.SelectedRecords:
					self.Results.Delete(record)
				self.SelectedRecords = list()
		except AttributeError:
			wx.MessageDialog(self.GlobalVars['MainFrame'], 'No record(s) were selected for deletion.', 'Error').ShowModal()

	def OnEdit(self, actionAndTarget):
		dlg = wx.Dialog(self.GlobalVars['MainFrame'], title='Editing ' + self.EditorWorkspace['sEntity Workspace Name'].replace('ENTITY_WORKSPACE : ', ''), style= wx.DEFAULT_DIALOG_STYLE | wx.RESIZE_BORDER)
		dlg.SetSizer(wx.BoxSizer(wx.VERTICAL))
		edws = edw.EditorWorkspace(dlg)
		edws.Initialize(self.EditorWorkspace, self.GlobalVars, self.RowIDs[self.Results.GetSelections()[0]])
		self.GlobalVars['DataSourceStack'].append(edws)
		self.GlobalVars['WidgetStack'].append(dlg)
		dlg.GetSizer().Add(edws, 3, wx.EXPAND | wx.ALL, 5)
		dlg.SetSize((750, 500))
		dlg.Center()
		dlg.Bind(wx.EVT_CLOSE, self.OnClose, dlg)
		dlg.Maximize()
		dlg.ShowModal()
		pass

	def OnSendEMail(self, actionAndTarget):
		pass


	def OnClose(self, event):
		self.GlobalVars['DataSourceStack'].pop()
		self.GlobalVars['WidgetStack'].pop().Destroy()

	def OnEnter(self, event):
		evt = wx.CommandEvent()
		evt.SetId(self.SearchID)
		print evt.GetId()
		print 'Dispatching'
		self.GlobalVars['EventHandler'].DispatchAction(evt)

