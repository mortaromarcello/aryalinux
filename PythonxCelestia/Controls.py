import wx
import imp
import Miscellaneous as misc
import functions
import pickle
import copy
import sys
sys.path.append('client')
import Client as cl
import functions
import AboutDialog as ad
import DatabaseParser as dbp
import DatabaseFunctions as db

class Table(wx.ListCtrl):

	def __init__(self, parent):
		wx.ListCtrl.__init__(self, parent, -1, style=wx.LC_REPORT)
		self.ColCount = 0
		self.RowCount = 0
		self.SelectedIndex = -1
		self.Bind(wx.EVT_LIST_ITEM_SELECTED, self.OnSelection, self)

	def OnSelection(self, event):
		self.SelectedIndex = event.GetIndex()

	def GetSelections(self):
		selections = list()
		itemIndex = -1;
		while True:
			itemIndex = self.GetNextItem(itemIndex, wx.LIST_NEXT_ALL, wx.LIST_STATE_SELECTED);
			if (itemIndex == -1):
				break
			selections.append(itemIndex)
		return selections

	def GetSelection(self):
		return self.SelectedIndex

	def AddColumn(self, columnHeading):
		self.InsertColumn(self.ColCount, columnHeading)
		self.ColCount = self.ColCount + 1

	def Delete(self, rowIndex):
		self.DeleteItem(rowIndex)
		if self.SelectedIndex == rowIndex:
			self.SelectedIndex = -1

	def DeleteRows(self, rowIndices):
		rowIndices.sort()
		#print rowIndices
		for i in range(0, len(rowIndices)):
			row = rowIndices[i]
			#print 'Deleting' + str(row)
			self.Delete(row - i)

	def AddDict(self, rowAsDict):
		if len(rowAsDict) > 0:
			keys = self.HeadingSource.Attributes
			if keys[0].startswith('dct') or keys[0].startswith('lst') or keys[0].startswith('arr'):
				self.InsertStringItem(self.RowCount, keys[0][3:] + 's ...')
			else:
				self.InsertStringItem(self.RowCount, str(rowAsDict[keys[0]]))
			for i in range(1, len(keys)):
				if keys[i].startswith('dct') or keys[i].startswith('lst') or keys[i].startswith('arr'):
					self.SetStringItem(self.RowCount, i, keys[i][3:] + 's ...')
				else:
					self.SetStringItem(self.RowCount, i, str(rowAsDict[keys[i]]))
			if self.RowCount%2 != 0:
				self.SetItemBackgroundColour(self.RowCount, wx.Colour(225, 225, 225))
			self.RowCount = self.RowCount + 1
		for i in range(0, len(self.HeadingSource.Attributes)):
			self.SetColumnWidth(i, wx.LIST_AUTOSIZE)
		for i in range(0, len(self.HeadingSource.Attributes)):
			if self.GetColumnWidth(i) < 150:
				self.SetColumnWidth(i, 150)

	def SetValue(self, objects):
		self.Clear()
		self.RowCount = 0
		for ref in objects:
			self.AddDict(ref)
		self.SelectedIndex = -1

	def SetHeading(self, ref):
		self.HeadingSource = ref
		for attribute in ref.Attributes:
			if attribute.startswith('dct') or attribute.startswith('arr') or attribute.startswith('lst'):
				self.AddColumn(attribute[3:])
			else:
				self.AddColumn(attribute[1:])

	def Clear(self):
		self.DeleteAllItems()

	def Replace(self, index, rowAsDict):
		if len(rowAsDict) > 0:
			keys = self.HeadingSource.Attributes
			for i in range(0, len(keys)):
				if keys[i].startswith('dct') or keys[i].startswith('lst') or keys[i].startswith('arr'):
					self.SetStringItem(self.RowCount, i, keys[i][3:] + 's ...')
				else:
					self.SetStringItem(self.RowCount, i, str(rowAsDict[keys[i]]))
			if self.RowCount%2 != 0:
				self.SetItemBackgroundColour(self.RowCount, wx.Colour(225, 225, 225))
			self.RowCount = self.RowCount + 1
		for i in range(0, len(self.HeadingSource.Attributes)):
			self.SetColumnWidth(i, wx.LIST_AUTOSIZE)
		for i in range(0, len(self.HeadingSource.Attributes)):
			if self.GetColumnWidth(i) < 150:
				self.SetColumnWidth(i, 150)

class ButtonPanel(wx.Panel):

	def __init__(self, parent, buttons):
		wx.Panel.__init__(self, parent)
		self.SetSizer(wx.GridSizer(1, len(buttons), 5, 5))

		for label, eventHandler in buttons.iteritems():
			if label == 'Ok':
				buttonID = wx.ID_OK
			elif label == 'Cancel':
				buttonID = wx.ID_CANCEL
			else:
				buttonID = -1
			button = wx.Button(self, buttonID, label)
			if buttonID == wx.ID_OK:
				button.SetDefault()
			self.GetSizer().Add(button, wx.ALL | wx.EXPAND, 5)
			button.Bind(wx.EVT_BUTTON, eventHandler, button)

