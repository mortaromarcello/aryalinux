import wx

class OkCancelPanel(wx.Panel):
	def __init__(self, parent):
		super(OkCancelPanel, self).__init__(parent)
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.InnerPanel = wx.Panel(self, -1)
		self.GetSizer().Add(self.InnerPanel, -1, wx.ALL|wx.ALIGN_RIGHT, 0)
		self.Ok = wx.Button(self.InnerPanel, wx.ID_OK, 'Ok')
		self.Cancel = wx.Button(self.InnerPanel, wx.ID_CANCEL, 'Cancel')
		self.InnerPanel.SetSizer(wx.GridSizer(1, 2))
		self.InnerPanel.GetSizer().Add(self.Ok, 1, wx.EXPAND|wx.ALL, 2)
		self.InnerPanel.GetSizer().Add(self.Cancel, 1, wx.EXPAND|wx.ALL, 0)
