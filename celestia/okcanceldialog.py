import wx
import sys
sys.path.append('.')

import okcancelpanel

class OkCancelDialog(wx.Dialog):
	def __init__(self, parent):
		super(OkCancelDialog, self).__init__(parent=parent)
		self.SetSizer(wx.FlexGridSizer(2, 1, 1, 1))
		self.GetSizer().AddGrowableRow(0)
		self.GetSizer().AddGrowableCol(0)
		self.MainPanel = wx.Panel(self, -1)
		self.MainPanel.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.GetSizer().Add(self.MainPanel, 1, wx.EXPAND|wx.ALL, 1)
		self.OkCancelPanel = okcancelpanel.OkCancelPanel(self)
		self.GetSizer().Add(self.OkCancelPanel, 1, wx.EXPAND|wx.ALIGN_RIGHT|wx.ALL, 1)

	def Add(self, control):
		self.MainPanel.GetSizer().Add(control, 1, wx.EXPAND|wx.ALL, 1)

	def GetMainPanel(self):
		return self.MainPanel
