import wx

class ListBox(wx.ListBox):

	def __init__(self, parent):
		wx.ListBox.__init__(self, parent, -1)
		self.Options = dict()

	def Initialize(self, options):
		for key, value in options.iteritems():
			self.Options[key] = value
			self.Append(key)

	def SetValue(self, str):
		for key, value in self.Options.iteritems():
			if value == str:
				super(ListBox, self).SetValue(key)
				return
		super(ListBox, self).SetValue(str)

	def GetValue(self, str):
		return self.Options[str]


