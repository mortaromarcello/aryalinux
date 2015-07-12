import wx

class CardPanel(wx.Panel):

	def __init__(self, parent):
		wx.Panel.__init__(self, parent, -1)
		self.Screens = dict()
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().AddGrowableRow(0)
		self.GetSizer().AddGrowableCol(0)

	def AddScreen(self, screen, name):
		self.Screens[name] = screen
		self.SwitchScreen(self.Screens.keys()[0])
		self.GetSizer().Layout()

	def SwitchScreen(self, screenName):
		for title in self.Screens.keys():
			self.GetSizer().Remove(self.Screens[title])
			self.Screens[title].Hide()
		self.GetSizer().Add(self.Screens[screenName], (0, 0), (1, 1), wx.EXPAND)
		self.Screens[screenName].Show()
		self.GetSizer().Layout()

	def GetScreenByName(self, screenName):
		for name, screen in self.Screens.iteritems():
			if name == screenName:
				return screen
		return None



