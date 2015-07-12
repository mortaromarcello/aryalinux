import wx
import ButtonPanel as bp

class OkCancelDialog(wx.Dialog):

	def __init__(self, parent, title, buttons, globalVars, style):
		wx.Dialog.__init__(self, parent, -1, title, style=style)
		self.Buttons = buttons
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(wx.StaticLine(self, -1), (1, 0), (1, 1), wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 10)
		self.GetSizer().AddGrowableRow(0);
		self.GetSizer().AddGrowableCol(0);
		self.GetSizer().Add(bp.ButtonPanel(self, buttons, globalVars), (2, 0), (1, 1), wx.LEFT | wx.RIGHT | wx.BOTTOM | wx.ALIGN_RIGHT, 10)

	def SetMainPanel(self, mainPanel):
		self.GetSizer().Add(mainPanel, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 10)


