import wx
import OkCancelDialog as od
import Table as tab
import DatabaseFunctions as db

class GenericSearch(wx.Dialog):

	def __init__(self, parent, title, globalVars):
		#od.OkCancelDialog.__init__(self, parent, title, (('Ok', self.OnOk), ('Cancel', self.OnCancel)), globalVars, style=wx.DEFAULT_DIALOG_STYLE | wx.RESIZE_BORDER)
		wx.Dialog.__init__(self, parent, title=title, style=wx.DEFAULT_DIALOG_STYLE | wx.RESIZE_BORDER)
		self.SetSizer(wx.BoxSizer(wx.HORIZONTAL))
		self.Fields = list()
		self.Content = wx.Panel(self, -1)
		self.Content.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.GetSizer().Add(self.Content, 1, wx.EXPAND | wx.ALL, 10)
		self.GlobalVars = globalVars
		self.Bind(wx.EVT_CLOSE, self.OnClose, self)

	def Initialize(self, form):
		self.FormData = form
		self.InitializeSearchPanel(form)
		self.InitializeTable(form)

	def InitializeSearchPanel(self, form):
		searchPanel = wx.Panel(self.Content, -1)
		searchPanel.SetSizer(wx.GridBagSizer())
		self.FieldsDropDown = wx.ComboBox(searchPanel, -1, style=wx.CB_READONLY)
		searchPanel.GetSizer().Add(wx.StaticText(searchPanel, -1, 'Search'), (0, 0), (1, 1), wx.RIGHT | wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL, 10)
		searchPanel.GetSizer().Add(self.FieldsDropDown, (0, 1), (1, 1), wx.RIGHT, 5)
		for formField in form['lstForm Field']:
			if formField['iType'] == 'Text Control':
				self.Fields.append(formField['sForm Field Name'][13:])
				self.FieldsDropDown.Append(formField['sField Label'][1:])
			pass
		self.FieldsDropDown.SetSelection(0)
		self.SearchValue = wx.TextCtrl(searchPanel, -1, size=(300, -1))
		searchPanel.GetSizer().Add(self.SearchValue, (0, 2), (1, 1), wx.RIGHT, 5)
		searchButton = wx.Button(searchPanel, -1, 'Search')
		searchButton.Bind(wx.EVT_BUTTON, self.OnSearch, searchButton)
		searchPanel.GetSizer().Add(searchButton, (0, 3), (1, 1), wx.RIGHT, 5)
		self.Content.GetSizer().Add(searchPanel, 0, wx.EXPAND)

	def InitializeTable(self, form):
		self.Results = tab.Table(self.Content)
		self.RowIDs = list()
		self.SelectedRecords = list()
		self.Content.GetSizer().Add(self.Results, 1, wx.EXPAND| wx.TOP, 10)
		for field in form['lstForm Field']:
			if field['iType'] == 'Text Control':
				columnName = field['sForm Field Name'].replace('FORM_FIELD : ', '')
				columnLabel = field['sField Label'][1:]
				self.Results.AddColumnName(columnName)
				self.Results.AddColumn(columnLabel)
		self.Results.Bind(wx.EVT_LIST_ITEM_SELECTED, self.OnSelection, self.Results)
		self.Results.Bind(wx.EVT_LIST_ITEM_DESELECTED, self.OnSelection, self.Results)
		self.Results.Bind(wx.EVT_LIST_ITEM_ACTIVATED, self.OnActivate, self.Results)
		pass

	def OnOk(self, event):
		self.Destroy()
		pass

	def OnCancel(self, event):
		self.Destroy()
		pass

	def OnSearch(self, event):
		tableName = self.FormData['sEntity Name']
		connection = db.Connect('localhost', 'root', 'password@123', 'testDb', self.OnError)
		cols = ''
		for field in self.Fields:
			cols = cols + field + ', '
		cols = cols[:-2]
		statement = 'select ' + cols + ' from ' + tableName + ' where ' + self.Fields[self.FieldsDropDown.GetSelection()] + '=%s'
		values = list()
		values.append(self.SearchValue.GetValue())
		print statement
		results = db.ExecuteQuery(statement, values, connection, self.OnError)
		if results == None:
			wx.MessageDialog(None, 'No records were found matching the search criteria', '0 record found').ShowModal()
		else:
			self.Results.Clear()
			del self.RowIDs[:]
			for record in results:
				self.AddRecord(record)
			pass

	def OnSelection(self, event):
		self.SelectedRecords = list()
		selections = self.Results.GetSelections()
		for selection in selections:
			self.SelectedRecords.append(self.RowIDs[selection])


	def OnError(self, error):
			wx.MessageDialog(None, 'Some Error Occured. Error Code : %d\nError Message : %s' % (error[0], error[1]), 'Error').ShowModal()

	def AddRecord(self, record):
		for name, val in record.iteritems():
			if name.endswith('__record_id__'):
				self.RowIDs.append(record[name])
		self.Results.AddRow(record)

	def OnActivate(self, event):
		self.Destroy()

	def OnClose(self, event):
		self.Destroy()