class OkCancelDialog(wx.Dialog):

	def __init__(self, parent, title, buttons):
		wx.Dialog.__init__(self, parent, -1, title)
		self.Buttons = buttons
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(wx.StaticLine(self, -1), (1, 0), (1, 1), wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 10)
		self.GetSizer().AddGrowableRow(0);
		self.GetSizer().AddGrowableCol(0);
		self.GetSizer().Add(ButtonPanel(self, buttons), (2, 0), (1, 1), wx.LEFT | wx.RIGHT | wx.BOTTOM | wx.ALIGN_RIGHT, 10)

	def SetMainPanel(self, mainPanel):
		self.GetSizer().Add(mainPanel, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)

class ObjectList(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent)
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(ButtonPanel(self, {'&Add':self.OnAdd, '&Edit':self.OnEdit, '&Delete':self.OnDelete}), (0, 0), (1, 1), wx.ALIGN_RIGHT, 10)

		self.Objects = list()
		self.List = wx.ListBox(self, -1)
		self.List.Bind(wx.EVT_LISTBOX_DCLICK, self.OnEdit, self.List)

		self.GetSizer().Add(self.List, (1, 0), (1, 1), wx.EXPAND | wx.TOP | wx.ALIGN_RIGHT, 10)
		self.GetSizer().AddGrowableRow(1)
		self.GetSizer().AddGrowableCol(0)

	def OnAdd(self, event):
		if self.ModuleName != None and self.ModulePath != None:
			objectEditor = ObjectEditor(Application.MainFrame, 'New ' + self.Attribute[3:], self.Attribute[3:] + ' Properties')
			cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), self.Attribute[3:].replace(' ', ''))
			ref = cls()
			objectEditor.Initialize(ref, self.ModuleName, self.ModulePath)
			objectEditor.Pack()
			objectEditor.ShowModal()
			if objectEditor.ButtonPressed == 'Ok':
				ref = objectEditor.GetValue()
				self.Objects.append(ref)
				self.List.Append(functions.String(ref))
			objectEditor.Destroy()
		else:
			# Get One Line input
			if self.Options != None:
				dlg = wx.TextEntryDialog(Application.MainFrame, 'Please enter the ' + self.Attribute + ' that you want to add to the list')
			else:
				dlg = wx.SingleChoiceDialog(Application.MainFrame, 'Please choose the ' + self.Attribute + ' that you want to add to the list', choices=self.Options.keys())
			result = dlg.ShowModal()
			if self.Options != None:
				value1 = dlg.GetValue()
				value2 = dlg.GetValue()
			else:
				value1 = self.Options.values()[dlg.GetStringSelection()]
				value2 = dlg.GetStringSelection()
			if result == wx.ID_OK:
				self.Objects.append(value)
				self.List.Append(value)
				dlg.Destroy()
		pass


	def OnEdit(self, event):
		if self.ModuleName != None and self.ModulePath != None and self.List.GetSelection() != wx.NOT_FOUND:
			objectEditor = ObjectEditor(Application.MainFrame, self.Attribute[3:] + ' Editor', self.Attribute[3:] + ' Properties')
			cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), self.Attribute[3:].replace(' ', ''))
			ref = cls()
			objectEditor.Initialize(ref, self.ModuleName, self.ModulePath)
			objectEditor.Pack()
			objectEditor.Show()
			objectEditor.SetValue(self.Objects[self.List.GetSelection()])
			objectEditor.ShowModal()
			if objectEditor.ButtonPressed == 'Ok':
				self.Objects[self.List.GetSelection()] = objectEditor.GetValue()
				self.List.SetString(self.List.GetSelection(), functions.String(objectEditor.GetValue()))
			objectEditor.Destroy()
		else:
			pass
		pass

	def OnDelete(self, event):
		if self.List.GetSelection() != wx.NOT_FOUND:
			index = self.List.GetSelection()
			self.List.Delete(index)
			del self.Objects[index]
		pass

	def GetValue(self):
		return self.Objects

	def SetValue(self, valueList):
		if valueList != None and len(valueList) != 0:
			del(self.Objects)
			self.Objects = valueList
			self.List.Clear()
			try:
				for value in valueList:
					self.List.Append(functions.String(value))
			except AttributeError:
				#print valueList
				pass
		pass

