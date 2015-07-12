import  wx
import  wx.lib.scrolledpanel as scrolled
import ComboBox as cb
import ListBox as lb
import DataSource as ds
import time

class Form(scrolled.ScrolledPanel):

	def __init__(self, parent, form):
		scrolled.ScrolledPanel.__init__(self, parent, -1)
		self.ContentPanel = wx.Panel(self)
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.GetSizer().Add(self.ContentPanel, 1, wx.EXPAND)
		self.Controls = dict()
		self.FormData = form
		self.InitializeFormFields()
		self.SetAutoLayout(1)
		self.SetupScrolling()
		self.Value = dict()
		self.Value[self.FormData['sEntity Name']] = list()

	def InitializeFormFields(self):
		self.ContentPanel.SetSizer(wx.GridBagSizer())
		self.MaxRow = 0
		for formField in self.FormData['lstForm Field']:
			ctrl = self.GetField(formField)
			labelRequired = True
			if formField['iType'] == 'Check Box':
				labelRequired = False
			self.Controls[formField['sForm Field Name'][13:]] = ctrl
			if self.FormData['sColumns in Layout'] == 'One Column':
				if formField['sField Label'].startswith('file'):
					lbl = formField['sField Label'][4:]
				else:
					lbl = formField['sField Label'][1:]
				if labelRequired:
					self.ContentPanel.GetSizer().Add(wx.StaticText(self.ContentPanel, -1, lbl), (formField['Form Field Layout']['iGrid Row'] + 1, 1), (1, 1), wx.ALL | wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL, 3)
				if formField['Form Field Layout']['iGrid Row'] + 1 > self.MaxRow:
					self.MaxRow = formField['Form Field Layout']['iGrid Row'] + 1
				if formField['Form Field Layout']['bExpand Horizontally']:
					self.ContentPanel.GetSizer().Add(ctrl, (formField['Form Field Layout']['iGrid Row'] + 1, 2), (formField['Form Field Layout']['iGrid Width'], formField['Form Field Layout']['iGrid Height']), wx.ALL | wx.EXPAND, 3)
				else:
					self.ContentPanel.GetSizer().Add(ctrl, (formField['Form Field Layout']['iGrid Row'] + 1, 2), (formField['Form Field Layout']['iGrid Width'], formField['Form Field Layout']['iGrid Height']), wx.ALL, 3)
			elif self.FormData['sColumns in Layout'] == 'Two Columns':
				if formField['sField Label'].startswith('file'):
					lbl = formField['sField Label'][4:]

				else:
					lbl = formField['sField Label'][1:]
				self.ContentPanel.GetSizer().Add(wx.StaticText(self.ContentPanel, -1, lbl), (formField['Form Field Layout']['iGrid Row']/2 + 1, (formField['Form Field Layout']['iGrid Row']%2)*2 + 1), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 3)
				if formField['Form Field Layout']['iGrid Row']/2 + 1 > self.MaxRow:
					self.MaxRow = formField['Form Field Layout']['iGrid Row']/2 + 1
				self.ContentPanel.GetSizer().Add(ctrl, (formField['Form Field Layout']['iGrid Row']/2 + 1, (formField['Form Field Layout']['iGrid Row']%2)*2 + 2), (formField['Form Field Layout']['iGrid Width'], formField['Form Field Layout']['iGrid Height']), wx.ALL, 3)
			elif self.FormData['sColumns in Layout'] == 'Custom Layout':
				self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, formField['sField Label']), (formField['Form Field Layout']['iGrid Row'], formField['Form Field Layout']['iGrid Column'] - 1), (1, 1), wx.ALL, 3)
				if formField['Form Field Layout']['iGrid Row'] > self.MaxRow:
					self.MaxRow = formField['Form Field Layout']['iGrid Row']
				if formField['Form Field Layout']['bExpand Horizontally']:
					self.ContentPanel.GetSizer().Add(ctrl, (formField['Form Field Layout']['iGrid Row'], formField['Form Field Layout']['iGrid Column']), (formField['Form Field Layout']['iGrid Width'], formField['Form Field Layout']['iGrid Height']), wx.ALL | wx.EXPAND, 3)
				else:
					self.ContentPanel.GetSizer().Add(ctrl, (formField['Form Field Layout']['iGrid Row'], formField['Form Field Layout']['iGrid Column']), (formField['Form Field Layout']['iGrid Width'], formField['Form Field Layout']['iGrid Height']), wx.ALL, 3)

		if self.FormData['sColumns in Layout'] == 'One Column':
			self.ContentPanel.GetSizer().AddGrowableCol(0)
			self.ContentPanel.GetSizer().AddGrowableCol(3)
			self.ContentPanel.GetSizer().AddGrowableRow(0)
			self.ContentPanel.GetSizer().AddGrowableRow(self.MaxRow + 1)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (0, 0), (1, 1), wx.EXPAND)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (0, 3), (1, 1), wx.EXPAND)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (self.MaxRow + 1, 0), (1, 1), wx.EXPAND)
		elif self.FormData['sColumns in Layout'] == 'Two Columns':
			self.ContentPanel.GetSizer().AddGrowableCol(0)
			self.ContentPanel.GetSizer().AddGrowableCol(5)
			self.ContentPanel.GetSizer().AddGrowableRow(0)
			self.ContentPanel.GetSizer().AddGrowableRow(self.MaxRow + 1)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (0, 0), (1, 1), wx.EXPAND)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (0, 5), (1, 1), wx.EXPAND)
			self.ContentPanel.GetSizer().Add(wx.StaticText(self, -1, ''), (self.MaxRow + 1, 0), (1, 1), wx.EXPAND)
		elif self.FormData['sColumns in Layout'] == 'Custom Layout':
			for i in range(0, 100):
				self.ContentPanel.GetSizer().AddGrowableCol(i)
		pass

	def GetField(self, formField):
		if formField['iType'] == 'Text Control' or formField['iType'] == 'Email Control':
			return wx.TextCtrl(self.ContentPanel, -1, size=((formField['iSize'] + 5) * 10, -1))
		elif formField['iType'] == 'Multiline Text Control':
			return wx.TextCtrl(self.ContentPanel, -1, wx.TE_MULTILINE)
		elif formField['iType'] == 'Combo Box':
			return self.CreateComboBox(formField)
		elif formField['iType'] == 'List Box':
			return self.CreateListBox(formField)
		elif formField['iType'] == 'Check Box':
			return wx.CheckBox(self.ContentPanel, -1, formField['sField Label'][1:])
		elif formField['iType'] == 'File Picker':
			return wx.FilePickerCtrl(self.ContentPanel, -1)
		elif formField['iType'] == 'Date Picker':
			tc = wx.TextCtrl(self.ContentPanel, -1)
			tc.SetValue('' + str(time.localtime()[0]) + '/' + str(time.localtime()[1]) + '/' + str(time.localtime()[2]))
			return tc
		pass

	def CreateComboBox(self, formField):
		comboBox = cb.ComboBox(self.ContentPanel)
		options = formField['dctOption']
		comboBox.Initialize(options)
		return comboBox

	def CreateListBox(self, formField):
		listBox = lb.ListBox(self.ContentPanel)
		options = formField['dctOption']
		listBox.Initialize(options)
		return listBox

	def Reset(self):
		for formField in self.FormData['lstForm Field']:
			if formField['iType'] == 'Text Control' or formField['iType'] == 'Multiline Text Control' or formField['iType'] == 'Email Control':
				self.Controls[formField['sForm Field Name'][13:]].SetValue('')
			elif formField['iType'] == 'Combo Box' or formField['iType'] == 'List Box':
				self.Controls[formField['sForm Field Name'][13:]].SetSelection(0)
			elif formField['iType'] == 'Check Box':
				self.Controls[formField['sForm Field Name'][13:]].SetValue(False)
			elif formField['iType'] == 'File Picker':
				self.Controls[formField['sForm Field Name'][13:]].SetPath('')

	def GetValue(self):
		data = dict()
		for formField in self.FormData['lstForm Field']:
			if formField['iType'] == 'File Picker':
				data[formField['sForm Field Name'][13:]] = self.Controls[formField['sForm Field Name'][13:]].GetPath()
			else:
				data[formField['sForm Field Name'][13:]] = self.Controls[formField['sForm Field Name'][13:]].GetValue()
		self.Value[self.FormData['sEntity Name']].append(data)
		return self.Value

	def SetValue(self, values):
		del self.Value[self.FormData['sEntity Name']][:]
		for name, value in values.iteritems():
			if self.FormData['sEntity Name'] == name:
				self.Value[name] = value
				break
		for i in range(0, len(self.FormData['lstForm Field'])):
			formField = self.FormData['lstForm Field'][i]
			ctrl = self.Controls[formField['sForm Field Name'][13:]]
			val = self.Value[name][0][formField['sForm Field Name'][13:]]
			if formField['iType'] == 'File Picker':
				pass
			else:
				if val == None:
					ctrl.SetValue('')
				else:
					ctrl.SetValue(str(val))
		pass

