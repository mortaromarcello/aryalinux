import wx

class ComboBox(wx.ComboBox):

	def __init__(self, parent):
		wx.ComboBox.__init__(self, parent, -1)
		self.Options = dict()

	def Initialize(self, options):
		for key, value in options.iteritems():
			self.Options[key] = value
			self.Append(key)

	def SetValue(self, str):
		for key, value in self.Options.iteritems():
			if value == str:
				super(ComboBox, self).SetValue(key)
				return
		super(ComboBox, self).SetValue(str)

	def GetValue(self):
		return self.Options[self.GetStringSelection()]