class ObjectListEx(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent)
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(ButtonPanel(self, {'&Add':self.OnAdd, '&Edit':self.OnEdit, '&Delete':self.OnDelete}), (0, 0), (1, 1), wx.ALIGN_RIGHT, 10)

		self.Objects = list()
		self.List = Table(self)
		self.List.Bind(wx.EVT_LIST_ITEM_ACTIVATED, self.OnEdit, self.List)

		self.GetSizer().Add(self.List, (1, 0), (1, 1), wx.EXPAND | wx.TOP | wx.ALIGN_RIGHT, 10)
		self.GetSizer().AddGrowableRow(1)
		self.GetSizer().AddGrowableCol(0)


	def Initialize(self):
		cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), self.Attribute[3:].replace(' ', ''))
		ref = cls()

		self.List.SetHeading(ref)

	def OnAdd(self, event):
		if self.ModuleName != None and self.ModulePath != None:
			objectEditor = ObjectEditor(Application.MainFrame, 'New ' + self.Attribute[3:], self.Attribute[3:] + ' Properties')
			cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), self.Attribute[3:].replace(' ', ''))
			ref = cls()
			objectEditor.Initialize(ref, self.ModuleName, self.ModulePath)
			objectEditor.Pack()
			objectEditor.ShowModal()
			if objectEditor.ButtonPressed == 'Ok':
				ref = objectEditor.GetValue()
				self.Objects.append(ref)
				self.List.AddDict(ref)
			objectEditor.Destroy()
		else:
			if self.Options != None:
				dlg = wx.TextEntryDialog(Application.MainFrame, 'Please enter the ' + self.Attribute + ' that you want to add to the list')
			else:
				dlg = wx.SingleChoiceDialog(Application.MainFrame, 'Please choose the ' + self.Attribute + ' that you want to add to the list', choices=self.Options.keys())
			result = dlg.ShowModal()
			if self.Options != None:
				value1 = dlg.GetValue()
				value2 = dlg.GetValue()
			else:
				value1 = self.Options.values()[dlg.GetStringSelection()]
				value2 = dlg.GetStringSelection()
			if result == wx.ID_OK:
				self.Objects.append(value)
				self.List.Append(value)
				dlg.Destroy()
		pass


	def OnEdit(self, event):
		if self.ModuleName != None and self.ModulePath != None and self.List.GetSelection() != wx.NOT_FOUND:
			objectEditor = ObjectEditor(Application.MainFrame, self.Attribute[3:] + ' Editor', self.Attribute[3:] + ' Properties')
			cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), self.Attribute[3:].replace(' ', ''))
			ref = cls()
			objectEditor.Initialize(ref, self.ModuleName, self.ModulePath)
			objectEditor.Pack()
			objectEditor.Show()
			objectEditor.SetValue(self.Objects[self.List.GetSelection()])
			objectEditor.ShowModal()
			if objectEditor.ButtonPressed == 'Ok':
				self.Objects[self.List.GetSelection()] = objectEditor.GetValue()
				self.List.Replace(self.List.GetSelection(), objectEditor.GetValue())
			objectEditor.Destroy()
		else:
			pass
		pass

	def OnDelete(self, event):
		if len(self.List.GetSelections()) > 0:
			indices = self.List.GetSelections()
			self.List.DeleteRows(indices)
			indices.sort()
			#print indices
			for i in range(0, len(indices)):
				#print 'Deleting' + str(indices[i])
				del self.Objects[indices[i] - i]
		pass

	def GetValue(self):
		return self.Objects

	def SetValue(self, valueList):
		if valueList != None and len(valueList) != 0:
			del self.Objects
			self.Objects = valueList
			self.List.SetValue(valueList)
		pass

class ObjectDictionary(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent)
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(ButtonPanel(self, {'&Add':self.OnAdd, '&Edit':self.OnEdit, '&Delete':self.OnDelete}), (0, 0), (1, 1), wx.ALIGN_RIGHT, 10)
		self.Objects = dict()
		self.List = wx.ListBox(self, -1)

		self.GetSizer().Add(self.List, (1, 0), (1, 1), wx.EXPAND | wx.TOP | wx.ALIGN_RIGHT, 10)
		self.GetSizer().AddGrowableRow(1)
		self.GetSizer().AddGrowableCol(0)

	def OnAdd(self, event):
		objectEditor = ObjectEditor(Application.MainFrame, 'New Dictionary Entry', 'Dictionary Entry')
		cls = getattr(imp.load_source('Miscellaneous', 'Miscellaneous.py'), 'DictionaryEntry')
		ref = cls()
		objectEditor.Initialize(ref, None, None)
		objectEditor.Pack()
		objectEditor.ShowModal()
		if objectEditor.ButtonPressed == 'Ok':
			ref = objectEditor.GetValue()
			self.Objects[ref['sName']] = ref['sValue']
			self.List.Append(ref['sName'] + ' : ' + str(ref['sValue']))
		objectEditor.Destroy()
		pass

	def OnEdit(self, event):
		'''objectEditor = ObjectEditor(Application.MainFrame, 'Object Editor')
		cls = getattr(imp.load_source('Miscellaneous', 'Miscellaneous.py'), 'Dictionary Entity')
		ref = cls()
		objectEditor.Initialize(ref, None, None)
		objectEditor.Pack()
		objectEditor.ShowModal()
		if objectEditor.ButtonPressed == 'Ok':
			ref = objectEditor.GetValue()
			self.Objects[ref['sName']] = ref['sValue']
			self.List.Append(functions.String(ref))
		objectEditor.Destroy()'''
		pass

	def OnDelete(self, event):
		if self.List.GetSelection() != wx.NOT_FOUND:
			index = self.List.GetSelection()
			self.List.Delete(index)
			del self.Objects[index]
		pass

	def GetValue(self):
		return self.Objects

	def SetValue(self, valueList):
		if valueList != None and len(valueList) != 0:
			##print dir(valueList)
			del(self.Objects)
			self.Objects = valueList
			self.List.Clear()

			for key, value in valueList.iteritems():
				self.List.Append(key + ' : ' + str(value))
		pass

