import wx
import Client as client

class DashBoard(wx.Panel):

	def __init__(self, parent, globalVars):
		wx.Panel.__init__(self, parent, -1)

	def Initialize(self, globalVars):
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.GetSizer().Add(wx.StaticText(self, -1, 'Dash Board'), 0, wx.EXPAND)
