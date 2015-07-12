import wx

class Table(wx.ListCtrl):

	def __init__(self, parent):
		wx.ListCtrl.__init__(self, parent, -1, style=wx.LC_REPORT)
		self.ColCount = 0
		self.RowCount = 0
		self.SelectedIndex = -1
		self.Columns = list()

	def GetSelections(self):
		selections = list()
		itemIndex = -1;
		while True:
			itemIndex = self.GetNextItem(itemIndex, wx.LIST_NEXT_ALL, wx.LIST_STATE_SELECTED);
			if (itemIndex == -1):
				break
			selections.append(itemIndex)
		return selections

	def AddColumn(self, columnHeading):
		self.InsertColumn(self.ColCount, columnHeading)
		self.ColCount = self.ColCount + 1

	def AddColumnName(self, columnName):
		self.Columns.append(columnName.replace('REPORT_COLUMN : ', ''))

	def Delete(self, rowIndex):
		self.DeleteItem(rowIndex)
		if self.SelectedIndex == rowIndex:
			self.SelectedIndex = -1

	def AddRow(self, rowAsDict):
		if len(rowAsDict) > 0:
			keys = rowAsDict.keys()
			if rowAsDict[self.Columns[0]] != None:
				val = str(rowAsDict[self.Columns[0]])
			else:
				val ='N.A.'
			self.InsertStringItem(self.RowCount, val)
			for i in range(1, len(self.Columns)):
				if rowAsDict[self.Columns[i]] != None:
					val = str(rowAsDict[self.Columns[i]])
				else:
					val ='N.A.'
				self.SetStringItem(self.RowCount, i, val)
			if self.RowCount%2 != 0:
				self.SetItemBackgroundColour(self.RowCount, wx.Colour(225, 225, 225))
			self.RowCount = self.RowCount + 1
		for i in range(0, len(keys)):
			self.SetColumnWidth(i, wx.LIST_AUTOSIZE)
		for i in range(0, len(keys)):
			if self.GetColumnWidth(i) < 150:
				self.SetColumnWidth(i, 150)

	def SetRow(self, index, rowAsDict):
		if len(rowAsDict) > 0:
			keys = rowAsDict.keys()
			for i in range(1, len(self.Columns)):
				if rowAsDict[self.Columns[i]] != None:
					val = str(rowAsDict[self.Columns[i]])
				else:
					val =''
				self.SetStringItem(index, i, val)
			if index%2 != 0:
				self.SetItemBackgroundColour(index, wx.Colour(225, 225, 225))
		for i in range(0, len(keys)):
			self.SetColumnWidth(i, wx.LIST_AUTOSIZE)
		for i in range(0, len(keys)):
			if self.GetColumnWidth(i) < 150:
				self.SetColumnWidth(i, 150)

	def SetValue(self, objects):
		self.Clear()
		self.RowCount = 0
		for ref in objects:
			self.AddRow(ref)
		self.SelectedIndex = -1

	def Reset(self):
		self.Clear()

	def Clear(self):
		self.DeleteAllItems()
		self.RowCount = 0