class GenericForm(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent, -1)
		self.SetSizer(wx.GridBagSizer())
		self.Controls = dict()
		self.GetSizer().AddGrowableCol(1)

	def Initialize(self, ref):
		self.propertyCount = 0
		for i in range(0, len(ref.Attributes)):
			attribute = ref.Attributes[i]
			'''if attribute == 'sEntity Name':
				##print 'Adding entity chooser'
				self.AddEntityChooser(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sAttribute Name':
				#print 'Adding attribute chooser'
				self.AddAttributeChooser(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sTarget':
				self.AddTargetChooser(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			'''
			if attribute[0] == 's':
				#print 'Adding textfield'
				self.AddStringProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'i':
				self.AddIntegerProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'f':
				self.AddFloatProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'b':
				self.AddBooleanProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			pass
		pass

	def AddEntityChooser(self, attribute, options):
		entityList = functions.GetEntityList(Application.SourceFilePath)
		control = wx.ComboBox(self, -1, choices=entityList)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddTargetChooser(self, attribute, options):
		targetList = functions.GetTargets(Application.SourceFileName, Application.SourceFilePath)
		control = wx.ComboBox(self, -1, choices=targetList)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddAttributeChooser(self, attribute, options):
		attributeList = functions.GetEntityList(Application.SourceFilePath, Application.SourceFileName)
		control = wx.ComboBox(self, -1, choices=attributeList)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddStringProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self, -1, choices=options)
			control.SetSelection(0)
		else:
			control = wx.TextCtrl(self, -1)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddIntegerProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self, -1, choices=options)
			control.SetEditable(False)
		else:
			control = wx.SpinCtrl(self, -1)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.LEFT, 2)
		self.Controls[attribute] = control

	def AddFloatProperty(self, attribute):
		control = wx.TextCtrl(self, -1)
		self.GetSizer().Add(wx.StaticText(self, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.LEFT, 2)
		self.Controls[attribute] = control

	def AddBooleanProperty(self, attribute):
		control = wx.CheckBox(self, -1, attribute[1:])
		self.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 4)
		self.Controls[attribute] = control

	def GetValue(self):
		data = dict()
		for controlName, control in self.Controls.iteritems():
			data[controlName] = control.GetValue()
		return data

	def SetValue(self, values):
		for controlName, value in self.Controls.iteritems():
			self.Controls[controlName].SetValue(values[controlName])
		pass

	def SetEditable(self, editOrNot):
		for control in self.Controls:
			control.SetEditable(editOrNot)


class ObjectEditor(OkCancelDialog):

	def __init__(self, parent, title, MainPropertyName):
		OkCancelDialog.__init__(self, parent, title, {'Ok':self.OnOk, 'Cancel':self.OnCancel})
		self.MainPropertyName = MainPropertyName
		self.Tabs = wx.Notebook(self, -1)
		self.SetMainPanel(self.Tabs)
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		self.ObjectProperties = wx.Panel(self.TabContainer, -1);
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().Add(self.ObjectProperties, (0, 0), (1, 1), wx.ALL | wx.EXPAND, 10)
		self.ObjectProperties.SetSizer(wx.GridBagSizer())
		self.ObjectProperties.GetSizer().AddGrowableCol(1)
		self.Tabs.AddPage(self.TabContainer, self.MainPropertyName)
		self.Controls = dict()
		self.ButtonPressed = 'Cancel'

	def Initialize(self, ref, moduleName, modulePath):
		#print ref.Attributes
		self.ModuleName = moduleName
		self.ModulePath = modulePath
		self.Source = ref
		self.propertyCount = 0
		for i in range(0, len(ref.Attributes)):
			attribute = ref.Attributes[i]
			'''if attribute == 'sEntity Name':
				self.AddEntityChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sAttribute Name':
				self.AddAttributeChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sTarget':
				self.AddTargetChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			'''
			if attribute[0:3] == 'lst':
				self.AddObjectList(attribute)
			elif attribute[0:3] == 'dct':
				self.AddObjectDictionary(attribute)
			elif attribute[0:3] == 'arr':
				self.AddSimpleList(attribute, ref.Options[i])
			elif attribute[0] == 's':
				self.AddStringProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'i':
				self.AddIntegerProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'f':
				self.AddFloatProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'b':
				self.AddBooleanProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			else:
				self.AddForm(attribute)
				self.propertyCount = self.propertyCount + 1
		self.Controls[ref.Attributes[0]].SetFocus()

	def AddTargetChooser(self, attribute):
		targetList = functions.GetTargets(Application.SourceFileName, Application.SourceFilePath)
		control = wx.ComboBox(self.ObjectProperties, -1, choices=targetList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddEntityChooser(self, attribute):
		entityList = functions.GetEntityList(Application.SourceFilePath)
		control = wx.ComboBox(self.ObjectProperties, -1, choices=entityList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddAttributeChooser(self, attribute):
		attributeList = functions.GetAttributeList(Application.SourceFilePath, Application.SourceFileName)
		control = wx.ComboBox(self.ObjectProperties, -1, choices=attributeList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		#print 'Added Attribute Chooser at : ' + str((self.propertyCount, 1))
		self.Controls[attribute] = control

	def AddObjectDictionary(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectDictionary(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = self.ModuleName
		control.ModulePath = self.ModulePath
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass

	def AddObjectList(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectListEx(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = self.ModuleName
		control.ModulePath = self.ModulePath
		control.Initialize()
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass

	def AddSimpleList(self, attribute, options):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectList(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = None
		control.ModulePath = None
		control.Options = options
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass

	def AddStringProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self.ObjectProperties, -1, choices=options)
			control.SetSelection(0)
		else:
			control = wx.TextCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		##print 'Added Combo Box at ' + str((self.propertyCount, 1))
		self.Controls[attribute] = control

	def AddIntegerProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self.ObjectProperties, -1, choices=options)
			control.SetSelection(0)
		else:
			control = wx.SpinCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 2)
		self.Controls[attribute] = control

	def AddFloatProperty(self, attribute):
		control = wx.TextCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 2)
		self.Controls[attribute] = control

	def AddBooleanProperty(self, attribute):
		control = wx.CheckBox(self.ObjectProperties, -1, attribute[1:])
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 4)
		self.Controls[attribute] = control

	def AddForm(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = GenericForm(self.TabContainer)
		cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), attribute.replace(' ', ''))
		ref = cls()
		control.Initialize(ref)
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute)
		self.Controls[attribute] = control

	def Pack(self):
		if self.GetEffectiveMinSize().width/self.GetEffectiveMinSize().height < 2.0:
			self.SetSize((self.GetEffectiveMinSize().height * 2, self.GetEffectiveMinSize().height))
		if self.GetSize().height < 320:
			self.SetSize((640, 320))

	def OnOk(self, event):
		self.ButtonPressed = 'Ok'
		self.Hide()
		pass

	def OnCancel(self, event):
		self.ButtonPressed = 'Cancel'
		self.Hide()
		pass

	def GetValue(self):
		data = dict()
		for controlName, control in self.Controls.iteritems():
			data[controlName] = control.GetValue()
		self.Source.Values = data
		return data

	def SetValue(self, values):
		#print '*********************************'
		#print self.Controls
		#print values
		#print '*********************************'
		if values != None:
			for controlName, value in self.Controls.iteritems():
				if values[controlName] != None:
					self.Controls[controlName].SetValue(values[controlName])
		pass

class ObjectEditorPanel(wx.Panel):

	def __init__(self, parent, MainPropertyName):
		wx.Panel.__init__(self, parent, -1)
		self.MainPropertyName = MainPropertyName
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().AddGrowableRow(0)
		self.GetSizer().AddGrowableCol(0)
		self.Tabs = wx.Notebook(self, -1)
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		self.ObjectProperties = wx.Panel(self.TabContainer, -1);
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.TabContainer.GetSizer().AddGrowableRow(1)
		self.TabContainer.GetSizer().Add(ButtonPanel(self.TabContainer, {'&Save':self.OnSave, '&Reset':self.OnReset, '&Cancel':self.OnCancel}), (0, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALL, 10)
		self.TabContainer.GetSizer().Add(self.ObjectProperties, (1, 0), (1, 1), wx.ALL | wx.EXPAND, 10)
		self.ObjectProperties.SetSizer(wx.GridBagSizer())
		self.ObjectProperties.GetSizer().AddGrowableCol(1)
		self.Tabs.AddPage(self.TabContainer, self.MainPropertyName)
		self.GetSizer().Add(self.Tabs, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 0)
		self.Controls = dict()

	def Initialize(self, ref, moduleName, modulePath):
		self.ModuleName = moduleName
		self.ModulePath = modulePath
		self.Source = ref

		self.propertyCount = 0
		for i in range(0, len(ref.Attributes)):
			attribute = ref.Attributes[i]
			'''if attribute == 'sEntity Name':
				self.AddEntityChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sAttribute Name':
				self.AddAttributeChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute == 'sTarget':
				self.AddTargetChooser(attribute)
				self.propertyCount = self.propertyCount + 1
			'''
			if attribute[0:3] == 'lst':
				self.AddObjectList(attribute)
			elif attribute[0:3] == 'dct':
				self.AddObjectDictionary(attribute)
			elif attribute[0:3] == 'arr':
				self.AddSimpleList(attribute)
			elif attribute[0] == 's':
				self.AddStringProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'i':
				self.AddIntegerProperty(attribute, ref.Options[i])
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'f':
				self.AddFloatProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			elif attribute[0] == 'b':
				self.AddBooleanProperty(attribute)
				self.propertyCount = self.propertyCount + 1
			else:
				self.AddForm(attribute)
				self.propertyCount = self.propertyCount + 1

	def AddTargetChooser(self, attribute):
		targetList = functions.GetTargets(Application.SourceFileName, Application.SourceFilePath)
		control = wx.ComboBox(self.ObjectProperties, -1, choices=targetList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddEntityChooser(self, attribute):
		entityList = functions.GetEntityList(Application.SourceFilePath)
		control = wx.ComboBox(self.ObjectProperties, -1, choices=entityList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddAttributeChooser(self, attribute):
		attributeList = functions.GetAttributeList(Application.SourceFilePath, Application.SourceFileName)

		control = wx.ComboBox(self.ObjectProperties, -1, choices=attributeList)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		#print 'Added Attribute Chooser at : ' + str((self.propertyCount, 1))
		self.Controls[attribute] = control

	def AddObjectDictionary(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectDictionary(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = self.ModuleName
		control.ModulePath = self.ModulePath
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass

	def AddObjectList(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectListEx(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = self.ModuleName
		control.ModulePath = self.ModulePath
		control.Initialize()
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass


	def AddSimpleList(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = ObjectList(self.TabContainer)
		control.Attribute = attribute
		control.ModuleName = None
		control.ModulePath = None
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute[3:] + 's')
		self.Controls[attribute] = control
		pass

	def AddStringProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self.ObjectProperties, -1, choices=options)
			control.SetSelection(0)
		else:
			control = wx.TextCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL | wx.EXPAND, 2)
		self.Controls[attribute] = control

	def AddIntegerProperty(self, attribute, options):
		if options != None:
			control = wx.ComboBox(self.ObjectProperties, -1, choices=options)
			control.SetSelection(0)
		else:
			control = wx.SpinCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 2)
		self.Controls[attribute] = control

	def AddFloatProperty(self, attribute):
		control = wx.TextCtrl(self.ObjectProperties, -1)
		self.ObjectProperties.GetSizer().Add(wx.StaticText(self.ObjectProperties, -1, attribute[1:]), (self.propertyCount, 0), (1, 1), wx.ALL | wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_RIGHT, 2)
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 3)
		self.Controls[attribute] = control

	def AddBooleanProperty(self, attribute):
		control = wx.CheckBox(self.ObjectProperties, -1, attribute[1:])
		self.ObjectProperties.GetSizer().Add(control, (self.propertyCount, 1), (1, 1), wx.ALL, 4)
		self.Controls[attribute] = control

	def AddForm(self, attribute):
		self.TabContainer = wx.Panel(self.Tabs, -1)
		self.TabContainer.SetSizer(wx.GridBagSizer())
		control = GenericForm(self.TabContainer)
		cls = getattr(imp.load_source(self.ModuleName, self.ModulePath), attribute)
		ref = cls()
		control.Initialize(ref)
		self.TabContainer.GetSizer().Add(control, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)
		self.TabContainer.GetSizer().AddGrowableRow(0)
		self.TabContainer.GetSizer().AddGrowableCol(0)
		self.Tabs.AddPage(self.TabContainer, attribute)
		self.Controls[attribute] = control

	def GetValue(self):
		data = dict()
		for controlName, control in self.Controls.iteritems():
			data[controlName] = control.GetValue()
		self.Source.Values = data
		return data

	def SetValue(self, values):
		for controlName, value in self.Controls.iteritems():
			self.Controls[controlName].SetValue(values[controlName])
		pass

	def OnSave(self, event):
		pass

	def OnReset(self, event):
		pass

	def OnCancel(self, event):
		pass


class Application:
	@staticmethod
	def Initialize():
		Application.Saved = True
		Application.SavePath = None
		Application.Project = None
		Application.MainFrame = wx.Frame(None, -1, 'xCelestia v1.0')
		Application.MainFrame.SetSizer(wx.BoxSizer(wx.VERTICAL))
		Application.ClassesLocation = None

		functions.MainFrame = Application.MainFrame

		# Adding banner across the top
		BannerPic = wx.Image('logo1.jpg', wx.BITMAP_TYPE_ANY).ConvertToBitmap()
		BannerPanel = wx.Panel(Application.MainFrame, -1)
		BannerPanel.SetSizer(wx.BoxSizer(wx.VERTICAL))
		Banner = wx.StaticBitmap(BannerPanel, -1, BannerPic, (5, 5), (BannerPic.GetWidth(), BannerPic.GetHeight()))
		BannerPanel.GetSizer().Add(Banner, wx.ALIGN_RIGHT)
		BannerPanel.SetBackgroundColour(wx.Colour(0x41, 0x8d, 0x35))
		Application.MainFrame.GetSizer().Add(BannerPanel, 0, wx.EXPAND | wx.ALIGN_RIGHT)

		Application.SplitterWindow = wx.SplitterWindow(Application.MainFrame, -1)
		Application.MainFrame.GetSizer().Add(Application.SplitterWindow, 20, wx.EXPAND)
		Application.ProfilesPane = wx.Notebook(Application.SplitterWindow, -1)
		Application.ProfileEditor = ObjectEditorPanel(Application.SplitterWindow, 'Profile Properties')
		Application.ProfileEditor.Initialize(misc.Profile(), 'Miscellaneous', './Miscellaneous.py')
		Application.SplitterWindow.SplitVertically(Application.ProfilesPane, Application.ProfileEditor, 250)

		ProfilesContainer = wx.Panel(Application.ProfilesPane, -1)
		ProfilesContainer.SetSizer(wx.GridBagSizer())
		ProfilesButtonPanel = ButtonPanel(ProfilesContainer, {'Clone':Application.OnClone, 'Delete':Application.OnDelete})
		Application.ProfilesList = wx.ListBox(ProfilesContainer, -1)
		Application.ProfilesList.Bind(wx.EVT_LISTBOX, Application.OnSelectProfile, Application.ProfilesList)
		ProfilesContainer.GetSizer().AddGrowableRow(1)
		ProfilesContainer.GetSizer().AddGrowableCol(0)

		ProfilesContainer.GetSizer().Add(ProfilesButtonPanel, (0, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALL, 5)
		ProfilesContainer.GetSizer().Add(Application.ProfilesList, (1, 0), (1, 1), wx.EXPAND, 5)

		Application.ProfilesPane.AddPage(ProfilesContainer, 'Project Profiles')



		OutputWindow = wx.Notebook(Application.MainFrame, -1)
		Application.Console = wx.TextCtrl(OutputWindow, -1, style=wx.TE_MULTILINE)
		Application.Console.SetEditable(False)
		OutputWindow.AddPage(Application.Console, 'Output')

		Application.MainFrame.GetSizer().Add(OutputWindow, 8, wx.EXPAND)

		Application.MainFrame.Show()
		Application.MainFrame.Maximize()

		#Application.ProfilesPane.Disable()
		#Application.ProfileEditor.Disable()

		MenuBar = wx.MenuBar()

		FileMenu = wx.Menu()

		Item = FileMenu.Append(-1, '&New Project', 'Create a new project from the entity structure')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnNewProject, Item)
		Item = FileMenu.Append(-1, '&Open Project', 'Open Existing Project')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnOpenProject, Item)
		Item = FileMenu.AppendSeparator()
		Item = FileMenu.Append(-1, '&Save Project', 'Save Current Project')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnSave, Item)
		Item = FileMenu.Append(-1, 'Save Project &As', 'Save Current Project in a different path')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnSaveAs, Item)
		Item = FileMenu.AppendSeparator()
		Item = FileMenu.Append(-1, 'Save &Profile As', 'Save Current Project in a different path')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnSaveProfileAs, Item)
		Item = FileMenu.Append(-1, 'Save S&QL As', 'Save Current Project in a different path')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnSaveSQLAs, Item)
		Item = FileMenu.Append(-1, 'Save &Database Map As', 'Save Database map(php) into specified location')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnSaveDatabaseMap, Item)
		Item = FileMenu.AppendSeparator()
		Item = FileMenu.Append(-1, 'E&xit', 'Quit Application')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnExit, Item)

		MenuBar.Append(FileMenu, '&File')

		EditMenu = wx.Menu()

		Item = EditMenu.Append(-1, '&Project Properties', 'Edit Project Properties')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnEditProjectProperties, Item)
		Item = EditMenu.Append(-1, 'P&references', 'Edit Global Preferences related to xCelestia')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.Dummy, Item)

		MenuBar.Append(EditMenu, '&Edit')

		BuildMenu = wx.Menu()

		Item = BuildMenu.Append(-1, '&Build Project', 'Generate the Project Application')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.Dummy, Item)
		Item = BuildMenu.Append(-1, 'Build Current &Profile', 'Generate Application only for current profile')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.Dummy, Item)
		BuildMenu.AppendSeparator()
		Item = BuildMenu.Append(-1, 'Test &Run', 'Preview the Generated Application')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnPreview, Item)
		Item = BuildMenu.Append(-1, 'Build &Database', 'Build the database on server')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnBuildDatabase, Item)

		MenuBar.Append(BuildMenu, '&Build')

		OptionsMenu = wx.Menu()

		Item = OptionsMenu.Append(-1, '&Import Modules', 'Add External Modules to xCelestia')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.Dummy, Item)

		MenuBar.Append(OptionsMenu, '&Options')

		HelpMenu = wx.Menu()

		Item = HelpMenu.Append(-1, '&About xCelestia v1.0', 'About the Software')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.OnAbout, Item)
		Item = HelpMenu.Append(-1, '&Help Contents', 'Detailed help on various topics')
		Application.MainFrame.Bind(wx.EVT_MENU, Application.Dummy, Item)

		MenuBar.Append(HelpMenu, '&Help')

		Application.MainFrame.SetMenuBar(MenuBar)
		Application.MainFrame.CreateStatusBar()

	@staticmethod
	def OnDelete(event):
		index = Application.ProfilesList.GetSelection()
		if index != wx.NOT_FOUND:
			del Application.Project['lstProfile'][index]
			Application.ProfilesList.Delete(index)

	@staticmethod
	def OnNewProject(event):
		dlg = wx.FileDialog(Application.MainFrame, 'Select the Source File')
		dlg.Center()
		action = dlg.ShowModal()
		if action == wx.ID_OK:
			Application.SourceFilePath = dlg.GetPath()
			Application.SourceFileName = dlg.GetFilename()
			dlg.Destroy()
			Application.Project = functions.GetProject(functions.GetEntityList(Application.SourceFileName), Application.SourceFileName, Application.SourceFilePath)
			for profile in Application.Project['lstProfile']:
				Application.ProfilesList.Append(functions.String(profile))
			Application.ProfilesList.SetSelection(0)
			Application.ProfileEditor.SetValue(Application.Project['lstProfile'][0])
		pass

	@staticmethod
	def OnAbout(event):
		ad.AboutDialog(Application.MainFrame)

	@staticmethod
	def OnEditProjectProperties(event):
		dlg = ObjectEditor(Application.MainFrame, 'Project Properties', 'Project Properties')
		dlg.Initialize(misc.Project(), 'Miscellaneous', './Miscellaneous.py')
		dlg.Pack()
		dlg.SetValue(Application.Project)
		dlg.ShowModal()
		Application.Project = dlg.GetValue()
		dlg.Destroy()

	@staticmethod
	def Dummy(event):
		pass

	@staticmethod
	def OnExit(event):
		if Application.Saved == True:
			exit()
		else:
			dlg = wx.MessageDialog(Application.MainFrame, 'Project is not saved. Exiting now would result in loss of data.\nDo you still want to quit?', 'Warning', wx.YES | wx.NO | wx.ICON_EXCLAMATION)
			action = dlg.ShowModal()
			dlg.Destroy()
			if action == wx.ID_YES:
				exit()

	@staticmethod
	def OnSaveAs(event):
		if not Application.Project == None:
			dlg = wx.FileDialog(Application.MainFrame, 'Save file as', style=wx.FD_SAVE)
			dlg.Center()
			action = dlg.ShowModal()
			if action == wx.ID_OK:
				Application.SavePath = dlg.GetPath()
				filename = dlg.GetFilename()
				if not filename.endswith('.prj'):
					filename = filename + '.prj'
					Application.SavePath = Application.SavePath + '.prj'
				f = open(Application.SavePath, 'w')
				pickle.dump(Application.Project, f)
		else:
			dlg = wx.MessageDialog(Application.MainFrame, 'Not Project currently exists. Please create one and then save it.', 'Message', wx.OK | wx.CANCEL | wx.ICON_EXCLAMATION)
			dlg.ShowModal()
			dlg.Destroy()

	@staticmethod
	def OnSave(event):
		if not Application.Project == None:
			if Application.SavePath == None:
				Application.OnSaveAs(event)
			else:
				f = open(Application.SavePath, 'w')
				pickle.dump(Application.Project, f)
		else:
			dlg = wx.MessageDialog(Application.MainFrame, 'Not Project currently exists. Please create one and then save it.', 'Message', wx.OK | wx.CANCEL | wx.ICON_EXCLAMATION)
			dlg.ShowModal()
			dlg.Destroy()

	@staticmethod
	def OnOpenProject(event):
		dlg = wx.FileDialog(Application.MainFrame, 'Open Project')
		dlg.Center()
		action = dlg.ShowModal()
		if action == wx.ID_OK:
			Application.SavePath = dlg.GetPath()
			filename = dlg.GetFilename()
			f = open(Application.SavePath, 'r')
			Application.Project = pickle.load(f)
			for profile in Application.Project['lstProfile']:
				Application.ProfilesList.Append(functions.String(profile))
			Application.ProfilesList.SetSelection(0)
			Application.ProfileEditor.SetValue(Application.Project['lstProfile'][0])
		dlg.Destroy()

	@staticmethod
	def OnClone(event):
		index = Application.ProfilesList.GetSelection()
		if index != wx.NOT_FOUND:
			dlg = wx.TextEntryDialog(Application.MainFrame, 'Please enter the name of the new profile.')
			response = dlg.ShowModal()
			if response == wx.ID_OK:
				ref = Application.Project['lstProfile'][index]
				refNew = copy.deepcopy(ref)
				refNew['sProfile Name'] = dlg.GetValue()
				Application.Project['lstProfile'].append(refNew)
				Application.ProfilesList.Append(refNew['sProfile Name'])


	@staticmethod
	def OnSelectProfile(event):
		index = Application.ProfilesList.GetSelection()
		Application.ProfileEditor.SetValue(Application.Project['lstProfile'][index])


	@staticmethod
	def OnSaveProfileAs(event):
		index = Application.ProfilesList.GetSelection()
		if index != wx.NOT_FOUND:
			profile = Application.Project['lstProfile'][index]
			profile['Database Properties'] = Application.Project['Database Properties']
			dlg = wx.FileDialog(Application.MainFrame, 'Specify where to save the profile', style=wx.FD_SAVE)
			action = dlg.ShowModal()
			if action == wx.ID_OK:
				path = dlg.GetPath()
				f = open(path, 'w')
				pickle.dump(profile, f)
			dlg.Destroy()

	@staticmethod
	def OnPreview(event):
		index = Application.ProfilesList.GetSelection()
		if index != wx.NOT_FOUND:
			profile = Application.Project['lstProfile'][index]
		cl.Application(None, profile).Show()

	@staticmethod
	def OnSaveSQLAs(event):
		database = Application.Project['lstDatabase Table']
		dlg = wx.FileDialog(Application.MainFrame, 'Specify where to save the SQL file', style=wx.FD_SAVE)
		action = dlg.ShowModal()
		if action == wx.ID_OK:
			path = dlg.GetPath()
			if not path.endswith('.sql'):
				path = path + '.sql'
			f = open(path, 'w')
			f.write(dbp.GetDatabaseSQL(database, Application.Project['Database Properties']['sDatabase Name']))
		dlg.Destroy()

	@staticmethod
	def OnSaveDatabaseMap(event):
		dlg = wx.FileDialog(Application.MainFrame, 'Specify where to save the Database Map File', style=wx.FD_SAVE)
		action = dlg.ShowModal()
		if action == wx.ID_OK:
			database = Application.Project['lstDatabase Table']
			path = dlg.GetPath()
			if not path.endswith('.php'):
				path = path + '.php'
			f = open(path, 'w')
			f.write(dbp.GetDatabaseMap(database))
		dlg.Destroy()
		pass

	@staticmethod
	def OnBuildDatabase(event):
		database = Application.Project['lstDatabase Table']
		try:
			sql = dbp.GetDatabaseSQL(database, Application.Project['Database Properties']['sDatabase Name'])
			confirm = wx.MessageDialog(None, 'Are you sure you want to Rebuild the Database?\n This action would delete all data in the existing database and create it afresh', 'Confirm Action', wx.ICON_QUESTION | wx.YES_NO).ShowModal()
			if confirm == wx.ID_YES:
				connection = db.ConnectWithoutDatabase(Application.Project['Database Properties']['sServer Name'], Application.Project['Database Properties']['sUsername'], Application.Project['Database Properties']['sPassword'], Application.OnError)
				commands = sql.split(';')
				status = db.ExecuteBatch(commands, connection, Application.OnError)
			if status:
				wx.MessageDialog(None, 'Database and all tables Created Successfully.', 'Success').ShowModal()
		except TypeError, e:
			Application.OnError((2, 'Database properties have not been defined.\nPlease define the database properties first and then Build database'))
		pass

	@staticmethod
	def OnError(error):
		wx.MessageDialog(None, 'Some Error Occured. Error Code : %d\nError Message : %s' % (error[0], error[1]), 'Error').ShowModal()

